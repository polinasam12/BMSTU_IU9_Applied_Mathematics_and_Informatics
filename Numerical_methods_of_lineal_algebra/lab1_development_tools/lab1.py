import math

from num_methods import *


def calc_err(x):

    true_value = 0.005051

    v1 = (x - 1) ** 6
    v2 = (3 - 2 * x) ** 3
    v3 = 99 - 70 * x

    print("Relative error at the root of 2, equal to", x)

    print("First method -", abs(true_value - v1) / true_value)
    print("Second method -", abs(true_value - v2) / true_value)
    print("Third method -", abs(true_value - v3) / true_value)
    print()


def calc_err1(x):

    delta_x = abs(math.sqrt(2) - x)

    v1 = 6 / (math.sqrt(2) - 1)
    v2 = 6 / (3 - 2 * math.sqrt(2))
    v3 = 70 / (99 - 70 * math.sqrt(2))

    print("Error estimation with a root of 2, equal to", x)

    print("First method -", v1 * delta_x)
    print("Second method -", v2 * delta_x)
    print("Third method -", v3 * delta_x)
    print()


print(scalar_mult_vec([1, 2, 3], [4, 5, 6]))
print(norm_vec([1, 2, 3]))
print()

print(mult_matr_matr([[1, 2], [3, 4], [5, 6]], [[1, 2, 3, 4, 5],
                                                [6, 7, 8, 9, 10]]))
print(mult_matr_vec([[1, 2, 3], [4, 5, 6], [7, 8, 9]], [1, 2, 3]))
print(transp_matr([[1, 2], [3, 4], [5, 6]]))
print()

plot_func(lambda x: x ** 2, [1, 2, 3, 4, 5])

calc_err(7 / 5)
calc_err(17 / 12)

calc_err1(7 / 5)
calc_err1(17 / 12)
