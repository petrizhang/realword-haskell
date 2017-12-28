module ParameterizedType where

-- 参数化类型
data MyMaybe a
  = MyJust a
  | MyNothing
  deriving (Show)
