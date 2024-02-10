from num_methods import *
import random
import numpy as np
import copy
from matplotlib import pyplot as plt


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


def gauss_method_permutation_strings(a, b):
    n = len(a)
    for i in range(n):
        j_max = i
        for j in range(i + 1, n):
            if abs(a[j][i]) > abs(a[j_max][i]):
                j_max = j
        if j_max != i:
            for k in range(n):
                a[i][k], a[j_max][k] = a[j_max][k], a[i][k]
            b[i], b[j_max] = b[j_max], b[i]
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


def gauss_method_permutation_columns(a, b):
    n = len(a)
    perm = [i for i in range(n)]
    for i in range(n):
        j_max = i
        for j in range(i + 1, n):
            if abs(a[i][j]) > abs(a[i][j_max]):
                j_max = j
        if j_max != i:
            for k in range(n):
                a[k][i], a[k][j_max] = a[k][j_max], a[k][i]
            perm[i], perm[j_max] = perm[j_max], perm[i]
        for j in range(i + 1, n):
            c = - a[j][i] / a[i][i]
            for k in range(i, n):
                if k == i:
                    a[j][k] = 0
                else:
                    a[j][k] += c * a[i][k]
            b[j] += c * b[i]
    x1 = [0] * n
    for i in range(n - 1, -1, -1):
        x1[i] = b[i]
        for j in range(n - 1, i, -1):
            x1[i] -= x1[j] * a[i][j]
        x1[i] /= a[i][i]
    x = [0] * n
    for i in range(n):
        x[perm[i]] = x1[i]
    return x


def gauss_method_permutation_strings_and_columns(a, b):
    n = len(a)
    perm = [i for i in range(n)]
    for i in range(n):
        j_max_str = i
        for j in range(i + 1, n):
            if abs(a[j][i]) > abs(a[j_max_str][i]):
                j_max_str = j
        j_max_col = i
        for j in range(i + 1, n):
            if abs(a[i][j]) > abs(a[i][j_max_col]):
                j_max_col = j
        if j_max_str != i or j_max_col != i:
            if j_max_str > j_max_col:
                for k in range(n):
                    a[i][k], a[j_max_str][k] = a[j_max_str][k], a[i][k]
                b[i], b[j_max_str] = b[j_max_str], b[i]
            else:
                for k in range(n):
                    a[k][i], a[k][j_max_col] = a[k][j_max_col], a[k][i]
                perm[i], perm[j_max_col] = perm[j_max_col], perm[i]
        for j in range(i + 1, n):
            c = - a[j][i] / a[i][i]
            for k in range(i, n):
                if k == i:
                    a[j][k] = 0
                else:
                    a[j][k] += c * a[i][k]
            b[j] += c * b[i]
    x1 = [0] * n
    for i in range(n - 1, -1, -1):
        x1[i] = b[i]
        for j in range(n - 1, i, -1):
            x1[i] -= x1[j] * a[i][j]
        x1[i] /= a[i][i]
    x = [0] * n
    for i in range(n):
        x[perm[i]] = x1[i]
    return x


def generate_matrix(n, v1, v2):
    return [[random.uniform(v1, v2) for i in range(n)] for j in range(n)]


def calculate_diagonal_predominance_degree(a):
    n = len(a)
    d = 0
    for i in range(n):
        s = 0
        for j in range(n):
            if i != j:
                s += abs(a[i][j])
        r = abs(a[i][i]) - s
        if i == 0:
            d = r
        elif r > d:
            d = r
    return d


def increase_diagonal_predominance_degree(a, k):
    n = len(a)
    a_new = copy.deepcopy(a)
    for i in range(n):
        s = 0
        for j in range(n):
            if i != j:
                s += abs(a[i][j])
        a_new[i][i] += s * k
    return a_new


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


plt.xlabel('Diagonal predominance degree')
plt.ylabel('Errors')


for n in [10, 50, 100]:

    a1 = generate_matrix(n, -10, 10)
    x = [i for i in range(1, n + 1)]

    k = [0, 0.5, 1, 1.5, 2]

    l = len(k)

    x_degrees = [0] * l
    y_gauss = [0] * l
    y_gauss_perm_str = [0] * l
    y_gauss_perm_col = [0] * l
    y_gauss_perm_str_and_col = [0] * l
    y_gauss_lib = [0] * l

    for i in range(l):

        a = increase_diagonal_predominance_degree(a1, k[i])
        d = calculate_diagonal_predominance_degree(a)

        b = mult_matr_vec(a, x)

        x_num = gauss_method(copy.deepcopy(a), copy.copy(b))
        x_num_perm_str = gauss_method_permutation_strings(copy.deepcopy(a), copy.copy(b))
        x_num_perm_col = gauss_method_permutation_columns(copy.deepcopy(a), copy.copy(b))
        x_num_perm_str_and_col = gauss_method_permutation_strings_and_columns(copy.deepcopy(a), copy.copy(b))
        x_lib = np.linalg.solve(a, b)

        norm_x_num = norm_vec(sub_vec(x, x_num))
        norm_x_num_perm_str = norm_vec(sub_vec(x, x_num_perm_str))
        norm_x_num_perm_col = norm_vec(sub_vec(x, x_num_perm_col))
        norm_x_num_perm_str_and_col = norm_vec(sub_vec(x, x_num_perm_str_and_col))
        norm_x_lib = norm_vec(sub_vec(x, x_lib))

        x_degrees[i] = d

        y_gauss[i] = norm_x_num
        y_gauss_perm_str[i] = norm_x_num_perm_str
        y_gauss_perm_col[i] = norm_x_num_perm_col
        y_gauss_perm_str_and_col[i] = norm_x_num_perm_str_and_col
        y_gauss_lib[i] = norm_x_lib

    plt.plot(x_degrees, y_gauss, color = "blue", label = "Gauss method classic")
    plt.plot(x_degrees, y_gauss_perm_str, color = "green", label = "Gauss method permutation strings")
    plt.plot(x_degrees, y_gauss_perm_col, color = "yellow", label = "Gauss method permutation columns")
    plt.plot(x_degrees, y_gauss_perm_str_and_col, color = "red", label = "Gauss method permutation strings and columns")
    plt.plot(x_degrees, y_gauss_lib, color = "black", label = "Gauss method library")

    plt.legend()

    plt.show()
