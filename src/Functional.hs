import           Data.List

--
splitLines :: String -> [String]
splitLines cs =
  let (pre, suf) = break isLineTerminator cs
  in pre :
     case suf of
       ('\r':'\n':rest) -> splitLines rest
       ('\r':rest)      -> splitLines rest
       ('\n':rest)      -> splitLines rest
       _                -> []

isLineTerminator c = c == '\r' || c == '\n'

fixLines :: String -> String
fixLines input = unlines (splitLines input)

-- 中缀函数
-- 通常，当我们在Haskell中定义和应用一个函数的时候，我们写这个函数的名称，紧接着它的参数。这种表示法作为前缀被提及，因为这个函数的名称位于它的参数前面。
-- 如果一个函数或构造器带两个或更多的参数，我们可以选择使用中缀形式，即我们把函数（名称）放在它的第一个和第二个参数之间。这允许我们把函数作为中缀操作符来使用。
-- 要用中缀表示法定义或应用一个函数或值构造器，我们用重音符（有时被称为反引号）包围它的名称。这里有简单的中缀函数和中缀类型的定义。
a `plus` b = a + b

--data a `Pair` b =
--  a `Pair` b
--  deriving (Show)
--
--foo = Pair 1 2
--
--bar = True `Pair` "quux"
-- 和列表打交道
l = [1, 2, 3, 4]

lenL = length l

nullL = null l

headL = head l

tailL = tail l

lastL = last l

initL = init l

concatL = concat [[1, 2, 3], [4, 5, 6]]

reverseL = reverse l

andL = and [True, False, True]

orL = or [True, False, True]

allL = all odd l

anyL = any odd l

takeL = take 3 l

dropL = drop 3 l

splitL = splitAt 3 l

takeWhileL = takeWhile odd [1, 3, 5, 6, 7] -- [1,3,5]

dropWhileL = dropWhile odd [1, 3, 5, 6, 7] -- [6,7]

spanL = span even [2, 4, 6, 7, 9, 10, 11] -- ([2,4,6],[7,9,10,11])

breakL = break even [1, 3, 5, 6, 8, 9, 10] --([1,3,5],[6,8,9,10])

elemL = 2 `elem` [1, 2, 3] -- True

notElemL = 2 `notElem` [1, 2, 3]

filterL = filter odd [1, 2, 3, 4]

-- 在Data.List模块中，有三个谓词方法，isPrefixOf、isInfixOf和isSuffixOf，能让我们测试一下子列表在一个更大的列表中出现的位置。
-- isPrefixOf函数告诉我们左边的列表是否出现在右边的列表的开始处
isPrefixOfL = "foo" `isPrefixOf` "foobar"

-- isInfixOf函数标示左边的列表是否是右边的列表的一个子列表。
isInfixOfL = [2, 6] `isInfixOf` [1, 2, 6, 7, 8] -- True

-- isSuffixOf函数的功能不再赘述
isSuffixOfL = ".c" `isSuffixOf` "crashme.c"

-- 一次性处理多个列表
-- zip函数把两个列表压缩成一个单一的由二元组组成的列表。结果列表和被处理的两个列表中较短的那个等长。（译注：言下之意是较长的那个列表中的多出来的元素会被丢弃）
zipL = zip [12, 72, 93] "zippity" -- [(12,'z'),(72,'i'),(93,'p')]

-- 更有用的是zipWith函数，它带两个列表作为参数并为从每个列表中抽取一个元素而组成的二元组提供一个函数，最后生成与较短的那个列表等长的新列表。
zipWithL = zipWith (+) [1, 2, 3] [4, 5, 6] -- [5,7,9]

-- 特殊的字符串处理函数
-- lines函数，它有个对应的函数，unlines。注意unlines总是在它处理的结果（译注：列表中的每个元素）的尾部放一个换行符。
linesL = lines "foo\nbar" -- ["foo","bar"]

unlinesL = unlines ["foo", "bar"] -- "foo\nbar\n"

-- words函数利用任何空白字符分割一个字符串，它对应的函数，unwords，用一个空格字符把一个字符串构成的列表连接起来。
wordsL = words "the  \r  quick \t  brown\n\n\nfox" -- ["the","quick","brown","fox"]

unwordsL = unwords ["jumps", "over", "the", "lazy", "dog"] -- "jumps over the lazy dog"
