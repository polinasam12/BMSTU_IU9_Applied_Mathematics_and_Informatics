import numpy as np
from num_methods import *


def svd_decomposition(matrix):
    covariance_matrix = np.dot(matrix.T, matrix)

    eigenvalues, eigenvectors = np.linalg.eig(covariance_matrix)

    singular_values = np.sqrt(eigenvalues)
    singular_vectors = eigenvectors
    left_singular_vectors = matrix.dot(singular_vectors) / singular_values
    right_singular_vectors = singular_vectors

    ns = len(singular_values)
    s = [[0] * ns for _ in range(ns)]
    for i in range(ns):
        s[i][i] = singular_values[i]

    return left_singular_vectors, s, right_singular_vectors.T


matrix = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
U, S, Vt = svd_decomposition(matrix)
print("Result:")
print("U:")
print_matr(U)
print()
print("S:")
print_matr(S)
print()
print("Vt:")
print_matr(Vt)
print()

res = mult_matr_matr(mult_matr_matr(U, S), Vt)
print("Result after multiplication")
print_matr(res)
print()

print("Result numpy")
U, singular_values, Vt = np.linalg.svd(matrix)
ns = len(singular_values)
s = [[0] * ns for _ in range(ns)]
for i in range(ns):
    s[i][i] = singular_values[i]
print("U:")
print_matr(U)
print()
print("S:")
print_matr(s)
print()
print("Vt:")
print_matr(Vt)
print()
