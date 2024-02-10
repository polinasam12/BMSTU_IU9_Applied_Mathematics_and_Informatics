from num_methods import *


def lu_decomposition(a):
    l = [[0] * n for i in range(n)]
    for i in range(n):
        l[i][i] = 1
    u = [[0] * n for i in range(n)]
    for i in range(n):
        for j in range(n):
            if i <= j:
                s = 0
                for k in range(i):
                    s += l[i][k] * u[k][j]
                u[i][j] = a[i][j] - s
            else:
                s = 0
                for k in range(j):
                    s += l[i][k] * u[k][j]
                l[i][j] = (a[i][j] - s) / u[j][j]
    return l, u


n = 3

a = generate_symm_int_matrix(n, 1, 5)

print("Matrix A")
print_matr(a)
print()

l, u = lu_decomposition(a)

d = 1

for i in range(n):
    d *= u[i][i]

print("Determinant of matrix A")
print(d)
