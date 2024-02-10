from num_methods import *
import random
import numpy as np
import copy


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


def generate_matrix(n, v1, v2):
    return [[random.uniform(v1, v2) for i in range(n)] for j in range(n)]


def increase_diagonal_elements_to_diagonal_predominance(a):
    n = len(a)
    for i in range(n):
        s = 0
        for j in range(n):
            if i != j:
                s += abs(a[i][j])
        a[i][i] = s + 1
    return a


def input_matrix():
    n = int(input())
    a = []
    b = []
    for i in range(n):
        l = list(map(int, input().split()))
        a.append(l)
    for i in range(n):
        b.append(int(input()))
    return a, b


n = 100

v1 = -100
v2 = 100

a = generate_matrix(n, v1, v2)

print("Matrix A:")
for m in a:
    print(m)
print()

x = [i for i in range(1, n + 1)]
b = mult_matr_vec(a, x)

print("Vector b:")
print(b)
print()

print("Vector x accurate:")
print(x)
print()

x_num = gauss_method(copy.deepcopy(a), copy.copy(b))

print("Vector x_num:")
print(x_num)
print()

x_lib = np.linalg.solve(a, b)

print("Vector x_lib:")
print(x_lib)
print()

print("Norm of vector ||x - x_num||:")
print(norm_vec(sub_vec(x, x_num)))
print()

print("Norm of vector ||x - x_lib||:")
print(norm_vec(sub_vec(x, x_lib)))
print()

print("---------")

r12 = 2
r23 = 1
r24 = 1
r34 = 1
r13 = 1

a = [[0, 0, 0, 1],
     [1, 0, 0, -1],
     [1 / r12, -1 / r12 - 1 / r24 - 1 / r23, 1 / r23, 1 / r24],
     [-1 / r13, -1 / r23, 1 / r34 + 1 / r13 + 1 / r23, -1 / r34]]

b = [0, 9, 0, 0]

phi = np.linalg.solve(a, b)
print(phi)
phi1, phi2, phi3, phi4 = phi[0], phi[1], phi[2], phi[3]

i12 = phi1 - phi2
i13 = phi1 - phi3
i23 = phi2 - phi3
i24 = phi2 - phi4
i34 = phi3 - phi4
print(i12)
print(i13)
print(i23)
print(i24)
print(i34)



a = [[0, 0, 0, 1],
     [1, 0, 0, -1],
     [1, -3, 1, 1],
     [-1, -1, 3, -1]]

b = [0, 9, 0, 0]

print(np.linalg.solve(a, b))