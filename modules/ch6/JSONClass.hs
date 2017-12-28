module JSONClass where

-- 使用newtype避免overlap
newtype JAry a = JAry
  { fromJAry :: [a]
  } deriving (Eq, Ord, Show)

newtype JObj a = JObj
  { fromJObj :: [(String, a)]
  } deriving (Eq, Ord, Show)

data JValue
  = JString String
  | JNumber Double
  | JBool Bool
  | JNull
  | JObject (JObj JValue)
  | JArray (JAry JValue)
  deriving (Eq, Ord, Show)

type JSONError = String

class JSON a where
  toJValue :: a -> JValue
  fromJValue :: JValue -> Either JSONError a

instance JSON JValue where
  toJValue = id
  fromJValue = Right

instance JSON Bool where
  toJValue = JBool
  fromJValue (JBool b) = Right b
  fromJValue _         = Left "not a JSON boolean"

instance JSON Int where
  toJValue = JNumber . realToFrac
  fromJValue = doubleToJValue round

instance JSON Integer where
  toJValue = JNumber . realToFrac
  fromJValue = doubleToJValue round

instance JSON Double where
  toJValue = JNumber
  fromJValue = doubleToJValue id

instance JSON String where
  toJValue = JString
  fromJValue (JString b) = Right b
  fromJValue _           = Left "not a JSON boolean"

instance (JSON a) => JSON (JAry a) where
  toJValue = jaryToJValue
  fromJValue = jaryFromJValue

instance (JSON a) => JSON (JObj a) where
  toJValue = JObject . JObj . map (second toJValue) . fromJObj
  fromJValue (JObject (JObj o)) = whenRight JObj (mapEithers unwrap o)
    where
      unwrap (k, v) = whenRight ((,) k) (fromJValue v)
  fromJValue _ = Left "not a JSON object"

doubleToJValue :: (Double -> a) -> JValue -> Either JSONError a
doubleToJValue f (JNumber v) = Right (f v)
doubleToJValue _ _           = Left "not a JSON number"

listToJValues :: (JSON a) => [a] -> [JValue]
listToJValues = map toJValue

jvaluesToJAry :: [JValue] -> JAry JValue
jvaluesToJAry = JAry

jaryFromJValue :: (JSON a) => JValue -> Either JSONError (JAry a)
jaryFromJValue (JArray (JAry a)) = whenRight JAry (mapEithers fromJValue a)
jaryFromJValue _                 = Left "not a JSON array"

jaryToJValue :: (JSON a) => JAry a -> JValue
jaryToJValue = JArray . JAry . map toJValue . fromJAry

whenRight :: (b -> c) -> Either a b -> Either a c
whenRight _ (Left err) = Left err
whenRight f (Right a)  = Right (f a)

mapEithers :: (a -> Either b c) -> [a] -> Either b [c]
mapEithers f (x:xs) =
  case mapEithers f xs of
    Left err -> Left err
    Right ys ->
      case f x of
        Left err -> Left err
        Right y  -> Right (y : ys)
mapEithers _ _ = Right []


-- test code
r0 = (fromJValue (toJValue True)) :: Either JSONError Bool
