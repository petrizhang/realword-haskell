module Newtype where

-- |newtype
-- 在编译期隐藏了类型的某些行为，仅暴露出需要的行为
-- 其只能有一个构造器，并且构造器只能有一个参数
newtype N =
  N Int
  deriving (Eq, Ord, Show)

data D =
  D Int

-- 只匹配构造器，未求值undefined，所以不会崩溃
md0 =
  case (D undefined) of
    D _ -> 1

-- 不会崩溃
mn0 =
  case (N undefined) of
    N _ -> 1

-- 求值了undefined以后才进行匹配，崩溃
md1 =
  case undefined of
    D _ -> 1

-- newtype不存在于运行时，所以其等价于
-- case undefined of _
-- 对通配符进行匹配总会成功的，所以不会崩溃
mn1 =
  case undefined of
    N _ -> 1
