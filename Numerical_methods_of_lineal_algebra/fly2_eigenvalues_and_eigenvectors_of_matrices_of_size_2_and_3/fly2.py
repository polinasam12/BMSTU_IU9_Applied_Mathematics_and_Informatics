import copy
import random

from num_methods import *


def func(p):
    n = len(p)
    p = [1] + p
    return lambda x: (-1) ** n * sum([x ** i * p[n - i] * (1 if i == n else -1)
                                      for i in range(n, -1, -1)])


def div_half_method(a, b, f):
    s = 0.1
    d = 0.0001
    res = []
    x_last = a
    x = x_last
    while x <= b:
        x = x_last + s
        if f(x) * f(x_last) < 0:
            x_left = x_last
            x_right = x
            x_mid = (x + x_last) / 2
            while abs(f(x_mid)) >= d:
                if f(x_left) * f(x_mid) < 0:
                    x_right = x_mid
                else:
                    x_left = x_mid
                x_mid = (x_left + x_right) / 2
            res.append(x_mid)
        x_last = x
    return res


def danilevsky_method(a):
    n = len(a)
    m = n - 1

    b = [[0] * n for i in range(n)]
    for i in range(n):
        b[i][i] = 1
    for j in range(n):
        if j != m - 1:
            b[m - 1][j] = -a[m][j] / a[m][m - 1]
    b[m - 1][m - 1] = 1 / a[m][m - 1]

    b_mul = copy.deepcopy(b)

    c = [[0] * n for i in range(n)]
    for i in range(n):
        c[i][m - 1] = a[i][m - 1] * b[m - 1][m - 1]
    for i in range(n - 1):
        for j in range(n):
            if j != m - 1:
                c[i][j] = a[i][j] + a[i][m - 1] * b[m - 1][j]

    b_inv = [[0] * n for i in range(n)]
    for i in range(n):
        b_inv[i][i] = 1
    for j in range(n):
        b_inv[m - 1][j] = a[m][j]

    d = [[0] * n for i in range(n)]
    for i in range(m - 1):
        for j in range(n):
            d[i][j] = c[i][j]
    for j in range(n):
        for k in range(n):
            d[m - 1][j] += a[m][k] * c[k][j]
    d[m][m - 1] = 1

    for k in range(2, n):
        b = [[0] * n for i in range(n)]
        for i in range(n):
            b[i][i] = 1
        for j in range(n):
            if j != m - k:
                b[m - k][j] = -d[m - k + 1][j] / d[m - k + 1][m - k]
        b[m - k][m - k] = 1 / d[m - k + 1][m - k]

        b_mul = mult_matr_matr(b_mul, b)

        b_inv = inv_matr(b)
        d = mult_matr_matr(b_inv, d)
        d = mult_matr_matr(d, b)
    return d, b_mul


def generate_symm_matrix(n, v1, v2):
    a = [[0] * n for i in range(n)]
    for i in range(n):
        for j in range(i, n):
            a[i][j] = random.uniform(v1, v2)
            if i != j:
                a[j][i] = a[i][j]
    return a


def check_ortonormal(vs):
    for v in vs:
        if abs(norm_vec(v) - 1) > 0.001:
            return False
    n = len(vs)
    for i in range(n):
        for j in range(i + 1, n):
            if abs(scalar_mult_vec(vs[i], vs[j])) > 0.001:
                return False
    return True


n = 2
a = generate_symm_matrix(n, -10, 10)

d, b = danilevsky_method(a)
p = d[0][:]

plot_func(func(p), [i for i in range(-30, 30)])

g = [-30, 30]

print("Matrix 2x2")
print()
ls = div_half_method(g[0], g[1], func(p))
print("Eigenvalues of matrix")
print(ls)
print()

print("Eigenvectors of matrix")
vectors = []
for l in ls:
    y = [1]
    for i in range(1, n):
        y.append(l ** i)
    y = y[::-1]
    y = mult_matr_vec(b, y)
    norm = norm_vec(y)
    for i in range(n):
        y[i] /= norm
    vectors.append(y)
    print(y)
print()

print("Checking for orthonormality")
if check_ortonormal(vectors):
    print("Vectors are orthonormal")
else:
    print("Vectors are not orthonormal")
print()

n = 3
a = generate_symm_matrix(n, -10, 10)

d, b = danilevsky_method(a)
p = d[0][:]

plot_func(func(p), [i for i in range(-30, 30)])

g = [-30, 30]

print("Matrix 3x3")
print()
ls = div_half_method(g[0], g[1], func(p))
print("Eigenvalues of matrix")
print(ls)
print()

print("Eigenvectors of matrix")
vectors = []
for l in ls:
    y = [1]
    for i in range(1, n):
        y.append(l ** i)
    y = y[::-1]
    y = mult_matr_vec(b, y)
    norm = norm_vec(y)
    for i in range(n):
        y[i] /= norm
    vectors.append(y)
    print(y)
print()

print("Checking for orthonormality")
if check_ortonormal(vectors):
    print("Vectors are orthonormal")
else:
    print("Vectors are not orthonormal")
