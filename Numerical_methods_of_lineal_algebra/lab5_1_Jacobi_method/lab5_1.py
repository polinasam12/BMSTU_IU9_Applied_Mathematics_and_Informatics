from num_methods import *
import random


def uniform_norm_vec(vec):
    n = len(vec)
    norm = abs(vec[0])
    for i in range(1, n):
        v = abs(vec[i])
        if v > norm:
            norm = v
    return norm


def increase_diagonal_elements_to_diagonal_predominance(a):
    n = len(a)
    for i in range(n):
        s = 0
        for j in range(n):
            if i != j:
                s += abs(a[i][j])
        a[i][i] = s + 10
    return a


def generate_matrix(n, v1, v2):
    return [[random.uniform(v1, v2) for i in range(n)] for j in range(n)]


def jacobi_method(a, f, epsilon):
    n = len(a)
    k = 0
    x_old = [0] * n
    while True:
        x = [0] * n
        for i in range(n):
            s = 0
            for j in range(n):
                if i != j:
                    s += a[i][j] * x_old[j]
            x[i] = (f[i] - s) / a[i][i]
        k += 1
        norm_sub = uniform_norm_vec(sub_vec(x, x_old))
        if norm_sub < epsilon:
            break
        x_old = x
    return x


def p_norm(a):
    n = len(a)
    ms = 0
    for i in range(n):
        ss = 0
        for j in range(n):
            if i != j:
                ss += abs(a[i][j] / a[i][i])
        if ss > ms:
            ms = ss
    return ms


n = 5
a = generate_matrix(n, -10, 10)
x = [i for i in range(1, n + 1)]
a = increase_diagonal_elements_to_diagonal_predominance(a)
f = mult_matr_vec(a, x)
x_jacobi = jacobi_method(a, f, 0.001)
x_gauss = gauss_method(a, f)

print("x by Jacobi method")
print(x_jacobi)
print()

print("x by Gauss method")
print(x_gauss)
norm_p = p_norm(a)
print()

print("Check ||P|| < 1")
print(norm_p < 1)
