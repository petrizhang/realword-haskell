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
    field (name, val) = string name <> text ": " <> genDoc val

-- |压缩打印一个Doc
compact :: Doc -> String
compact x = transform [x]
  where
    transform [] = ""
    transform (d:ds) =
      case d of
        Empty        -> transform ds
        Char c       -> c : transform ds
        Text s       -> s ++ transform ds
        Line         -> ' ' : transform ds
        a `Concat` b -> transform (a : b : ds)
        _ `Union` b  -> transform (b : ds)

-- |美观打印一个Doc
pretty :: Int -> Doc -> String
pretty width x = best 0 [x]
  where
    best col (d:ds) =
      case d of
        Empty        -> best col ds
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
