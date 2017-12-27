data List a
  = Cons a
         (List a)
  | Nil
  deriving (Show)

-- convert [] to List
internal2List (x:xs) = Cons x (internal2List xs)
internal2List [] = Nil

-- convert List to []
list2Internal (Cons x xs) = x : (list2Internal xs)
list2Internal Nil = []


-- 2. 请仿造 Java 示例，定义一种只需要一个构造器的树类型。
-- 不要使用 Empty 构造器，而是用 Maybe 表示节点的子节点。

--data Tree a = Node a (Tree a) (Tree a)
--            | Empty
--              deriving (Show)


data Tree a = Node a
  (Maybe (Tree a))
  (Maybe (Tree a))
  deriving (Show)

simpleTree = Node "parent"
  (Just(Node "left child" Nothing Nothing ))
  (Just(Node "right child" Nothing Nothing))

newTree = Node "0" (Just simpleTree) (Just simpleTree)

