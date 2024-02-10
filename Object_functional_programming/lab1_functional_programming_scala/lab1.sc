val find_peaks: (List[Int], Int) => List[Int] = {
  case (Nil, i) => Nil
  case (x :: Nil, i) => List(0)
  case (x :: y :: Nil, i)  if (i == 1 & x > y) => List(0)
  case (x :: y :: Nil, i)  if (i == 1 & x < y) => List(1)
  case (x :: y :: Nil, i)  if (i == 1 & x == y) => List(0, 1)
  case (x :: y :: Nil, i)  if (i != 1 & x <= y) => List(i)
  case (x :: y :: Nil, i)  => Nil
  case (x :: y :: z :: xs, i)  if (i == 1 & x == y & y >= z) => 0 :: 1 :: find_peaks(y :: z :: xs, i + 1)
  case (x :: y :: z :: xs, i)  if (i == 1 & x >= y) => 0 :: find_peaks(y :: z :: xs, i + 1)
  case (x :: y :: z :: xs, i)  if (x <= y & y >= z) => i :: find_peaks(y :: z :: xs, i + 1)
  case (x :: y :: z :: xs, i)  => find_peaks(y :: z :: xs, i + 1)
}

val peaks: List[Int] => List[Int] = {
  list => find_peaks(list, 1)
}

peaks(List(5))
peaks(List(4, 7))
peaks(List(7, 4))
peaks(List(4, 4))
peaks(List(3, 9, 4, 4, 2, 5, 7))
peaks(List(3, 9, 4, 4, 2, 7, 5))
peaks(List(9, 3, 3, 2, 2, 5, 7))
peaks(List(5, 5, 4, 4, 2, 5, 7))
peaks(List(5, 5, 9, 4, 2, 5, 7))