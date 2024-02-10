% Лабораторная работа № 1. «Введение в функциональное программирование на языке Scala»
% 15 февраля 2023 г.
% Самохвалова Полина, ИУ9-62Б

# Цель работы
Целью данной работы является ознакомление с программированием на языке Scala на основе чистых функций.

# Индивидуальный вариант
Функция peaks: List[Int] => List[Int], формирующая список индексов пиков последовательности (пик — такой 
элемент, что соседние элементы его не превышают).

# Реализация и тестирование

Работа в REPL-интерпретаторе Scala:

```
scala> :paste
// Entering paste mode (ctrl-D to finish)

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

// Exiting paste mode, now interpreting.

find_peaks: (List[Int], Int) => List[Int] = <function2>
peaks: List[Int] => List[Int] = <function1>

scala> peaks(List(5))
res0: List[Int] = List(0)

scala> peaks(List(4, 7))
res1: List[Int] = List(1)

scala> peaks(List(7, 4))
res2: List[Int] = List(0)

scala> peaks(List(4, 4))
res3: List[Int] = List(0, 1)

scala> peaks(List(3, 9, 4, 4, 2, 5, 7))
res4: List[Int] = List(1, 3, 6)

scala> peaks(List(3, 9, 4, 4, 2, 7, 5))
res5: List[Int] = List(1, 3, 5)

scala> peaks(List(9, 3, 3, 2, 2, 5, 7))
res6: List[Int] = List(0, 2, 6)

scala> peaks(List(5, 5, 4, 4, 2, 5, 7))
res7: List[Int] = List(0, 1, 3, 6)

scala> peaks(List(5, 5, 9, 4, 2, 5, 7))
res8: List[Int] = List(0, 2, 6)

scala> :quit

```

# Вывод
В результате выполнения лабораторной работы было осуществлено ознакомление с программированием на языке 
Scala на основе чистых функций, была реализована функция peaks, формирующая список индексов пиков 
последовательности.