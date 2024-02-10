from num_methods import *


def holetsky_method(a):
    n = len(a)
    l = [[0] * n for i in range(n)]
    l[0][0] = a[0][0] ** 0.5
    for j in range(1, n):
        l[j][0] = a[j][0] / l[0][0]
    for i in range(1, n):
        s = 0
        for p in range(i):
            s += l[i][p] ** 2
        l[i][i] = (a[i][i] - s) ** 0.5
        for j in range(i + 1, n):
            s = 0
            for p in range(i):
                s += l[i][p] * l[j][p]
            l[j][i] = (a[j][i] - s) / l[i][i]
    return l


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


n = 5

a = generate_symm_matrix(n, 1, 10)
a = increase_diagonal_elements_to_diagonal_predominance(a)

print("Matrix A")
print_matr(a)
print()

print("Holetsky method")
print()
l = holetsky_method(a)
print("Matrix L")
print_matr(l)
print()
a1 = mult_matr_matr(l, transp_matr(l))
print("Matrix L * L^T")
print_matr(a1)
print()
norm1 = norm_matr(sub_matr_matr(a, a1))
print("Matrix norm")
print(norm1)
print()

print("LU decomposition")
print()
l, u = lu_decomposition(a)
print("Matrix L")
print_matr(l)
print()
print("Matrix U")
print_matr(u)
print()
a2 = mult_matr_matr(l, u)
print("Matrix L * U")
print_matr(a2)
print()
norm2 = norm_matr(sub_matr_matr(a, a2))
print("Matrix norm")
print(norm2)
