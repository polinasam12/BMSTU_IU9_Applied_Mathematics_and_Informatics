from matplotlib import pyplot as plt
import random
import copy


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


def mult_matr_vec(matr, vec):
    n = len(vec)
    m = len(matr[0])
    vec1 = [0] * n
    for i in range(n):
        for j in range(m):
            vec1[i] += matr[i][j] * vec[j]
    return vec1


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


def gershgorin_rounds(a):
    left = -100000
    right = 100000
    n = len(a)
    for i in range(n):
        s = 0
        for j in range(n):
            if i != j:
                s += abs(a[i][i])
        b1 = a[i][i] - s
        b2 = a[i][i] + s
        if i == 0:
            left = b1
            right = b2
        elif b1 < left:
            left = b1
        elif b2 > right:
            right = b2
    return [left, right]


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
