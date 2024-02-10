def norm_v(x):
    norm = 0
    n = len(x)
    for i in range(n):
        if abs(x[i]) > norm:
            norm = abs(x[i])
    return norm


def sub_v(x, y):
    n = len(x)
    sub = [0] * n
    for i in range(n):
        sub[i] = x[i] - y[i]
    return sub


def sum_v(x, y):
    n = len(x)
    sum = [0] * n
    for i in range(n):
        sum[i] = x[i] + y[i]
    return sum


def mul_mv(a, x):
    n = len(x)
    mul = [0] * n
    for i in range(n):
        for j in range(n):
            mul[i] += a[i][j] * x[j]
    return mul


k = 21
a = 0.1 * k
b = 0.1 * k
am = [[10.0 + a, -1.0, 0.2, 2.0],
      [1.0, 12.0 - a, -2.0, 0.1],
      [0.3, -4.0, 12.0 - a, 1.0],
      [0.2, -0.3, -0.5, 8.0 - a]]
bm = [1.0 + b, 2.0 - b, 3.0, 1.0]

n = 4

fm = [[0] * n for i in range(n)]
cm = [0] * n

for i in range(n):
    for j in range(n):
        if i != j:
            fm[i][j] = -am[i][j] / am[i][i]
for i in range(n):
    cm[i] = bm[i] / am[i][i]

print("F =")
for i in range(n):
    for j in range(n):
        print("{:24} ".format(str(fm[i][j])), end = "")
    print()
print()

print("c =")
for i in range(n):
    print("{:24}".format(str(cm[i])))
print()

fm_norm = 0
for i in range(n):
    s = 0
    for j in range(n):
        s += abs(fm[i][j])
    if s > fm_norm:
        fm_norm = s

print("||F|| =", fm_norm)
print()

k = 0
xk = cm[:]
otn_delta = 1

print("A simple iteration method with a relative error of 0.01")
print()

while otn_delta > 0.01:
    k += 1
    xk_last = xk[:]
    xk = sum_v(mul_mv(fm, xk_last), cm)
    abs_delta = norm_v(sub_v(xk, xk_last))
    otn_delta = abs_delta / norm_v(xk)
    print("{:4} {:24} {:24}".format(str(k), str(abs_delta), str(otn_delta)))

print()

fd = [[0] * n for i in range(n)]
fu = [[0] * n for i in range(n)]

for i in range(n):
    for j in range(n):
        if j < i:
            fd[i][j] = fm[i][j]

for i in range(n):
    for j in range(n):
        if i <= j:
            fu[i][j] = fm[i][j]

print("Seidel's method with an absolute error of 0.0001")
print()

k = 0
xk = cm[:]
abs_delta = 1

while abs_delta > 0.0001:
    k += 1
    xk_last = xk[:]
    xk = mul_mv(fu, xk_last)
    xk = mul_mv(fd, xk)
    xk = sum_v(xk, cm)
    abs_delta = norm_v(sub_v(xk, xk_last))
    otn_delta = abs_delta / norm_v(xk)
    print("{:4} {:24} {:24}".format(str(k), str(abs_delta), str(otn_delta)))
