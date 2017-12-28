{-# LANGUAGE FlexibleInstances #-}

module TypeClass where

import           Control.Arrow (second)

--------------------------------------------------------------------------------
-- 基本的typeclass
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- 内置的Show类型类
--------------------------------------------------------------------------------
data Color
  = Red
  | Green
  | Blue

instance Show Color where
  show Red   = "Red"
  show Green = "Green"
  show Blue  = "Blue"

--------------------------------------------------------------------------------
-- 内置的Read类型类
--------------------------------------------------------------------------------
-- 首先是read的例子
readDouble = do
  putStrLn "Please enter a Double:"
  inpStr <- getLine
  let inpDouble = read inpStr :: Double
  print inpDouble

-- 为Color定制Read
instance Read Color
  -- readsPrec :: Int -> String -> [(Color, String)]
                                                     where
  readsPrec _ value = tryParse [("Red", Red), ("Green", Green), ("Blue", Blue)]
    where
      tryParse :: [(String, Color)] -> [(Color, String)]
      tryParse [] = []
      tryParse ((attempt, result):xs) =
        if take (length attempt) value == attempt
          then [(result, drop (length attempt) value)]
          else tryParse xs

r1 = read "[Red,Blue]" :: [Color]

--------------------------------------------------------------------------------
-- overlapping instances
--------------------------------------------------------------------------------
class Sayhi a where
  hi :: a -> String

instance Show a => Sayhi [a] where
  hi x = "hi, " ++ show x

-- |会覆盖Sayhi [a]，除非指定{-# OVERLAPPING #-}
-- 或者为Sayhi [a] 使用{-# OVERLAPPABLE #-}
-- instance {-# OVERLAPPING #-} Sayhi [String] where
instance Sayhi [String] where
  hi x = "hi, " ++ show x
-- 以下语句编译出错：
-- r2 = hi ["a"]
