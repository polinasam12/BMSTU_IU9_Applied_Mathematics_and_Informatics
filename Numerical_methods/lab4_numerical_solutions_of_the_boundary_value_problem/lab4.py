import math


def func(x):
    return math.cos(x) - 3 * math.sin(x)


def y_solution(x):
    return math.exp(x) + math.sin(x)


n = 10

a = 0
b = 1
h = (b - a) / n

y_a = 1
y_b = y_solution(1)

f = [0] * (n + 1)
x = [0] * (n + 1)

p = [1] * (n + 1)
q = [-2] * (n + 1)

for i in range(n + 1):
    x[i] = a + h * i
    f[i] = func(x[i])

a = [0]
b = [0]
c = [0]
d = [0]

for i in range(n):
    b.append(h * h * q[i + 1] - 2)

for i in range(1, n):
    a.append(1 - h / 2 * p[i + 1])

for i in range(n - 1):
    c.append(1 + h / 2 * p[i + 1])

for i in range(n):
    if i == 0:
        d.append(h * h * f[1] - y_a * (1 - h / 2 * p[1]))
    else:
        d.append(h * h * f[i + 1])

alpha = [0] * n
beta = [0] * n

for i in range(1, n):
    alpha[i] = -c[i] / (a[i - 1] * alpha[i - 1] + b[i])
    beta[i] = (d[i] - a[i - 1] * beta[i - 1]) / \
              (a[i - 1] * alpha[i - 1] + b[i])

y = [0] * (n + 1)

y[0] = y_a
y[n] = y_b

for i in range(n - 1, 0, -1):
    y[i] = alpha[i] * y[i + 1] + beta[i]

y_right = [0] * (n + 1)

for i in range(n + 1):
    y_right[i] = y_solution(x[i])

print(x)
print(y_right)
print()

for i in range(n + 1):
    print("{:20} {:20} {:20} {:20}".format(str(x[i]), str(y_right[i]),
                                           str(y[i]),
                                           str(abs(y_right[i] - y[i]))))

print()

e1 = 0

for i in range(n + 1):
    m = abs(y_right[i] - y[i])
    if m > e1:
        e1 = m

print(e1)

print()

y0 = [0] * (n + 1)
y1 = [0] * (n + 1)

y0[0] = y_a
y0[1] = y_a + h
y1[1] = h

for i in range(1, n):
    y0[i + 1] = (f[i] * h * h + (2 - q[i] * h * h) * y0[i] -
                 (1 - p[i] * h / 2) * y0[i - 1]) / (1 + p[i] * h / 2)
    y1[i + 1] = ((2 - q[i] * h * h) * y1[i] - (1 - p[i] * h / 2) *
                 y1[i - 1]) / (1 + p[i] * h / 2)

c1 = (y_b - y0[n]) / y1[n]

y = [0] * (n + 1)

for i in range(n + 1):
    y[i] = y0[i] + c1 * y1[i]

for i in range(n + 1):
    print("{:20} {:20} {:20} {:20}".format(str(x[i]), str(y_right[i]),
                                           str(y[i]),
                                           str(abs(y_right[i] - y[i]))))

print()

e2 = 0

for i in range(n + 1):
    m = abs(y_right[i] - y[i])
    if m > e2:
        e2 = m

print(e2)

print()

print(e1 - e2)
