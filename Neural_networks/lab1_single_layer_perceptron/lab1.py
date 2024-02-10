import math
from num_methods import *


def sigmoid_function(x):
    return 1 / (1 + math.exp(-x))


def tanh_function(x):
    return math.tanh(x)


def linear_function(x):
    return x


def relu_function(x):
    return max(0, x)


def sigmoid_function_der(x):
    return sigmoid_function(x) * (1 - sigmoid_function(x))


def tanh_function_der(x):
    return 1 - tanh_function(x) ** 2


def linear_function_der(x):
    return 1


def relu_function_der(x):
    if x > 0:
        return 1
    else:
        return 0


def mse_loss(y_true, y_received):
    y = sub_vec(y_true, y_received)
    err = 0
    for i in range(len(y)):
        err += y[i] ** 2
    err /= len(y)
    return err


num0 = [1, 1, 1, 1,
        1, 0, 0, 1,
        1, 0, 0, 1,
        1, 0, 0, 1,
        1, 1, 1, 1]

num1 = [0, 0, 0, 1,
        0, 0, 0, 1,
        0, 0, 0, 1,
        0, 0, 0, 1,
        0, 0, 0, 1]

num2 = [1, 1, 1, 1,
        0, 0, 0, 1,
        1, 1, 1, 1,
        1, 0, 0, 0,
        1, 1, 1, 1]

num3 = [1, 1, 1, 1,
        0, 0, 0, 1,
        1, 1, 1, 1,
        0, 0, 0, 1,
        1, 1, 1, 1]

num4 = [1, 0, 0, 1,
        1, 0, 0, 1,
        1, 1, 1, 1,
        0, 0, 0, 0,
        1, 1, 1, 1]

num5 = [1, 1, 1, 1,
        1, 0, 0, 0,
        1, 1, 1, 1,
        0, 0, 0, 1,
        1, 1, 1, 1]

num6 = [1, 1, 1, 1,
        1, 0, 0, 0,
        1, 1, 1, 1,
        1, 0, 0, 1,
        1, 1, 1, 1]

num7 = [1, 1, 1, 1,
        0, 0, 0, 1,
        0, 0, 0, 1,
        0, 0, 0, 1,
        0, 0, 0, 1]

num8 = [1, 1, 1, 1,
        1, 0, 0, 1,
        1, 1, 1, 1,
        1, 0, 0, 1,
        1, 1, 1, 1]

num9 = [1, 1, 1, 1,
        1, 0, 0, 1,
        1, 1, 1, 1,
        0, 0, 0, 1,
        1, 1, 1, 1]

nums = [num0, num1, num2, num3, num4, num5, num6, num7, num8, num9]

learning_rate = 0.1
epochs = 1000


class Perceptron:
    def __init__(self, size, activation_function):
        self.activation_function = activation_function
        self.size = size
        self.weights = [[0] * size for _ in range(10)]
        self.loss = []

    def calculation(self, num, weights_ind):
        return scalar_mult_vec(num, self.weights[weights_ind])

    def calculate_res(self, num, weights_ind):
        return self.activation_function(scalar_mult_vec(num, self.weights[weights_ind]))

    def train(self, nums, learning_rate, epochs):
        for epoch in range(epochs):
            for num_ind in range(len(nums)):
                for weights_ind in range(len(self.weights)):
                    y_true = int(num_ind == weights_ind)
                    y_received = self.calculate_res(nums[num_ind], weights_ind)
                    error = y_true - y_received
                    for i in range(len(self.weights[weights_ind])):
                        self.weights[weights_ind][i] += learning_rate * nums[num_ind][i] * error
            y_receiveds = []
            y_trues = []
            for num_ind in range(len(nums)):
                for weights_ind in range(len(self.weights)):
                    y_trues.append(int(num_ind == weights_ind))
                    y_receiveds.append(self.calculate_res(nums[num_ind], weights_ind))
            self.loss.append(mse_loss(y_trues, y_receiveds))

    def get_loss(self, i):
        return self.loss[i]


def check(perceptron, num):
    max_value = 0
    res_num = 0
    for i in range(10):
        value = perceptron.calculate_res(num, i)
        if value > max_value:
            max_value = value
            res_num = i
    if max_value != 0:
        return res_num
    else:
        return "Цифра не распознана"


perceptron_sigmoid = Perceptron(size=20, activation_function=sigmoid_function)
perceptron_tanh = Perceptron(size=20, activation_function=tanh_function)
perceptron_linear = Perceptron(size=20, activation_function=linear_function)
perceptron_relu = Perceptron(size=20, activation_function=relu_function)

perceptron_sigmoid.train(nums, learning_rate, epochs)
print("Perceptron sigmoid weights")
print(perceptron_sigmoid.weights)
perceptron_tanh.train(nums, learning_rate, epochs)
print("Perceptron tanh weights")
print(perceptron_tanh.weights)
perceptron_linear.train(nums, learning_rate, epochs)
print("Perceptron linear weights")
print(perceptron_linear.weights)
perceptron_relu.train(nums, learning_rate, epochs)
print("Perceptron relu weights")
print(perceptron_relu.weights)

print(check(perceptron_sigmoid, num2))
print(check(perceptron_sigmoid, num5))
print(check(perceptron_sigmoid, num7))

num51 = [1, 1, 1, 1,
         1, 0, 0, 0,
         1, 1, 1, 0,
         0, 0, 0, 1,
         1, 1, 1, 1]

num52 = [1, 1, 1, 1,
         1, 0, 0, 0,
         0, 1, 1, 1,
         0, 0, 0, 1,
         1, 1, 1, 1]

num53 = [1, 1, 1, 0,
         1, 0, 0, 0,
         1, 1, 1, 1,
         0, 0, 0, 1,
         1, 1, 1, 1]

num54 = [1, 1, 1, 0,
         1, 0, 0, 0,
         1, 1, 1, 1,
         0, 0, 0, 1,
         0, 1, 1, 1]

num71 = [1, 1, 1, 1,
         0, 0, 0, 1,
         0, 0, 1, 1,
         0, 0, 0, 1,
         0, 0, 0, 1]

num81 = [0, 1, 1, 0,
         1, 0, 0, 1,
         0, 1, 1, 0,
         1, 0, 0, 1,
         0, 1, 1, 0]

print(check(perceptron_sigmoid, num51))
print(check(perceptron_sigmoid, num52))
print(check(perceptron_sigmoid, num53))
print(check(perceptron_sigmoid, num54))
print(check(perceptron_sigmoid, num71))
print(check(perceptron_sigmoid, num81))


plt.plot([i for i in range(epochs)], [perceptron_sigmoid.get_loss(i) for i in range(epochs)], label='Sigmoid', color='blue')
plt.xlabel('Epochs')
plt.ylabel('Loss')
plt.title('Loss and Epochs')
plt.legend()
plt.show()
plt.plot([i for i in range(epochs)], [perceptron_tanh.get_loss(i) for i in range(epochs)], label='Tanh', color='yellow')
plt.xlabel('Epochs')
plt.ylabel('Loss')
plt.title('Loss and Epochs')
plt.legend()
plt.show()
plt.plot([i for i in range(epochs)], [perceptron_linear.get_loss(i) for i in range(epochs)], label='Linear', color='green')
plt.xlabel('Epochs')
plt.ylabel('Loss')
plt.title('Loss and Epochs')
plt.legend()
plt.show()
plt.plot([i for i in range(epochs)], [perceptron_relu.get_loss(i) for i in range(epochs)], label='ReLu', color='red')
plt.xlabel('Epochs')
plt.ylabel('Loss')
plt.title('Loss and Epochs')
plt.legend()
plt.show()
