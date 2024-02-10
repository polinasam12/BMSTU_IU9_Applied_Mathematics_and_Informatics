from num_methods import *
import random
import copy


def krylov_method(a):
    n = len(a)
    y = [[0] * n for i in range(n + 1)]
    y[0][0] = 1
    for i in range(1, n + 1):
        y[i] = mult_matr_vec(a, y[i - 1])
    m = [[1] * n for i in range(n)]
    for i in range(n):
        for j in range(n):
            m[i][j] = y[n - 1 - j][i]
    p = gauss_method(m, y[n])
    g = gershgorin_rounds(a)
    ls = div_half_method(g[0], g[1], func(p))
    p = p[::-1]
    q = [[0] * n for i in range(n)]
    for i in range(n):
        for j in range(n):
            if j == 0:
                q[j][i] = 1
            else:
                q[j][i] = ls[i] * q[j - 1][i] - p[n - j]
    x = []
    for i in range(n):
        xi = [0] * n
        for j in range(n):
            xi = sum_vec(xi, mult_vec_num(q[j][i], y[n - 1 - j]))
        x.append(xi)
    return ls, x


a = [[2.2, 1, 0.5, 2],
     [1, 1.3, 2, 1],
     [0.5, 2, 0.5, 1.6],
     [2, 1, 1.6, 2]]
n = len(a)
print("Krylov method for matrix 4x4")
ls, x = krylov_method(a)
print("Eigenvalues of matrix")
print(ls)
print("Eigenvectors of matrix")
for xi in x:
    norm = norm_vec(xi)
    for i in range(n):
        xi[i] /= norm
    print(xi)

print()

print("Krylov method for matrix 7x7")
a = generate_symm_matrix(7, -10, 10)
n = len(a)
ls, x = krylov_method(a)
print("Eigenvalues of matrix")
print(ls)
print("Eigenvectors of matrix")
for xi in x:
    norm = norm_vec(xi)
    for i in range(n):
        xi[i] /= norm
    print(xi)

print()

print("Danilevsky method for matrix 7x7")
d, b = danilevsky_method(a)
p = d[0][:]
g = gershgorin_rounds(a)
ls = div_half_method(g[0], g[1], func(p))
print("Eigenvalues of matrix")
print(ls)
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
