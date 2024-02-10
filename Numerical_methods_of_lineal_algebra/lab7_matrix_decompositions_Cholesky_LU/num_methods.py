from matplotlib import pyplot as plt
import random


def scalar_mult_vec(vec1, vec2):
    n = len(vec1)
    s = 0
    for i in range(n):
        s += vec1[i] * vec2[i]
    return s


def norm_vec(vec):
    n = len(vec)
    s = 0
    for i in range(n):
        s += vec[i] ** 2
    norm = s ** 0.5
    return norm


def norm_vec_sq(vec):
    n = len(vec)
    s = 0
    for i in range(n):
        s += vec[i] ** 2
    norm = s
    return norm


def sum_vec(vec1, vec2):
    n = len(vec1)
    vec = [0] * n
    for i in range(n):
        vec[i] = vec1[i] + vec2[i]
    return vec


def sub_vec(vec1, vec2):
    n = len(vec1)
    vec = [0] * n
    for i in range(n):
        vec[i] = vec1[i] - vec2[i]
    return vec


def mult_vec_num(num, vec):
    n = len(vec)
    vec1 = [0] * n
    for i in range(n):
        vec1[i] = num * vec[i]
    return vec1


def mult_matr_matr(matr1, matr2):
    n1 = len(matr1)
    m1 = len(matr1[0])
    m2 = len(matr2[0])
    matr = [[0] * m2 for i in range(n1)]
    for i in range(n1):
        for j in range(m2):
            for k in range(m1):
                matr[i][j] += matr1[i][k] * matr2[k][j]
    return matr


def sub_matr_matr(matr1, matr2):
    n = len(matr1)
    matr = [[0] * n for i in range(n)]
    for i in range(n):
        for j in range(n):
            matr[i][j] = matr1[i][j] - matr2[i][j]
    return matr


def norm_matr(matr):
    n = len(matr)
    s = 0
    for i in range(n):
        for j in range(n):
            s += matr[i][j] ** 2
    norm = s ** 0.5
    return norm


def print_matr(matr):
    n = len(matr)
    for i in range(n):
        for j in range(n):
            print(matr[i][j], end = " ")
        print()


def generate_unit_matr(n):
    matr = [[0] * n for i in range(n)]
    for i in range(n):
        matr[i][i] = 1
    return matr


def mult_matr_vec(matr, vec):
    n = len(vec)
    m = len(matr[0])
    vec1 = [0] * n
    for i in range(n):
        for j in range(m):
            vec1[i] += matr[i][j] * vec[j]
    return vec1


def mult_matr_num(num, matr):
    n = len(matr)
    matr1 = [[0] * n for i in range(n)]
    for i in range(n):
        for j in range(n):
            matr1[i][j] = num * matr[i][j]
    return matr1


def transp_matr(matr):
    n = len(matr)
    m = len(matr[0])
    matr1 = [[0] * n for i in range(m)]
    for i in range(m):
        for j in range(n):
            matr1[i][j] = matr[j][i]
    return matr1


def plot_func(func, x):

    y = [func(x[i]) for i in range(len(x))]

    plt.xlabel('x')
    plt.ylabel('y')
    plt.grid()
    plt.plot(x, y)
    plt.show()


def det_matr(matr):
    n = len(matr)
    if n == 2:
        return matr[0][0] * matr[1][1] - matr[1][0] * matr[0][1]
    else:
        d = 0
        for i in range(n):
            d += matr[0][i] * alg_add(matr, 0, i)
        return d


def alg_add(matr, i, j):
    n = len(matr)
    matr1 = []
    for k in range(n):
        if k != i:
            matr1.append([])
            for q in range(n):
                if q != j:
                    matr1[-1].append(matr[k][q])
    return (-1) ** (i + j) * det_matr(matr1)


def inv_matr(matr):
    n = len(matr)
    matr_inv = [[0] * n for i in range(n)]
    c = 1 / det_matr(matr)
    for i in range(n):
        for j in range(n):
            matr_inv[j][i] = c * alg_add(matr, i, j)
    return matr_inv


def trace_matr(matr):
    n = len(matr)
    s = 0
    for i in range(n):
        s += matr[i][i]
    return s


def increase_diagonal_elements_to_diagonal_predominance(a):
    n = len(a)
    for i in range(n):
        s = 0
        for j in range(n):
            if i != j:
                s += abs(a[i][j])
        a[i][i] = s + 10
    return a


def generate_symm_matrix(n, v1, v2):
    a = [[0] * n for i in range(n)]
    for i in range(n):
        for j in range(i, n):
            a[i][j] = random.uniform(v1, v2)
            if i != j:
                a[j][i] = a[i][j]
    return a
