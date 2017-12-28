-------------------------
-- 函数参数模式匹配
--   对特定的参数返回特定的值
myNot True  = False
myNot False = True

-------------------------
-- 复杂一点的模式匹配
sumList (x:xs) = x + sumList xs
sumList []     = 0

-------------------------
-- 组成和解构
-- 对元组进行模式匹配的语法，和构造元组的语法很相似
third (a, b, c) = c

-- 模式匹配的深度并没有限制
complicated (True, a, x:xs, 5) = (a, xs)

-- 匹配失败的话会抛出异常
-- 代数数据类型可以使用它的值构造器进行解构
data Book =
  Book Double
       String
       [String]
  deriving (Show)

bookID (Book id title authors) = id

bookTitle (Book id title authors) = title

bookAuthors (Book id title authors) = authors

-- 通配符模式匹配
nicerID (Book id _ _) = id

nicerTitle (Book _ title _) = title

nicerAuthors (Book _ _ authors) = authors

-- 穷举匹配模式和通配符
-- badExample [] 会报错
badExample (x:xs) = x + badExample xs

-- 最好使用一个默认值
goodExample (x:xs) = x + goodExample xs
goodExample _      = 0

----------------------------
-- 记录语法
-- 定义数据类型的同时就可以定义好每个成分的访问器
type CustomerID = Int

type Address = [String]

data Customer = Customer
  { customerID      :: CustomerID
  , customerName    :: String
  , customerAddress :: Address
  } deriving (Show)

customer1 = Customer 123 "zhang" ["New York"]

customer2 = Customer {customerID = 123, customerName = "zh", customerAddress = ["New York"]}

-- 普通
isValid :: Maybe a -> Bool
isValid (Just _) = True
isValid Nothing  = False

-- as模式
headTail []       = []
headTail l@(x:xs) = [l, [x], xs]

-- case
fstSndTail l =
  case l of
    x0:t@(x1:xs) -> [[x0], [x1], t]
    x0:xs        -> [[x0], [], xs]
    _            -> []
