import math


def f(x):
    return 1 / (x + x ** 2)


def rectangles_method(f, a, b, n):
    h = (b - a) / n
    return h * sum(f(a + (i - 0.5) * h) for i in range(1, n + 1))


def trapezoid_method(f, a, b, n):
    h = (b - a) / n
    return h * ((f(a) + f(b)) / 2 + sum(f(a + i * h) for i in range(1, n)))


def Simpson_method(f, a, b, n):
    h = (b - a) / n
    return h / 6 * sum((f(a + (i - 1) * h) + 4 * f(a + (i - 0.5) * h) +
                        f(a + i * h)) for i in range(1, n + 1))


epsilon = 0.001
a = 0.25
b = 2
methods = [rectangles_method, trapezoid_method, Simpson_method]
methods_names = ["Rectangles method", "Trapezoid method", "Simpson_method"]
for i in range(len(methods)):
    if methods[i] == Simpson_method:
        k = 4
    else:
        k = 2
    n = 1
    integral = 0
    r = math.inf
    while abs(r) >= epsilon:
        n *= 2
        integral_last = integral
        integral = methods[i](f, a, b, n)
        r = (integral - integral_last) / (2 ** k - 1)
    print(methods_names[i])
    print(n)
    print(integral)
    print(integral + r)
    print()
    