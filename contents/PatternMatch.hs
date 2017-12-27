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
