def f(x):
    return 1 / (x + x ** 2)


n = 32

a = 0.25
b = 2
h = (b - a) / n

y = [0] * (n + 1)
x = [0] * (n + 1)

for i in range(n + 1):
    x[i] = a + h * i
    y[i] = f(x[i])

nm = n - 1

am = [0] + [1] * (nm - 1)
bm = [0] + [4] * nm
cm = [0] + [1] * (nm - 1)

dm = [0] * (nm + 1)

k = 3 / h ** 2

for i in range(1, nm + 1):
    dm[i] = k * (y[i + 1] - 2 * y[i] + y[i - 1])

alpha = [0] * nm
beta = [0] * nm

for i in range(1, nm):
    alpha[i] = -cm[i] / (am[i - 1] * alpha[i - 1] + bm[i])
    beta[i] = (dm[i] - am[i - 1] * beta[i - 1]) / (am[i - 1] *
                                                   alpha[i - 1] + bm[i])

xr = [0] * (nm + 1)

xr[nm] = (dm[nm] - am[nm - 1] * beta[nm - 1]) / (am[nm - 1] *
                                                 alpha[nm - 1] + bm[nm])

for i in range(nm - 1, 0, -1):
    xr[i] = alpha[i] * xr[i + 1] + beta[i]

ci = [0, 0] + xr[1:] + [0]

ai = [0] * (n + 1)
bi = [0] * (n + 1)
di = [0] * (n + 1)

for i in range(1, n + 1):
    ai[i] = y[i - 1]
    bi[i] = (y[i] - y[i - 1]) / h - h * (ci[i + 1] + 2 * ci[i]) / 3
    di[i] = (ci[i + 1] - ci[i]) / (3 * h)

for i in range(1, n + 1):
    print("a[" + str(i) + "] = " + str(ai[i]) + ", b[" + str(i) + "] = "
          + str(bi[i]) + ", c[" + str(i) + "] = " + str(ci[i]) +
          ", d[" + str(i) + "] =", di[i])

print()

for i in range(n + 1):
    if i == 0:
        sr = ai[1]
        print("x[0] = " + str(x[0]))
        print("y(" + str(x[0]) + ") = " + str(y[0]))
        print("S1(" + str(x[0]) + ") = " + str(sr))
        print("e = " + str(abs(y[0] - sr)))
        print()
    else:
        sr1 = ai[i] + bi[i] * (h / 2) + ci[i] * ((h / 2) ** 2) + \
              di[i] * ((h / 2) ** 3)
        print("x[" + str(i) + "] - " + str(h / 2) + " = " +
              str(x[i] - h / 2))
        print("y(" + str(x[i] - h / 2) + ") = " + str(f(x[i] -
                                                        h / 2)))
        print("S" + str(i) + "(" + str(x[i] - h / 2) + ") = " +
              str(sr1))
        print("e = " + str(abs(f(x[i] - h / 2) - sr1)))
        print()
        sr = ai[i] + bi[i] * h + ci[i] * (h ** 2) + di[i] * (h ** 3)
        print("x[" + str(i) + "] = " + str(x[i]))
        print("y(" + str(x[i]) + ") = " + str(y[i]))
        print("S" + str(i) + "(" + str(x[i]) + ") = " + str(sr))
        print("e = " + str(abs(y[i] - sr)))
        print()
