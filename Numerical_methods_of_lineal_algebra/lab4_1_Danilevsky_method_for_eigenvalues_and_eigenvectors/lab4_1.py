import copy
import random

from num_methods import *


def check_ortonormal(vs):
    for v in vs:
        if abs(norm_vec(v) - 1) > 0.001:
            return False
    n = len(vs)
    for i in range(n):
        for j in range(i + 1, n):
            if abs(scalar_mult_vec(vs[i], vs[j])) > 0.001:
                return False
    return True


n = 5
a = generate_symm_matrix(n, 0, 10)

# n = 4
# a = [[2.2, 1, 0.5, 2],
#      [1, 1.3, 2, 1],
#      [0.5, 2, 0.5, 1.6],
#      [2, 1, 1.6, 2]]

d, b = danilevsky_method(a)
p = d[0][:]

g = gershgorin_rounds(a)
print("Boundaries of search for roots from Gershgorin's theorem")
print(g)
print()

ls = div_half_method(g[0], g[1], func(p))
print("Eigenvalues of matrix")
print(ls)
print()

print("Checking Viet theorem")
s = 0
for i in range(len(ls)):
    s += ls[i]
m = 1
for i in range(len(ls)):
    m *= ls[i]
if abs(s - trace_matr(a)) < 0.001 and abs(m - det_matr(a)) < 0.001:
    print("Eigenvalues of matrix satisfy Viet theorem")
else:
    print("Eigenvalues of matrix do not satisfy Viet theorem")
print()

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
print()

print("Checking for orthonormality")
if check_ortonormal(vectors):
    print("Vectors are orthonormal")
else:
    print("Vectors are not orthonormal")

