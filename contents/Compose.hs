import           Data.List (isPrefixOf, tails)

--"zhang" -> ["zhang","hang","ang","ng","g"]
suffixes xs = init (tails xs)

r0 = suffixes "zhang"

-- 函数复合
compose :: (b -> c) -> (a -> b) -> a -> c
compose f g x = f (g x)

suffixes1 = compose init tails

r1 = suffixes1 "zhang"

-- 使用内置的操作符
suffixes2 = init . tails

r2 = suffixes2 "zhang"

-- 以下是另一个例子，它从 libpcap —— 一个流行的网络包过滤库中提取 C 文件头中给定格式的宏名字。这些头文件带有很多以下格式的宏：
-- #define DLT_EN10MB      1       /* Ethernet (10Mb) */
-- #define DLT_EN3MB       2       /* Experimental Ethernet (3Mb) */
-- #define DLT_AX25        3       /* Amateur Radio AX.25 */
dlts :: String -> [String]
dlts = map (head . tail . words) . filter ("#define DLT_" `isPrefixOf`) . lines

