-- 1.运用 fold （运用合适的fold将会使你的代码更简单）重写并扩展位于＂显式递归＂章节的 asInt 函数
import           Data.Char   (digitToInt, intToDigit, isDigit)
import           Text.Printf

maxIntString = show (maxBound :: Int)

maxIntLength = length maxIntString

asIntFold :: String -> Int
asIntFold s =
  case s of
    ""      -> 0
    "-"     -> 0
    ('+':r) -> asIntFoldCompute r
    ('-':r) -> -(asIntFoldCompute r)
    _       -> asIntFoldCompute s

asIntFoldCompute s
  | sLength > maxIntLength = error err_overflow
  | sLength == maxIntLength && pad s > maxIntString = error err_overflow
  | otherwise = foldl step 0 s
  where
    step acc e
      | not (isDigit e) = error (printf err_nondigit e)
      | otherwise = acc * 10 + digitToInt e
    sLength = length s
    err_overflow = printf "int overflow, the input should be in range [%s, %s]" maxIntString maxIntString
    err_nondigit = "non-digit '%c'"
    sPadded = pad s

pad s = (replicate paddingLength '0') ++ s
  where
    paddingLength = maxIntLength - length s

-- 2. asInt_fold 函数使用 error, 因而调用者不能处理这些错误．重写他来修复这个问题．
-- file: ch04/ch04.exercises.hs
-- type ErrorMessage = String
-- asIntEither :: String -> Either ErrorMessage Int
-- 太简单了我就不写了
skip2 = True

------------------------------------
-- 3.Prelude下面的函数 concat 将一个列表的列表连接成一个单独的列表．他的函数签名如下．
-- concat :: [[a]] -> [a]
-- 用foldr写出你自己山寨的concat．
myConcat :: [[a]] -> [a]
myConcat ls = foldr step [] ls
  where
    step left right = left ++ right

-- 4. 写出你自己山寨的 takeWhile 函数，首先用显式递归的手法，然后改成 foldr 形式．
myTakeWhileRec :: (a -> Bool) -> [a] -> [a]
myTakeWhileRec = myTakeWhileRecHelp []
  where
    myTakeWhileRecHelp :: [a] -> (a -> Bool) -> [a] -> [a]
    myTakeWhileRecHelp result predicate [] = result
    myTakeWhileRecHelp result predicate (x:xs)
      | predicate x = myTakeWhileRecHelp (result ++ [x]) predicate xs
      | otherwise = result

-- 用foldl实现了，foldr转换一下即可
-- 原理仍然是用函数参数保存状态
myTakeWhileFold :: (a -> Bool) -> [a] -> [a]
myTakeWhileFold predicate [] = []
myTakeWhileFold predicate l = fst (foldl step ([], False) l)
  where
    step (result, ended) e
      | ended = (result, ended)
      | predicate e = (result ++ [e], False)
      | otherwise = (result, True)

myFoldlWithFoldr :: (r -> e -> r) -> r -> [e] -> r
myFoldlWithFoldr f zero l = foldr step id l zero
  where
    step element func param = func (f param element) -- step :: e -> (r -> r) -> r -> r

-- 5. Data.List 模块定义了一个函数, groupBy.其拥有如下签名．
-- file: ch04/ch04.exercises.hs
-- groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
-- 运用 ghci 加载 Data.List 模块以理解 groupBy 的行为，然后写出你自己山寨的 fold 实现．
myGroupBy :: (a -> a -> Bool) -> [a] -> [[a]]
myGroupBy eq [] = []
myGroupBy eq l = foldr step [] l
  where
    step e [] = [[e]]
    step e ((x:xs):xss)
      | x `eq` e = (e : x : xs) : xss
      | otherwise = [e] : (x : xs) : xss

-- -- 下面Prelude函数能用 fold 系列函数重写的函数有多少？
-- any, cycle, words, unlines
-- 这些函数你能用 foldl 或者 foldr 重写，请问那种情况更合适？
skip6 = True
