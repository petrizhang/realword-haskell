module TypeClass where

-- 基本的typeclass
class BasicEq a where
  isEqual :: a -> a -> Bool

-- 实例化
instance BasicEq Bool where
  isEqual x y = x == y

r0 = True `isEqual` False

-- 包含多个函数
class BasicEq1 a where
  isEqual1 :: a -> a -> Bool
  isNotEqual1 :: a -> a -> Bool

instance BasicEq1 Bool where
  isEqual1 x y = x == y
  isNotEqual1 x y = not x == y

-- 提供默认实现
class BasicEq2 a where
  isEqual2 :: a -> a -> Bool
  isEqual2 x y = not (isNotEqual2 x y)
  isNotEqual2 :: a -> a -> Bool
  isNotEqual2 x y = not (isEqual2 x y)

instance BasicEq2 Bool where
  isEqual2 x y = x == y

---------------------------------------------
data Color
  = Red
  | Green
  | Blue

instance Show Color where
  show Red   = "red"
  show Green = "green"
  show Blue  = "blue"
