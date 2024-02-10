import time
from multiprocessing.pool import ThreadPool
import numpy as np
from num_methods import *


def strass(a, b, n_min):
    n = len(a)
    if n <= n_min:
        return np.array(mult_matr_matr(a, b))
    a11, a12, a21, a22 = split_into_parts(a)
    b11, b12, b21, b22 = split_into_parts(b)
    p1 = strass(a11 + a22, b11 + b22, n_min)
    p2 = strass(a21 + a22, b11, n_min)
    p3 = strass(a11, b12 - b22, n_min)
    p4 = strass(a22, b21 - b11, n_min)
    p5 = strass(a11 + a12, b22, n_min)
    p6 = strass(a11 - a21, b11 + b12, n_min)
    p7 = strass(a12 - a22, b21 + b22, n_min)
    c11 = p1 + p4 - p5 + p7
    c12 = p3 + p5
    c21 = p2 + p4
    c22 = p1 + p3 - p2 + p6
    res = np.vstack((np.hstack((c11, c12)), np.hstack((c21, c22))))
    return res


def strass_multiprocessing(a, b, n_min):
    n = len(a)
    if n <= n_min:
        return np.array(mult_matr_matr(a, b))
    a11, a12, a21, a22 = split_into_parts(a)
    b11, b12, b21, b22 = split_into_parts(b)
    pool = ThreadPool(processes=7)
    p1 = pool.apply_async(strass, (a11 + a22, b11 + b22, n_min)).get()
    p2 = pool.apply_async(strass, (a21 + a22, b11, n_min)).get()
    p3 = pool.apply_async(strass, (a11, b12 - b22, n_min)).get()
    p4 = pool.apply_async(strass, (a22, b21 - b11, n_min)).get()
    p5 = pool.apply_async(strass, (a11 + a12, b22, n_min)).get()
    p6 = pool.apply_async(strass, (a11 - a21, b11 + b12, n_min)).get()
    p7 = pool.apply_async(strass, (a12 - a22, b21 + b22, n_min)).get()
    c11 = p1 + p4 - p5 + p7
    c12 = p3 + p5
    c21 = p2 + p4
    c22 = p1 + p3 - p2 + p6
    res = np.vstack((np.hstack((c11, c12)), np.hstack((c21, c22))))
    return res


def split_into_parts(matr):
    n, m = matr.shape
    n1, m1 = n // 2, m // 2
    return matr[:n1, :m1], matr[:n1, m1:], matr[n1:, :m1], matr[n1:, m1:]


n = 128

a = np.array(generate_matrix(n, -10, 10))
b = np.array(generate_matrix(n, -10, 10))

n_min = 64

c1 = strass(a, b, n_min)
print("Strassen method")
print_matr(c1)
print()
c2 = strass_multiprocessing(a, b, n_min)
print("Strassen method with multiprocessing")
print_matr(c2)
print()
c3 = mult_matr_matr(a, b)
print("Standart algorithm")
print_matr(c3)
print()

x = [2 ** i for i in range(5, 9)]
y1 = []
y2 = []
y3 = []

for n in x:
    a = np.array(generate_matrix(n, -10, 10))
    b = np.array(generate_matrix(n, -10, 10))
    t1 = time.time()
    c1 = strass(a, b, n_min)
    t2 = time.time()
    y1.append(t2 - t1)
    t3 = time.time()
    c2 = strass_multiprocessing(a, b, n_min)
    t4 = time.time()
    y2.append(t4 - t3)
    t5 = time.time()
    c3 = mult_matr_matr(a, b)
    t6 = time.time()
    y3.append(t6 - t5)
    print(n)

plt.xlabel('n')
plt.ylabel('time')
plt.grid()
plt.plot(x, y1, color = "blue", label = "Strassen method")
plt.plot(x, y2, color = "red", label = "Strassen method multiprocessing")
plt.plot(x, y3, color = "green", label = "Standart algorithm")

plt.legend()
plt.show()
