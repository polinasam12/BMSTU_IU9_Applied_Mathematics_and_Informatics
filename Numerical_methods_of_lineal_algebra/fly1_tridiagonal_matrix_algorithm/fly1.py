import copy
from num_methods import *
import numpy as np


def progonka_method(m, d):
    n = len(m)
    a = [0]
    b = [0]
    c = [0]
    for i in range(n):
        for j in range(n):
            if i == j:
                b.append(m[i][j])
            elif i == j + 1:
                a.append(m[i][j])
            elif i == j - 1:
                c.append(m[i][j])
    d = [0] + d
    alpha = [0] * n
    beta = [0] * n
    for i in range(1, n):
        alpha[i] = -c[i] / (a[i - 1] * alpha[i - 1] + b[i])
        beta[i] = (d[i] - a[i - 1] * beta[i - 1]) / (a[i - 1] * alpha[i - 1] + b[i])
    x = [0] * (n + 1)
    x[n] = (d[n] - a[n - 1] * beta[n - 1]) / (a[n - 1] * alpha[n - 1] + b[n])
    for i in range(n - 1, 0, -1):
        x[i] = alpha[i] * x[i + 1] + beta[i]
    x = x[1:]
    return x


def gauss_method(a, b):
    n = len(a)
    for i in range(n):
        for j in range(i + 1, n):
            c = - a[j][i] / a[i][i]
            for k in range(i, n):
                if k == i:
                    a[j][k] = 0
                else:
                    a[j][k] += c * a[i][k]
            b[j] += c * b[i]
    x = [0] * n
    for i in range(n - 1, -1, -1):
        x[i] = b[i]
        for j in range(n - 1, i, -1):
            x[i] -= x[j] * a[i][j]
        x[i] /= a[i][i]
    return x


def generate_tridiagonal_matrix(n, v1, v2):
    a = [[0] * n for i in range(n)]
    for i in range(n):
        if i == 0:
            a[i][i] = random.uniform(v1, v2)
            a[i][i + 1] = random.uniform(v1, v2)
        elif i == n - 1:
            a[i][i] = random.uniform(v1, v2)
            a[i][i - 1] = random.uniform(v1, v2)
        else:
            a[i][i] = random.uniform(v1, v2)
            a[i][i - 1] = random.uniform(v1, v2)
            a[i][i + 1] = random.uniform(v1, v2)
    return a


n = 100
v1 = -100
v2 = 100
a = generate_tridiagonal_matrix(n, v1, v2)
x = [random.uniform(v1, v2) for i in range(1, n + 1)]
b = mult_matr_vec(a, x)

x1 = gauss_method(copy.deepcopy(a), copy.deepcopy(b))
print("Gauss method")
print(norm_vec(sub_vec(x, x1)) * 100)
print()

x2 = progonka_method(copy.deepcopy(a), copy.deepcopy(b))
print("Progonka method")
print(norm_vec(sub_vec(x, x2)) * 100)
print()

x3 = np.linalg.solve(a, b)
print("Library method")
print(norm_vec(sub_vec(x, x3)) * 100)
print()
