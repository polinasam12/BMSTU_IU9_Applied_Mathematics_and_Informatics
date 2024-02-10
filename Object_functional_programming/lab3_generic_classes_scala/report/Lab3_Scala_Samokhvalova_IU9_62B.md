% Лабораторная работа № 3 «Обобщённые классы в Scala»
% 22 марта 2023 г.
% Самохвалова Полина, ИУ9-62Б

# Цель работы
Целью данной работы является приобретение навыков разработки обобщённых классов на языке Scala с 
использованием неявных преобразований типов.

# Индивидуальный вариант
Класс Powers[T], представляющий бесконечную последовательность степеней некоторого значения x типа T, 
для которой реализованы две операции: получение i-го члена последовательности, умножение всех элементов 
последовательности на x. В качестве типа T может выступать либо числовой тип, либо строка (в случае 
строки умножением является конкатенация).

# Реализация и тестирование

```scala
class Powers[T](val x: T, val k: T) {

  def this(p_x: T)(implicit ops: PowersOps[T]) = this(p_x, ops.unit())

  private def get_elem(n: Int)(implicit ops: PowersOps[T]): T = {
    if (n == 0)  ops.unit() else ops.mul(x, get_elem(n - 1))
  }

  def get(n: Int)(implicit ops: PowersOps[T]): T = {
    ops.mul(get_elem(n), k)
  }

  def mul_x()(implicit ops: PowersOps[T]): Powers[T] = {
    new Powers[T](x, ops.mul(x, k))
  }

}

trait PowersOps[T] {
  def mul(a: T, b: T): T
  def unit(): T
}

object PowersOps {
  implicit def number_ops[T](implicit num: Numeric[T]): PowersOps[T] =
    new PowersOps[T] {
      def mul(a: T, b: T): T = num.times(a, b)
      def unit(): T = num.one
    }

  implicit def string_ops[T]: PowersOps[String] =
    new PowersOps[String] {
      def mul(a: String, b: String): String = a + b
      def unit(): String = ""
    }
}

object Main extends App {
  val p1 = new Powers(2)
  println(p1.get(5))
  val p2 = p1.mul_x()
  println(p2.get(5))
  val p3 = p2.mul_x()
  println(p3.get(5))
  val p4 = new Powers(0.5)
  println(p4.get(2))
  val p5 = new Powers("a")
  println(p5.get(3))

}

```

Вывод программы
```
32
64
128
0.25
aaa
```

# Вывод
В результате выполнения лабораторной работы был приобретен навык разработки обобщённых классов на языке 
Scala с использованием неявных преобразований типов. Был реализован Класс Powers[T], представляющий 
бесконечную последовательность степеней некоторого значения x типа T с двумя операциями: получение i-го 
члена последовательности, умножение всех элементов последовательности на x. T - либо числовой тип, либо 
строка.
