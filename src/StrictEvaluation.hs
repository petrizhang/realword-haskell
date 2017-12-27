-- 严格求值（非惰性）版本的foldl
-- seq 函数的行为并没有那么神秘：它强迫（force）求值传入的第一个参数，然后返回它的第二个参数。
strictFoldl _ zero [] = zero
strictFoldl step zero (x:xs) =
  let new = step zero x
  in new `seq` strictFoldl step new xs



