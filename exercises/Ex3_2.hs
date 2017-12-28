module Ex3_2 where

---------------------------------------------------------------------------------------
-- 1.写一个函数，用来计算一个列表元素的个数．出于测试要求，保证其输出的结果和标准函数 length 保持一致．
-- 2.添加函数的类型签名于你的源文件．出于测试要求，再次加载源文件到ghci．
mylen :: [a] -> Int
mylen (x:xs) = 1 + (mylen xs)
mylen []     = 0

---------------------------------------------------------------------------------------
-- 3.写一个函数，用来计算列表的平均值，即，列表元素的总和除以列表的长度．(你可能需要用到 fromIntegral 函数将列表长度变量从 integer 类型到 float 类型进行转换．)
mysum (x:xs) = x + (mysum xs)
mysum []     = 0

myavg x = (mysum x) / (fromIntegral (length x))

---------------------------------------------------------------------------------------
-- 4.将一个列表变成回文序列，即，他应该读起来完全一样，不管是从前往后还是从后往前．举个例子，考虑一个列表 [1,2,3]，你的函数应该返回 [1,2,3,3,2,1]．
myreverse :: [a] -> [a]
myreverse (x:xs) = (myreverse xs) ++ [x]
myreverse []     = []

palindromeList :: [a] -> [a]
palindromeList l = l ++ (myreverse l)

---------------------------------------------------------------------------------------
-- 5.写一个函数，用来确定他的输入是否是一个回文序列．
getMid []  = []
getMid [x] = [x]
getMid l   = tail (init l)

isPalindrome
  :: Eq a
  => [a] -> Bool
isPalindrome [] = True
isPalindrome [x] = True
isPalindrome l = firstE == lastE && isPalindrome midL
  where
    firstE = head l
    lastE = last l
    midL = getMid l

---------------------------------------------------------------------------------------
-- 6.创造一个函数，用于排序一个包含许多列表的列表，其排序规则基于他的子列表的长度．（你可能要看看 Data.List 模块的 sortBy 函数．）
-- fetch next batch
-- for input (lx, ly)
-- get output ([the smaller one in two lists' first elements], remain of lx, remain of ly)
-- e.g. [1,3] [2,4] -> ([1],[3],[2,4])
nextBatch
  :: Ord a
  => [a] -> [a] -> ([a], [a], [a])
nextBatch [] [] = ([], [], [])
nextBatch [] (y:ys) = ([y], [], ys)
nextBatch (x:xs) [] = ([x], xs, [])
nextBatch (x:xs) (y:ys)
  | x < y = ([x], xs, y : ys)
  | otherwise = ([y], x : xs, ys)

-- merge two ordered list lx and ly to result
myMergeHelp
  :: Ord a
  => [a] -> [a] -> [a] -> [a]
myMergeHelp result [] [] = result
myMergeHelp result lx ly = myMergeHelp (result ++ smallerHeadListed) xRemain yRemain
  where
    (smallerHeadListed, xRemain, yRemain) = nextBatch lx ly

-- merge 2 ordered list
myMerge
  :: Ord a
  => [a] -> [a] -> [a]
myMerge = myMergeHelp []

myMergeSort
  :: Ord a
  => [a] -> [a]
myMergeSort [] = []
myMergeSort [x] = [x]
myMergeSort l = myMerge (myMergeSort leftList) (myMergeSort rightList)
  where
    midPoint = floor (fromIntegral (length l) / 2)
    leftList = take midPoint l
    rightList = drop midPoint l

---------------------------------------------------------------------------------------
-- 6.创造一个函数，用于排序一个包含许多列表的列表，其排序规则基于他的子列表的长度．（你可能要看看 Data.List 模块的 sortBy 函数．）
-- fetch next batch
-- for input (lx, ly)
-- get output ([the smaller one in two lists' first elements], remain of lx, remain of ly)
-- e.g. [1,3] [2,4] -> ([1],[3],[2,4])
nextBatchBy :: [a] -> [a] -> (a -> a -> Integer) -> ([a], [a], [a])
nextBatchBy [] [] _ = ([], [], [])
nextBatchBy [] (y:ys) _ = ([y], [], ys)
nextBatchBy (x:xs) [] _ = ([x], xs, [])
nextBatchBy (x:xs) (y:ys) compareFunc
  | compareFunc x y < 0 = ([x], xs, y : ys)
  | otherwise = ([y], x : xs, ys)

-- merge two ordered list lx and ly to result
myMergeHelpBy :: [a] -> [a] -> [a] -> (a -> a -> Integer) -> [a]
myMergeHelpBy result [] [] _ = result
myMergeHelpBy result lx ly compareFunc = myMergeHelpBy (result ++ smallerHeadListed) xRemain yRemain compareFunc
  where
    (smallerHeadListed, xRemain, yRemain) = nextBatchBy lx ly compareFunc

-- merge 2 ordered list
myMergeBy :: [a] -> [a] -> (a -> a -> Integer) -> [a]
myMergeBy = myMergeHelpBy []

myMergeSortBy :: [a] -> (a -> a -> Integer) -> [a]
myMergeSortBy [] _ = []
myMergeSortBy [x] _ = [x]
myMergeSortBy l compareFunc =
  myMergeBy (myMergeSortBy leftList compareFunc) (myMergeSortBy rightList compareFunc) compareFunc
  where
    midPoint = floor (fromIntegral (length l) / 2)
    leftList = take midPoint l
    rightList = drop midPoint l

---------------------------------------------------------------------------------------
-- 7.定义一个函数，其用一个分隔符将一个包含许多列表的列表连接在一起．函数类型定义如下：
intersperse :: a -> [[a]] -> [a]
intersperse seprator []      = []
intersperse seprator [x]     = x
intersperse separator (x:xs) = x ++ separator : (intersperse separator xs)

---------------------------------------------------------------------------------------
-- 8.使用我们在前面章节中定义的二叉树类型，写一个函数用于确定一棵二叉树的高度．高度的定义是从根节点到叶子节点经过的最大节点数．举个例子，Empty 这棵树的高度是0; Node "x" Empty Empty 这棵树的高度是1; Node "x" Empty (Node "y" Empty Empty) 这棵树的高度是2;依此类推．
data Tree a
  = Node a
         (Tree a)
         (Tree a)
  | Empty
  deriving (Show)

treeHeight Empty = 0
treeHeight (Node parent left right) = 1 + max (treeHeight left) (treeHeight right)

tree0 = Empty

tree1 = Node "x" Empty Empty

tree2 = Node "x" Empty (Node "y" Empty Empty)

tree3 = Node "0" tree1 tree2

h0 = treeHeight tree0 -- 0

h1 = treeHeight tree1 -- 1

h2 = treeHeight tree2 -- 2h3

h3 = treeHeight tree3 -- 3

---------------------------------------------------------------------------------------
-- 9.考虑三个二维的点 a, b，和c．如果我们观察沿着线段ＡＢ（由a,b节点组成）和线段ＢＣ（由b,c节点组成）形成的角度，它或者转向（turn）左边，或者转向右边，或者组成一条直线．定义一个 Direction（方向）的数据类型反映这些可能的情况．
data Direction
  = LeftDirection
  | RightDirection
  | LineDirection

---------------------------------------------------------------------------------------
-- 10.写一个函数，用于计算三个二维坐标点组成的转向（turn），并且返回其 Direction（方向）．
skip10 = True

---------------------------------------------------------------------------------------
-- 11.定义一个函数，输入二维坐标点的序列并计算其每个连续三个的（方向）Direction．考虑一个点的序列 [a,b,c,d,e]，他应该开始计算 [a,b,c]的转向(turn), 接着计算 [b,c,d]的转向，再是[c,d,e]的．你的函数应该返回一个Direction（方向）的序列．
skip11 = True

-- 12.运用前面三个练习的代码，实现 Graham 扫描算法，用于扫描由二维点集构成的凸包．你能从 `Wikipedia<http://en.wikipedia.org/wiki/Convex_hull>`_ 上找到＂什么是凸包＂，以及 `＂Graham扫描算法＂<http://en.wikipedia.org/wiki/Graham_scan>`_ 的完整解释
skip12 = True
