from num_methods import *

n = 5
a = generate_symm_matrix(n, 1, 10)
a = increase_diagonal_elements_to_diagonal_predominance(a)
x_true = [i for i in range(1, n + 1)]
f = mult_matr_vec(a, x_true)

d, b = danilevsky_method(a)
p1 = d[0][:]
g1 = gershgorin_rounds(a)
ls = div_half_method(g1[0], g1[1], func(p1))

l_min = min(ls)
l_max = max(ls)
t_opt = 2 / (l_min + l_max)

print("t optimal")
print(t_opt)
print()

eps = 0.0001

ks = []
ts = []

t_start = 0.0001

t = t_start

t_opt_graphic = t
k_min = 0

while t < 2 / l_max:
    k = 0
    x_old = [0] * n
    p = sub_matr_matr(generate_unit_matr(n), mult_matr_num(t, a))
    g = mult_vec_num(t, f)

    max_m = 0
    for i in range(len(ls)):
        m = 1 - t * ls[i]
        if abs(m) > max_m:
            max_m = abs(m)
    if max_m >= 1:
        print("max_m >= 1")

    while True:
        x = sum_vec(mult_matr_vec(p, x_old), g)
        if norm_vec(sub_vec(x, x_old)) < eps:
            break
        if round(norm_vec_sq(sub_vec(x_true, x)), 5) > round((max_m**2) * norm_vec_sq(sub_vec(x_true, x_old)), 5):
            print("Convergence condition is not satisfied")
        x_old = x[:]
        k += 1
    if t == t_start:
        k_min = k
        t_opt_graphic = t
    elif k <= k_min:
        k_min = k
        t_opt_graphic = t
    ts.append(t)
    ks.append(k)
    t += 0.0001

print("t optimal graphic")
print(t_opt_graphic)

plt.xlabel('t')
plt.ylabel('k')
plt.grid()
plt.plot(ts, ks)
plt.show()
