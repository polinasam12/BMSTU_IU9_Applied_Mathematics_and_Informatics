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
