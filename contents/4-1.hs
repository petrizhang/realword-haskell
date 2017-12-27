-------------------------------------------------------------------
---- 1.自己写一些安全的列表函数，确保它们不会出错。下面给一些类型定义的提示。
--safeHead :: [a] -> Maybe a
--safeTail :: [a] -> Maybe [a]
--safeLast :: [a] -> Maybe a
--safeInit :: [a] -> Maybe [a]
safeHead :: [a] -> Maybe a
safeHead l
  | null l = Nothing
  | otherwise = Just (head l)

safeTail :: [a] -> Maybe [a]
safeTail l
  | null l = Nothing
  | otherwise = Just (tail l)

safeLast :: [a] -> Maybe a
safeLast l
  | null l = Nothing
  | otherwise = Just (last l)

safeInit :: [a] -> Maybe [a]
safeInit l
  | null l = Nothing
  | otherwise = Just (init l)

r0 = safeHead []

r1 = safeTail []

r2 = safeLast []

r3 = safeInit []

-- 写一个和words功能近似的函数splitWith，要求带一个谓词和一个任意类型元素组成的列表，在使谓词返回False的元素处分割这个列表。
-- splitWith :: (a -> Bool) -> [a] -> [[a]]
splitWith :: (a -> Bool) -> [a] -> [[a]]
splitWith preicate [] = []
splitWith predicate (x:xs) = splitWithHelp [x] xs
  where
    splitWithHelp left [] = [left, []]
    splitWithHelp left (x:xs)
      | predicate x = splitWithHelp (left ++ [x]) xs
      | otherwise = [left, x : xs]

-- 利用在“一个简单的命令行框架”一节中创建的命令行框架，编写一个打印输入数据的每一行的第一个单词的程序。
-- 编写一个转置一个文件中的文本的程序。比如，它应该把“hello\nworld\n”转换成“hw\neo\nlr\nll\nod\n”。
transformTxt txt = transform charMatrix
  where
    charMatrix = lines txt

transform = transformHelp [] 0

transformHelp transformed n matrix
  | null nthCol = transformed
  | otherwise = transformHelp (transformed ++ [nthCol]) (n + 1) matrix
  where
    nthCol = getNthCol n matrix

getNthCol n matrix = concat (map (getOrEmpty n) matrix)

getOrEmpty n l
  | n >= (length l) = []
  | otherwise = [l !! n]
