import sys
from copy import deepcopy


def make_term_list(term):
    global variables
    global constructors
    term_list = []
    i = 2
    while i < len(term) - 1:
        if term[i] in variables:
            term_list.append(term[i])
            i += 1
        elif term[i] in constructors:
            b = 1
            for j in range(i + 2, len(term) - 1):
                if term[j] == ")" and b == 1:
                    ind = j
                    break
                elif term[j] == "(":
                    b += 1
                elif term[j] == ")":
                    b -= 1
            term_list.append(term[i: ind + 1])
            i = j + 1
        else:
            i += 1
    return term_list


def KnuthBendix(orders, rules):
    global constructors
    for rule in rules:
        rule_left, rule_right = rule.split(" = ")
        if rule_left == rule_right:
            return
    if len(rules) == 0:
        print("Completed successfully")
        for pair in orders:
            print(pair[0], ">", pair[1])
        sys.exit()
    rules = deepcopy(rules)
    if orders_checking(orders):
        return
    rule = rules.pop()
    rule_left, rule_right = rule.split(" = ")
    if rule_left in rule_right:
        return
    # Condition 1
    if rule_right in rule_left:
        KnuthBendix(orders, rules)
    # Condition 2
    if rule_left[0] in constructors and rule_right[0] in constructors:
        rules1 = deepcopy(rules)
        for term in make_term_list(rule_left):
            rules1.add(term + " = " + rule_right)
            KnuthBendix(orders, rules1)
    # Condition 3
    if rule_left[0] != rule_right[0] and rule_left[0] in constructors and rule_right[0] in constructors:
        orders1, rules1 = deepcopy(orders), deepcopy(rules)
        orders1.add((rule_left[0], rule_right[0]))
        for term in make_term_list(rule_right):
            rules1.add(rule_left + " = " + term)
        KnuthBendix(orders1, rules1)
    # Condition 4
    global order
    if rule_left[0] == rule_right[0] and rule_left[0] in constructors and rule_right[0] in constructors:
        rules1 = deepcopy(rules)
        rule_left_term_list = make_term_list(rule_left)
        rule_right_term_list = make_term_list(rule_right)
        for term in rule_right_term_list:
            rules1.add(rule_left + " = " + term)
        if order == "anti-lexicographic":
            rule_left_term_list = rule_left_term_list[::-1]
            rule_right_term_list = rule_right_term_list[::-1]
        for i in range(min(len(rule_left_term_list), len(rule_right_term_list))):
            if rule_left_term_list[i] != rule_right_term_list[i]:
                rules1.add(rule_left_term_list[i] + " = " + rule_right_term_list[i])
                KnuthBendix(orders, rules1)
                break


def orders_checking(orders):
    graph = {}
    for pair in orders:
        if pair[0] in graph:
            graph[pair[0]].append(pair[1])
        else:
            graph[pair[0]] = [pair[1]]
        if pair[1] not in graph:
            graph[pair[1]] = []
    color = {}
    for v in graph.keys():
        color[v] = "white"
    for v in graph.keys():
        if dfs(v, color, graph):
            return True
    return False


def dfs(v, color, graph):
    color[v] = "grey"
    for u in graph.get(v, []):
        if color[u] == "white":
            if dfs(u, color, graph):
                return True
        if color[u] == "grey":
            return True
    color[v] = "black"


f = open("test10.txt", 'r')
lines = f.readlines()
f.close()
lines = list(map(lambda x: x.strip(), lines))
order = lines[0]
constructors = lines[1][lines[1].find("=") + 1:].split(",")
constructors = list(map(lambda x: x.strip(), constructors))
constructors = list(map(lambda x: x[0], constructors))
variables = lines[2][lines[2].find("=") + 1:].split(",")
variables = list(map(lambda x: x.strip(), variables))
rules = set(lines[3:])
orders = set()
KnuthBendix(orders, rules)
print("Didn't complete")