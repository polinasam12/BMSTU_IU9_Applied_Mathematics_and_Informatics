def mnk(n, x, y, m):
    a = []
    for i in range(m):
        a.append([0] * m)
    b = [0] * m

    for i in range(m):
        for j in range(m):
            for k in range(n + 1):
                a[i][j] += x[k] ** (i + j)

    for i in range(m):
        for k in range(n + 1):
            b[i] += y[k] * (x[k] ** i)

    print("A =")

    for i in range(m):
        for j in range(m):
            print("{:20} ".format(str(a[i][j])), end="")
        print()

    print()

    print("b =")

    for i in range(m):
        print(b[i])

    print()

    t = []
    for i in range(m):
        t.append([0] * m)

    t_tr = []

    for i in range(m):
        t_tr.append([0] * m)

    t[0][0] = a[0][0] ** 0.5

    for j in range(1, m):
        t[0][j] = a[0][j] / t[0][0]

    for i in range(1, m):
        for j in range(m):
            if i == j:
                s = 0
                for k in range(i):
                    s += t[k][i] ** 2
                t[i][i] = (a[i][i] - s) ** 0.5
            elif i < j:
                s = 0
                for k in range(i):
                    s += t[k][i] * t[k][j]
                t[i][j] = (a[i][j] - s) / t[i][i]

    for i in range(m):
        for j in range(m):
            t_tr[i][j] = t[j][i]

    xr = [0] * m
    yr = [0] * m

    yr[0] = b[0] / t[0][0]

    for i in range(1, m):
        s = 0
        for k in range(i):
            s += t[k][i] * yr[k]
        yr[i] = (b[i] - s) / t[i][i]

    xr[m - 1] = yr[m - 1] / t[m - 1][m - 1]

    for i in range(m - 2, -1, -1):
        s = 0
        for k in range(i + 1, m):
            s += t[i][k] * xr[k]
        xr[i] = (yr[i] - s) / t[i][i]

    la = xr[:]

    print("lambda =")

    for i in range(m):
        print(la[i])

    print()

    s = 0

    for k in range(n + 1):
        s1 = 0
        for q in range(m):
            s1 += la[q] * (x[k] ** q)
        s += (y[k] - s1) ** 2

    abs_delta = (1 / (n ** 0.5)) * (s ** 0.5)

    s = 0

    for k in range(n + 1):
        s += y[k] ** 2

    otn_delta = abs_delta / (s ** 0.5)

    print("abs_delta =")
    print(abs_delta)

    print()

    print("otn_delta = ")
    print(otn_delta)

    print()

    ym = [0] * n

    for i in range(n):
        xm = (x[i] + x[i + 1]) / 2
        s = 0
        for k in range(m):
            s += (la[k] * (xm ** k))
        ym[i] = s

    print("ym = ")
    for i in range(n):
        print(ym[i])


n = 8
x = [1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5]
y = [0.86, 0.97, 0.65, 0.75, 1.60, 0.65, 1.34, 1.62, 1.01]
m = 4

print("1.")
print()
mnk(n, x, y, m)
print()

n = 10
x = [0.0, 0.1, 0.2, 0.30000000000000004, 0.4, 0.5, 0.6000000000000001,
     0.7000000000000001, 0.8, 0.9, 1.0]
y = [1.0, 1.205004334722476, 1.420072088955231, 1.6453790142373428,
     1.881243039949921, 2.128146809304331, 2.3867612737855444,
     2.6579703947081676, 2.9428970193919906, 3.242930020784433,
     3.5597528132669414]
m = 4

print("2.")
print()
mnk(n, x, y, m)
