module RecurrenceType where

-- 递归类型
data List a
  = Cons a
         (List a)
  | Nil
  deriving (Show)

-- List可以被当做内置的list吗？
-- 简单证明：设计一个函数，接受任意[a]类型的值，并返回List a 类型的一个值
fromList (x:xs) = Cons x (fromList xs)
fromList []     = Nil

-- 所以二者是同构的
--------------------
-- 二叉树类型
data Tree a
  = Node a
         (Tree a)
         (Tree a)
  | Empty
  deriving (Show)

simpleTree = Node "parent" (Node "left child" Empty Empty) (Node "right child" Empty Empty)
