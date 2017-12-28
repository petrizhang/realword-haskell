module IfExpr where

-- if表达式
myDrop n xs =
  if n <= 0 || null xs
    then xs
    else myDrop (n - 1) (tail xs)
