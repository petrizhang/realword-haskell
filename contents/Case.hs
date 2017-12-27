-- case
data Fruit
  = Apple
  | Orange
  deriving (Show)

apple = "apple"

orange = "orange"

-- 错误用法
whichFruit :: String -> Fruit
whichFruit f =
  case f of
    apple  -> Apple
    orange -> Orange

-- 其等价于如下函数
whichFruit2 :: String -> Fruit
whichFruit2 apple  = Apple
whichFruit2 orange = Orange

-- 正确的是
betterFruit f =
  case f of
    "apple"  -> Apple
    "orange" -> Orange

-- 守卫
data Tree a
  = Node a
         (Tree a)
         (Tree a)
  | Empty
  deriving (Show)

nodesAreSame (Node a _ _) (Node b _ _)
  | a == b = Just a
nodesAreSame _ _ = Nothing

tree = Node "p" (Node "left" Empty Empty) (Node "right" Empty Empty)

areSame = nodesAreSame tree tree

-- 另一个例子，其实守卫就相当于if else的简写（我觉得）
lend amount balance
  | amount <= 0 = Nothing
  | amount > reserve * 0.5 = Nothing
  | otherwise = Just newBalance
  where
    reserve = 100
    newBalance = balance - amount
