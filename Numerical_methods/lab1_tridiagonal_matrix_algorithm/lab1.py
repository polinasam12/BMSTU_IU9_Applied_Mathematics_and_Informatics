from decimal import *

getcontext().prec = 32


def det(m):
    l = len(m)
    if l == 2:
        return m[0][0] * m[1][1] - m[1][0] * m[0][1]
    else:
        d = 0
        for i in range(l):
            d += m[0][i] * alg_add(m, 0, i)
        return d


def alg_add(m, i, j):
    l = len(m)
    m1 = []
    for k in range(l):
        if k != i:
            m1.append([])
            for q in range(l):
                if q != j:
                    m1[-1].append(m[k][q])
    return (-1) ** (i + j) * det(m1)


def module_v(v):
    s = 0
    for i in range(len(v)):
        s += v[i] ** Decimal(2)
    return s ** Decimal(1/2)


def print_v(v):
    for i in range(len(v)):
        print(v[i])


n = 4

m = [[4, 1, 0, 0],
     [1, 4, 1, 0],
     [0, 1, 4, 1],
     [0, 0, 1, 4]]

x_accurate = [1, 1, 1, 1]

a = [0]
b = [0]
c = [0]

for i in range(n):
    for j in range(n):
        m[i][j] = Decimal(m[i][j])
        if i == j:
            b.append(m[i][j])
        elif i == j + 1:
            a.append(m[i][j])
        elif i == j - 1:
            c.append(m[i][j])

d = [0, 5, 6, 6, 5]
d = list(map(str, d))
d = list(map(Decimal, d))

print(a)
print(b)
print(c)
print(d)

alpha = [0] * n
beta = [0] * n

for i in range(1, n):
    alpha[i] = -c[i] / (a[i - 1] * alpha[i - 1] + b[i])
    beta[i] = (d[i] - a[i - 1] * beta[i - 1]) / \
              (a[i - 1] * alpha[i - 1] + b[i])

x_inaccurate = [0] * (n + 1)

x_inaccurate[n] = (d[n] - a[n - 1] * beta[n - 1]) / \
                  (a[n - 1] * alpha[n - 1] + b[n])

for i in range(n - 1, 0, -1):
    x_inaccurate[i] = alpha[i] * x_inaccurate[i + 1] + beta[i]

x_inaccurate = x_inaccurate[1:]

e1 = [0] * n

for i in range(n):
    e1[i] = x_accurate[i] - x_inaccurate[i]

print("x_inaccurate")
print_v(x_inaccurate)
print()
print("e1")
print_v(e1)
print()
print("|e1|")
print(module_v(e1))
print()

a = a[1:]
b = b[1:]
c = c[1:]
d = d[1:]

d_inaccurate = [0] * n

d_inaccurate[0] = b[0] * x_inaccurate[0] + c[0] * x_inaccurate[1]
if n > 1:
    d_inaccurate[n - 1] = a[n - 2] * x_inaccurate[-2] + b[n - 1] * \
                          x_inaccurate[-1]
for i in range(1, n - 1):
    d_inaccurate[i] = a[i - 1] * x_inaccurate[i - 1] + b[i] * \
                      x_inaccurate[i] + c[i] * x_inaccurate[i + 1]

r = [0] * n

for i in range(n):
    r[i] = d[i] - d_inaccurate[i]

m_inverse = []
for i in range(n):
    m_inverse.append([0] * n)

c = Decimal(1) / Decimal(det(m))

for i in range(n):
    for j in range(n):
        m_inverse[j][i] = c * alg_add(m, i, j)

e2 = [0] * n

for i in range(n):
    for j in range(n):
        e2[i] += m_inverse[i][j] * r[j]

x = [0] * n

for i in range(n):
    x[i] = x_inaccurate[i] + e2[i]

print("d_inaccurate")
print_v(d_inaccurate)
print()
print("x")
print_v(x)
print()
print("e2")
print_v(e2)
print()
print("|e2|")
print(module_v(e2))
