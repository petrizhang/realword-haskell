module PrettyJSON
  ( genDoc
  , pretty
  , compact
  ) where

import           Prettify
import           SimpleJSON

genDoc :: JValue -> Doc
genDoc (JBool True) = text "true"
genDoc (JBool False) = text "false"
genDoc JNull = text "null"
genDoc (JNumber num) = double num
genDoc (JString str) = string str
genDoc (JArray ary) = series '[' ']' genDoc ary
genDoc (JObject obj) = series '{' '}' field obj
  where
    field (name, val) = string name <> symbol ':' <> symbol ' ' <> genDoc val

-- |压缩打印一个Doc
compact :: Doc -> String
compact x = transform [x]
  where
    transform [] = ""
    transform (d:ds) =
      case d of
        Empty        -> transform ds
        Char c       -> c : transform ds
        Symbol c     -> c : transform ds
        Text s       -> s ++ transform ds
        Line         -> ' ' : transform ds
        a `Concat` b -> transform (a : b : ds)
        _ `Union` b  -> transform (b : ds)

-- |带tab打印
tab = "  "

tabPrint :: Doc -> String
tabPrint x = transform [x] False 0
  where
    genNewLineTabs :: Bool -> Int -> String
    genNewLineTabs isNewline ntabs
      | isNewline = "\n" ++ concat (replicate ntabs tab)
      | otherwise = ""
    transform :: [Doc] -> Bool -> Int -> String
    transform [] isNewline ntabs = ""
    transform (d:ds) isNewline ntabs =
      case d of
        Symbol '{' -> "{" ++ transform ds True (ntabs + 1)
        Symbol '[' -> "[" ++ transform ds True (ntabs + 1)
        Symbol '}' -> genNewLineTabs True (ntabs - 1) ++ '}' : transform ds False (ntabs - 1)
        Symbol ']' -> genNewLineTabs True (ntabs - 1) ++ ']' : transform ds False (ntabs - 1)
        Line -> lineStart ++ transform ds True ntabs
        Empty -> lineStart ++ transform ds False ntabs
        Symbol c -> lineStart ++ c : transform ds False ntabs
        Char c -> lineStart ++ c : transform ds False ntabs
        Text s -> lineStart ++ s ++ transform ds False ntabs
        a `Concat` b -> lineStart ++ transform (a : b : ds) False ntabs
        _ `Union` b -> lineStart ++ transform (b : ds) False ntabs
      where
        lineStart = genNewLineTabs isNewline ntabs

-- |美观打印一个Doc
pretty :: Int -> Doc -> String
pretty width x = best 0 [x]
  where
    best col (d:ds) =
      case d of
        Empty        -> best col ds
        Symbol c       -> c : best (col + 1) ds
        Char c       -> c : best (col + 1) ds
        Text s       -> s ++ best (col + length s) ds
        Line         -> '\n' : best 0 ds
        a `Concat` b -> best col (a : b : ds)
        a `Union` b  -> nicest col (best col (a : ds)) (best col (b : ds))
    best _ _ = ""
    nicest col a b
      | (width - least) `fits` a = a
      | otherwise = b
      where
        least = min width col

fits :: Int -> String -> Bool
w `fits` _
  | w < 0 = False
w `fits` "" = True
w `fits` ('\n':_) = True
w `fits` (c:cs) = (w - 1) `fits` cs

-- |拆分Concat成的doc为一个list
doc2List :: Doc -> [Doc]
doc2List (Concat left right) = (doc2List left) ++ (doc2List right)
doc2List other               = [other]

-- test code
n = JNumber 1.0

an = JArray [n, n, n]

v = JObject [("f", JNumber 1), ("q", JBool True), ("q", JString "test{], 测试\n")]

ov = JObject [("q", v), ("a", v)]

av = JArray [v, v, v]

oav = JObject [("a", av), ("b", av)]

pd = putStrLn . tabPrint . genDoc

r0 = pd n

r1 = pd an

r2 = pd v

r3 = pd ov

r4 = pd av

r5 = pd oav
