import math


def f(x1, x2):
    return (1 + 2 * x1**2 + x2**2)**0.5 + math.exp(x1**2 + 2 * x2**2) - \
        x1 * x2


def df_dx1(x1, x2):
    return 2 * x1 * math.exp(x1**2 + 2 * x2**2) + 2 * x1 / \
        ((2 * x1**2 + x2**2 + 1)**0.5) - x2


def df_dx2(x1, x2):
    return 4 * x2 * math.exp(x1**2 + 2 * x2**2) + x2 / \
        ((2 * x1**2 + x2**2 + 1)**0.5) - x1


def d2f_dx1x1(x1, x2):
    return 4 * x1**2 * math.exp(x1**2 + 2 * x2**2) - 4 * x1**2 / \
        ((2 * x1**2 + x2**2 + 1)**1.5) + 2 * math.exp(x1**2 + 2 * x2**2) + \
        2 / ((2 * x1**2 + x2**2 + 1)**0.5)


def d2f_dx2x2(x1, x2):
    return 16 * x2**2 * math.exp(x1**2 + 2 * x2**2) - x2**2 / \
        ((2 * x1**2 + x2**2 + 1)**1.5) + 4 * math.exp(x1**2 + 2 * x2**2) + \
        1 / ((2 * x1**2 + x2**2 + 1)**0.5)


def d2f_dx1x2(x1, x2):
    return 8 * x1 * x2 * math.exp(x1**2 + 2 * x2**2) - 2 * x1 * x2 / \
        ((2 * x1**2 + x2**2 + 1)**1.5) - 1


def mns(xk, yk, eps):
    k = 0
    df_dx = df_dx1(xk, yk)
    df_dy = df_dx2(xk, yk)
    max_df_dxi = max(abs(df_dx), abs(df_dy))

    while max_df_dxi >= eps:
        df_dx = df_dx1(xk, yk)
        df_dy = df_dx2(xk, yk)
        d2f_dxdx = d2f_dx1x1(xk, yk)
        d2f_dydy = d2f_dx2x2(xk, yk)
        d2f_dxdy = d2f_dx1x2(xk, yk)
        phi1 = -df_dx ** 2 - df_dy ** 2
        phi2 = d2f_dxdx * df_dx ** 2 + 2 * d2f_dxdy * df_dx * df_dy + \
               d2f_dydy * df_dy ** 2
        tk = - phi1 / phi2
        xk = xk - tk * df_dx
        yk = yk - tk * df_dy
        max_df_dxi = max(abs(df_dx), abs(df_dy))
        k += 1

    return k, xk, yk


eps = 0.001

xk = 0
yk = 0

n, x, y = mns(xk, yk, eps)
print(n)
print(x, y)

print()

xk = 1
yk = 0

n, x, y = mns(xk, yk, eps)
print(n)
print(x, y)
