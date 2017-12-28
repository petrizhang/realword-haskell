-- 代数数据类型
data BookInfo =
  Book Int
       String
       [String]
  deriving (Show)

myInfo = Book 9780135072455 "Algebra of Porgramming" ["Richard Bird", "Oege de Moor"]

-- 类型别名
type CustomerID = Int

type ReviewBody = String

data BookReview =
  BookReview BookInfo
             CustomerID
             String

data BetterReview =
  BetterReview BookInfo
               CustomerID
               ReviewBody

type BookRecord = (BookInfo, BookReview)

myBookReview = BookReview myInfo 12 "pczhang"

------------
type CardHolder = String

type CardNumber = String

type Address = [String]

data BillingInfo
  = CreditCard CardNumber
               CardHolder
               Address
  | CashOnDelivery
  | Invoice CustomerID
  deriving (Show)

card = CreditCard "2901650221064486" "Thomas Gradgrind" ["Dickens", "England"]

----------
-- 二维向量
data Cartesian2D =
  Cartesian2d Double
              Double
  deriving (Eq, Show)

data Polar2D =
  Polar2D Double
          Double
  deriving (Eq, Show)

c2d = Cartesian2d 1 2

p2d = Polar2D pi 1

--------------
-- 类似于枚举
data Roygbiv
  = Red
  | Orange
  | Yellow
  | Green
  | Blue
  | Indigo
  | Violet
  deriving (Eq, Show)

-- 类似于unio
type Vector = (Double, Double)

data Shape
  = Circle Vector
           Double
  | Poly [Vector]
  deriving (Show)
