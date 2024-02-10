import random
import pickle
import gzip
import numpy as np
from matplotlib import pyplot as plt


def load_data():
    with gzip.open('../data/mnist.pkl.gz', 'rb') as f:
        (training_data, validation_data, test_data) = pickle.load(f, encoding='latin1')
    return (training_data, validation_data, test_data)


def load_data_wrapper():
    tr_d, va_d, te_d = load_data()
    training_inputs = [np.reshape(x, (784, 1)) for x in tr_d[0]]
    training_results = [vectorized_result(y) for y in tr_d[1]]
    training_data = list(zip(training_inputs, training_results))
    validation_inputs = [np.reshape(x, (784, 1)) for x in va_d[0]]
    validation_data = list(zip(validation_inputs, va_d[1]))
    test_inputs = [np.reshape(x, (784, 1)) for x in te_d[0]]
    test_data = list(zip(test_inputs, te_d[1]))
    return (training_data, validation_data, test_data)


def vectorized_result(j):
    e = np.zeros((10, 1))
    e[j] = 1.0
    return e


def sigmoid(x):
    return 1 / (1 + np.exp(-x))


def sigmoid_der(x):
    return sigmoid(x) * (1 - sigmoid(x))


def relu(x):
    x = x.flatten()
    return np.array([[max(c, 0)] for c in x])


def relu_der(x):
    x = x.flatten()
    return np.array([[1 if c > 0 else 0] for c in x])


def softmax(z):
    e_z = np.exp(z - np.max(z))
    return e_z / e_z.sum()


def softmax_der(z):
    s = softmax(z)
    return np.diag(s) - np.outer(s, s)


def mse(y_true, y_received):
    return np.linalg.norm(y_true - y_received)


def mse_der(y_true, y_received):
    return y_true - y_received


def categorical_cross_entropy(y0, y):
    return -(y0 * np.log(y) + (1 - y0) * np.log(1 - y))


def categorical_cross_entropy_der(y0, y):
    return -(y0 / y - (1 - y0) / (1 - y))


def kl_divergence(y0, y):
    if y0 == 0:
        return 0
    else:
        return y0 * np.log(y0 / y)


def kl_divergence_der(y0, y):
    return np.log(y0 / y) + 1


class MultilayerPerceptron(object):

    def __init__(self, sizes, optimization_method, activation_function, loss_function):
        self.num_layers = len(sizes)
        self.optimization_method = optimization_method
        self.activation_function = activation_function
        if activation_function == sigmoid:
            self.activation_function_der = sigmoid_der
        elif activation_function == relu:
            self.activation_function_der = relu_der
        elif activation_function == softmax:
            self.activation_function_der = softmax_der
        self.loss_function = loss_function
        if loss_function == mse:
            self.loss_function_der = mse_der
        elif loss_function == categorical_cross_entropy:
            self.loss_function_der = categorical_cross_entropy_der
        elif self.loss_function == kl_divergence:
            self.loss_function_der = kl_divergence_der
        self.sizes = sizes
        self.biases = [np.random.randn(y, 1) for y in sizes[1:]]
        self.weights = [np.random.randn(y, x) for x, y in zip(sizes[:-1], sizes[1:])]
        self.loss = []

    def feedforward(self, a):
        for b, w in zip(self.biases, self.weights):
            a = self.activation_function(np.dot(w, a) + b)
        return a

    def train(self, training_data, epochs, mini_batch_size, eta, test_data):
        if self.optimization_method == "gradient_descent":
            self.SGD(training_data, epochs, mini_batch_size, eta, test_data)
        elif self.optimization_method == "fletcher_reeves":
            self.fletcher_reeves_optimization(training_data, epochs, mini_batch_size, eta, test_data)
        elif self.optimization_method == "bfgs":
            self.bfgs(training_data, epochs, mini_batch_size, test_data)

    def SGD(self, training_data, epochs, mini_batch_size, eta, test_data):
        n = len(training_data)
        for j in range(epochs):
            random.shuffle(training_data)
            mini_batches = [training_data[k : k+mini_batch_size] for k in range(0, n, mini_batch_size)]
            for mini_batch in mini_batches:
                self.update_mini_batch(mini_batch, eta)
            self.test(test_data)

    def update_mini_batch(self, mini_batch, eta):
        nabla_b = [np.zeros(b.shape) for b in self.biases]
        nabla_w = [np.zeros(w.shape) for w in self.weights]
        for x, y in mini_batch:
            delta_nabla_b, delta_nabla_w = self.backprop(x, y)
            nabla_b = [nb + dnb for nb, dnb in zip(nabla_b, delta_nabla_b)]
            nabla_w = [nw + dnw for nw, dnw in zip(nabla_w, delta_nabla_w)]
        self.weights = [w - (eta / len(mini_batch)) * nw for w, nw in zip(self.weights, nabla_w)]
        self.biases = [b - (eta / len(mini_batch)) * nb for b, nb in zip(self.biases, nabla_b)]

    def backprop(self, x, y):
        nabla_b = [np.zeros(b.shape) for b in self.biases]
        nabla_w = [np.zeros(w.shape) for w in self.weights]

        activation = x
        activations = [x]
        zs = []
        for b, w in zip(self.biases, self.weights):
            z = np.dot(w, activation) + b
            zs.append(z)
            activation = self.activation_function(z)
            activations.append(activation)

        delta = self.loss_function_der(activations[-1], y) * self.activation_function_der(zs[-1])
        nabla_b[-1] = delta
        nabla_w[-1] = np.dot(delta, activations[-2].transpose())

        for l in range(2, self.num_layers):
            z = zs[-l]
            sp = self.activation_function_der(z)
            delta = np.dot(self.weights[-l + 1].transpose(), delta) * sp
            nabla_b[-l] = delta
            nabla_w[-l] = np.dot(delta, activations[-l - 1].transpose())

        return (nabla_b, nabla_w)

    def fletcher_reeves(self, g, old_g, d):
        beta = np.dot(g.T, g) / np.dot(old_g.T, old_g)
        new_d = -g + beta * d
        return new_d

    def fletcher_reeves_optimization(self, training_data, epochs, mini_batch_size, eta, test_data):
        n = len(training_data)
        old_grad = [np.zeros(w.shape) for w in self.weights]
        for j in range(epochs):
            random.shuffle(training_data)
            mini_batches = [training_data[k : k+mini_batch_size] for k in range(0, n, mini_batch_size)]
            for mini_batch in mini_batches:
                old_grad = self.update_mini_batch_fletcher_reeves(mini_batch, eta, old_grad)
            self.test(test_data)

    def update_mini_batch_fletcher_reeves(self, mini_batch, eta, old_grad):
        nabla_b = [np.zeros(b.shape) for b in self.biases]
        nabla_w = [np.zeros(w.shape) for w in self.weights]
        for x, y in mini_batch:
            delta_nabla_b, delta_nabla_w = self.backprop(x, y)
            nabla_b = [nb + dnb for nb, dnb in zip(nabla_b, delta_nabla_b)]
            nabla_w = [nw + dnw for nw, dnw in zip(nabla_w, delta_nabla_w)]

        grad = nabla_w
        d = [-g for g in grad]
        if old_grad[0][0][0] != 0:
            d = self.fletcher_reeves(grad, old_grad, d)
        for i in range(len(self.weights)):
            self.weights[i] += (eta / len(mini_batch)) * d[i]
        return grad

    def bfgs(self, training_data, epochs, mini_batch_size, test_data):
        H = np.identity(sum(self.sizes[1:]))
        for j in range(epochs):
            random.shuffle(training_data)
            mini_batches = [training_data[k: k + mini_batch_size] for k in range(0, len(training_data), mini_batch_size)]
            for mini_batch in mini_batches:
                H, nabla_b, nabla_w = self.update_bfgs(H, mini_batch)
                self.weights -= np.dot(H, nabla_w)
                self.biases -= np.dot(H, nabla_b)
            self.test(test_data)

    def update_bfgs(self, H, mini_batch):
        nabla_b = [np.zeros(b.shape) for b in self.biases]
        nabla_w = [np.zeros(w.shape) for w in self.weights]
        for x, y in mini_batch:
            delta_nabla_b, delta_nabla_w = self.backprop(x, y)
            nabla_b = [nb + dnb for nb, dnb in zip(nabla_b, delta_nabla_b)]
            nabla_w = [nw + dnw for nw, dnw in zip(nabla_w, delta_nabla_w)]
        gradient = np.concatenate((np.array(nabla_b).ravel(), np.array(nabla_w).ravel()))
        y = np.concatenate((np.array(nabla_b).ravel(), np.array(nabla_w).ravel()))
        s = y - gradient
        yTB = np.dot(y, H)
        yTBy = np.dot(yTB, y)
        Bs = np.dot(H, s)
        H += np.outer(y, y) / yTBy - np.outer(Bs, Bs) / np.dot(s, Bs)
        return H, nabla_b, nabla_w

    def test(self, test_data):
        n_test = len(test_data)
        s = 0
        for i in range(n_test):
            y_receivied = self.feedforward(test_data[i][0])
            y_true = vectorized_result(test_data[i][1])
            s += self.loss_function(y_true, y_receivied)
        s /= n_test
        self.loss.append(s)

    def get_loss(self, i):
        return self.loss[i]

    def recognize(self, test_example):
        return np.argmax(self.feedforward(test_example))


epochs = 10
eta = 0.1


training_data, validation_data, test_data = load_data_wrapper()

perceptron = MultilayerPerceptron([784, 8, 10], "gradient_descent", sigmoid, mse)

perceptron.train(training_data, epochs, 10, eta, test_data)

print(perceptron.weights)

plt.plot([i for i in range(epochs)], [perceptron.get_loss(i) for i in range(epochs)], label='Gradient descent', color='blue')
plt.xlabel('Epochs')
plt.ylabel('Loss')
plt.title('Loss and Epochs')
plt.legend()
plt.show()

print()
for i in range(5):
    print("Expected:", test_data[i][1])
    print("Receivied:", perceptron.recognize(test_data[i][0]))
    print()


# training_data, validation_data, test_data = load_data_wrapper()
#
# perceptron = MultilayerPerceptron([784, 8, 10], "fletcher_reeves", sigmoid, mse)
#
# perceptron.train(training_data, epochs, 10, eta, test_data)
#
# print(perceptron.weights)
#
# plt.plot([i for i in range(epochs)], [perceptron.get_loss(i) for i in range(epochs)], label='Fletcher-Reeves optimization', color='green')
# plt.xlabel('Epochs')
# plt.ylabel('Loss')
# plt.title('Loss and Epochs')
# plt.legend()
# plt.show()
#
# print()
# for i in range(5):
#     print("Expected:", test_data[i][1])
#     print("Receivied:", perceptron.recognize(test_data[i][0]))
#     print()
