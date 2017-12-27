module Prettify where

import           Data.Bits  (shiftR, (.&.))
import           Data.Char  (ord)
import           Numeric    (showHex)
import           SimpleJSON

data Doc
  = Empty
  | Char Char
  | Symbol Char
  | Text String
  | Line
  | Concat Doc
           Doc
  | Union Doc
          Doc
  deriving (Show, Eq)

-------------------------------------------
-- constructors
-------------------------------------------
empty :: Doc
empty = Empty

char :: Char -> Doc
char c = Char c

symbol :: Char -> Doc
symbol ','  = Symbol ','
symbol ':'  = Symbol ':'
symbol '['  = Symbol '['
symbol ']'  = Symbol ']'
symbol '{'  = Symbol '{'
symbol '}'  = Symbol '}'
symbol '"'  = Symbol '"'
symbol '\'' = Symbol '\''
symbol ' '  = Symbol ' '
symbol '\n' = Symbol '\n'

text :: String -> Doc
text "" = Empty
text s  = Text s

-- |construct Doc form double
-- 1 -> Text 1
double :: Double -> Doc
double d = text (show d)

-- |construct a string literal Doc from a string
-- eg: "z\n" -> "\"z\\n\""
-- 将 oneChar 函数应用于字符串的每一个字符，然后把拼接起来的结果放入引号中。
string :: String -> Doc
string = enclose '"' '"' . hcat . map oneChar

-- |把一个 Doc 值用起始字符和终止字符包起来
-- eg:
-- enclose '[' ']' (Text "1") -> Concat (Concat (Char '[') (Text "1")) (Char ']')
enclose :: Char -> Char -> Doc -> Doc
enclose left right x = symbol left <> x <> symbol right

-- |将多个 Doc 值拼接成一个，类似列表中的 concat 函数
-- eg:
-- d=Text "a"; hcat [d,d,d] -> Concat (Text "a") (Concat (Text "a") (Text "a"))
hcat :: [Doc] -> Doc
hcat = fold (<>)

-- |连接两个doc为一个
-- text "zhang" <> text "peng" -> Concat (Text "zhang") (Text "peng")
(<>) :: Doc -> Doc -> Doc
Empty <> y = y
x <> Empty = x
x <> y = x `Concat` y

-- |fold function f on a Doc list
fold ::
     (Doc -> Doc -> Doc) -- ^ f
  -> [Doc] -- ^Doc list
  -> Doc
fold f = foldr f empty

-- |转义一个字符
-- 可见的ascii直接输出，例如：'c -> Char 'c'
-- 不可见的ascii和unicode要进行转义，如：
-- '字' -> Concat (Text "\\u") (Text "5b57")
-- '\31' -> Concat (Concat (Text "\\u") (Text "00")) (Text "1f")
oneChar :: Char -> Doc
oneChar c =
  case lookup c simpleEscapes of
    Just r -> text r
    Nothing
      | mustEscape c -> hexEscape c
      | otherwise -> char c
  where
    mustEscape c = c < ' ' || c == '\x7f' || c > '\xff'

-- |转义字符对应表
-- [('\b',"\\b"),('\n',"\\n"),('\f',"\\f"),('\r',"\\r"),('\t',"\\t"),('\\',"\\\\"),('"',"\\\""),('/',"\\/")]
simpleEscapes :: [(Char, String)]
simpleEscapes = zipWith ch "\b\n\f\r\t\\\"/" "bnfrt\\\"/"
  where
    ch a b = (a, ['\\', b])

-- |将一个unicode字符转义为Doc
-- eg
-- '字' -> Concat (Text "\\u") (Text "5b57")
hexEscape :: Char -> Doc
hexEscape c
  | d < 0x10000 = smallHex d
  | otherwise = astral (d - 0x10000)
  where
    d = ord c

smallHex :: Int -> Doc
smallHex x = text "\\u" <> text (replicate (4 - length h) '0') <> text h
  where
    h = showHex x ""

astral :: Int -> Doc
astral n = smallHex (a + 0xd800) <> smallHex (b + 0xdc00)
  where
    a = (n `shiftR` 10) .&. 0x3ff
    b = n .&. 0x3ff

-- |l硬换行
line :: Doc
line = Line

-- | 批量列表转换，接受起始符open，终止符close，函数f，列表l
-- 首先执行 map f l，即对列表的每个元素执行函数f，将每个元素转为Doc，得到[d:Doc]
-- 然后执行 punctuate (char ',') [d:Doc]，将其使用逗号分隔得到[d1:Doc]
-- 然后执行 fsep [d1:Doc] 对列表使用软换行分隔并且连接成一个Doc，得到 d2
-- 然后调用enclose给d2加上首尾(open和close)
series ::
     Char -- ^ open 起始符
  -> Char -- ^ close 终止符
  -> (a -> Doc) -- ^ f 函数
  -> [a] -- ^ a类型的列表
  -> Doc -- ^ 返回值
series open close f = enclose open close . fsep . punctuate (symbol ',') . map f

punctuate :: Doc -> [Doc] -> [Doc]
punctuate p []     = []
punctuate p [d]    = [d]
punctuate p (d:ds) = (d <> p) : punctuate p ds

-- |将一个Doc list内的全部元素用软换行连接
fsep :: [Doc] -> Doc
fsep = fold (</>)

-- |将两个Doc用软换行连接
(</>) :: Doc -> Doc -> Doc
x </> y = x <> softline <> y

-- |软换行，一行放不下的时候
-- 如果当前行变得太长，softline 函数就插入一个新行，否则就插入一个空格。 Doc 并没有包含“怎样才算太长”的信息，
-- 这该怎么实现呢？ 答案是每次碰到这种情况，我们使用 Union 构造器来用两种不同的方式保存文档。
softline :: Doc
softline = group line

group :: Doc -> Doc
group x = flatten x `Union` x

flatten :: Doc -> Doc
flatten (x `Concat` y) = flatten x `Concat` flatten y
flatten Line           = symbol ' '
flatten (x `Union` _)  = flatten x
flatten other          = other
