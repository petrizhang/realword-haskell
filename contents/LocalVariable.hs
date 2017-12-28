module LocalVariable where

-- let
foo =
  let a = 1
  in let b = 2
     in a + b

foo1 = a + b
  where
    a = 1
    b = 2

bar =
  let x = 1
  in ( (let x = "foo"
        in x)
     , x)

-- where
pluralise :: String -> [Int] -> [String]
pluralise word counts = map plural counts
  where
    plural 0 = "no " ++ word ++ "s"
    plural 1 = "one " ++ word
    plural n = show n ++ " " ++ word ++ "s "
