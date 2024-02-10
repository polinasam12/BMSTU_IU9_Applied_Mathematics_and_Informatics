import copy
import sys

f = open("test1.txt", "r")
lines = f.readlines()
lines = list(map(lambda x: x.strip(), lines))
rules = []
terminals = []
nonterminals = []
for line in lines:
    if line != "":
        rule = []
        line = line.split("->")
        line = list(map(lambda x: x.strip(), line))
        rule.append(line[0])
        if line[0] not in nonterminals:
            nonterminals.append(line[0])
        s = line[1]
        i = 0
        if s == "":
            rule.append("")
        while i < len(s):
            if s[i] != "[":
                rule.append(s[i])
                if s[i] not in terminals:
                    terminals.append(s[i])
                i += 1
            else:
                rule.append(s[i: i + 3])
                if s[i: i + 3] not in nonterminals:
                    nonterminals.append(s[i: i + 3])
                i += 3
        rules.append(rule)
start_symbol = "[S]"
# print(nonterminals)
# print(terminals)
# print()

# print("Начальная грамматика")
# for rule in rules:
#     print(rule)
# print()

f = 0
for rule in rules:
    if not (rule[1] in terminals and (len(rule) == 2 or all([x in nonterminals for x in rule[2:]]))):
        f = 1
        break

if f == 0:
    print()
    print("Граматика уже находится в нормальной форме Грейбах")
    sys.exit()

def sort_rules():
    global rules
    start_symbol_rules = []
    not_start_symbol_rules = []
    for rule in rules:
        if rule[0] == start_symbol:
            start_symbol_rules.append(rule)
        else:
            not_start_symbol_rules.append(rule)
    not_start_symbol_rules.sort(key=lambda x: x[0])
    rules = start_symbol_rules + not_start_symbol_rules

def find_free_nonterminal_name():
    global nonterminals
    names = list(map(chr, range(65, 91))) + list(map(chr, range(97, 123)))
    for name in names:
        if "[" + name + "]" not in nonterminals:
            return "[" + name + "]"
    i = 0
    while True:
        for name in names:
            if "[" + name + str(i) + "]" not in nonterminals:
                return "[" + name + "]"
        i += 1

# If the start symbol S occurs on some right side, create a new start symbol S1 and a new Production S1 -> S
# f = 0
# for rule in rules:
#     if any([x == "[S]" for x in rule[1:]]):
#         f = 1
#         break
# if f == 1:
#     if "[S1]" not in nonterminals:
#         new_nonterminal = "[S1]"
#     else:
#         new_nonterminal = find_free_nonterminal_name()
#     rules.append([new_nonterminal, "[S]"])
#     nonterminals.append(new_nonterminal)
#     start_symbol = new_nonterminal
#
# print("После 1 шага")
# sort_rules()
# for rule in rules:
#     print(rule)
# print()


# Remove Null Productions

null_productions = []

while True:
    f = 0
    for rule in rules:
        if rule[1] == "" or all([x in null_productions for x in rule[1:]]):
            if rule[0] not in null_productions:
                null_productions.append(rule[0])
                f = 1
    if f == 0:
        break

if start_symbol in null_productions:
    if "[S0]" not in nonterminals:
        new_nonterminal = "[S0]"
    else:
        new_nonterminal = find_free_nonterminal_name()
    rules.append([new_nonterminal, start_symbol])
    rules.append([new_nonterminal, ""])
    nonterminals.append(new_nonterminal)
    start_symbol = new_nonterminal


def generate(n, prefix):
    global seq
    if n == 0:
        seq.append(prefix)
    else:
        generate(n - 1, prefix + "0")
        generate(n - 1, prefix + "1")


i = 0
l = len(rules)
if "[S]" in null_productions:
    l -= 2


while i < l:
    rule = rules[i]
    null_prod_indexes = []
    for j in range(len(rule[1:])):
        if rule[j + 1] in null_productions:
            null_prod_indexes.append(j + 1)
    i += 1
    if len(null_prod_indexes) != 0:
        seq = []
        generate(len(null_prod_indexes), "")
        seq = seq[:-1]
        for k in range(len(seq)):
            new_rule = [rule[0]]
            for q in range(len(rule[1:])):
                if rule[q + 1] not in null_productions or seq[k][null_prod_indexes.index(q + 1)] == "1":
                    new_rule.append(rule[q + 1])
            if len(new_rule) == 1:
                new_rule.append("")
            rules.append(new_rule)

i = 0
while i < len(rules):
    rule = rules[i]
    if rule[1] == "":
        del rules[i]
    else:
        i += 1

# print("После Remove Null Productions")
# sort_rules()
# for rule in rules:
#     print(rule)
# print()

# Remove Unit Productions

while True:
    i = 0
    f1 = 0
    l = len(rules)
    while i < l:
        rule = rules[i]
        if len(rule) == 2 and rule[0] == rule[1]:
            del rules[i]
            l -= 1
            f1 = 1
        elif len(rule) == 2 and rule[1] in nonterminals:
            for rule1 in rules:
                if rule1[0] == rule[1] and not (len(rule1) == 2 and rule1[0] == rule1[1]):
                    rules.append([rule[0]] + rule1[1:])
            del rules[i]
            l -= 1
            f1 = 1
        else:
            i += 1
    if f1 == 0:
        break

# print("После Remove Unit Productions")
# sort_rules()
# for rule in rules:
#     print(rule)
# print()

rules_without_unit_null = copy.deepcopy(rules)
nonterminals_without_unit_null = copy.deepcopy(nonterminals)
start_symbol_without_unit_null = start_symbol

# Replace each Production A -> B1..Bn where n > 2 with A -> B1C where C -> B2..Bn

while True:
    i = 0
    f1 = 0
    l = len(rules)
    while i < l:
        rule = rules[i]
        if len(rule) >= 4:
            new_nonterminal = find_free_nonterminal_name()
            rules.append([rule[0]] + [rule[1]] + [new_nonterminal])
            rules.append([new_nonterminal] + rule[2:])
            nonterminals.append(new_nonterminal)
            del rules[i]
            l -= 1
            f1 = 1
        else:
            i += 1
    if f1 == 0:
        break

# print("После Replace each Production A -> B1..Bn where n > 2 with A -> B1C where C -> B2..Bn")
# sort_rules()
# for rule in rules:
#     print(rule)
# print()

# If the right side of any Production is in the form A -> aB then the Production is replaced by A -> XB and X -> a

i = 0
l = len(rules)
while i < l:
    rule = rules[i]
    if len(rule) == 3 and rule[1] in terminals and rule[2] in nonterminals:
        new_nonterminal = find_free_nonterminal_name()
        rules.append([rule[0]] + [new_nonterminal] + [rule[2]])
        rules.append([new_nonterminal] + [rule[1]])
        nonterminals.append(new_nonterminal)
        del rules[i]
        l -= 1
    else:
        i += 1

# print("Грамматика в нормальной форме Хомского")
# sort_rules()
# for rule in rules:
#     print(rule)
# print()

order = []

renames = dict()
i = 1
new_nonterminals = []
for rule in rules:
    for term in rule:
        if term in nonterminals and term not in renames.keys():
            renames[term] = "[A" + str(i) + "]"
            new_nonterminals.append("[A" + str(i) + "]")
            order.append("[A" + str(i) + "]")
            renames["[A" + str(i) + "]"] = term
            if term == start_symbol:
                start_symbol = "[A" + str(i) + "]"
            i += 1

for i in range(len(rules)):
    for j in range(len(rules[i])):
        if rules[i][j] in nonterminals:
            rules[i][j] = renames[rules[i][j]]

nonterminals = new_nonterminals

# print("Грамматика после переименования")
# sort_rules()
# for rule in rules:
#     print(rule)
# print()

def get_int(str):
    r = ""
    for s in str:
        if s.isdigit():
            r += s
    return r

# Delete left recursion

new_nonterminals = []
for nonterm in nonterminals:
    while True:
        i = 0
        f1 = 0
        l = len(rules)
        while i < l:
            rule = rules[i]
            num1 = get_int(rule[0])
            num2 = get_int(rule[1])
            if rule[0] == nonterm and rule[1] in nonterminals and len(num1) > 0 and len(num2) > 0 and int(num1) > int(num2):
                for rule1 in rules:
                    if rule1[0] == rule[1]:
                        rules.append([rule[0]] + rule1[1:] + rule[2:])
                del rules[i]
                l -= 1
                f1 = 1
            else:
                i += 1
        if f1 == 0:
            break
    left_rec_rules = []
    not_left_rec_rules = []
    for rule in rules:
        if rule[0] == nonterm:
            if rule[1] in nonterminals and int(rule[0][2: -1]) == int(rule[1][2: -1]):
                left_rec_rules.append(rule)
            else:
                not_left_rec_rules.append(rule)
    if len(left_rec_rules) != 0:
        new_nonterminal = find_free_nonterminal_name()
        for rule in left_rec_rules:
            rules.append([new_nonterminal] + rule[2:] + [new_nonterminal])
            rules.append([new_nonterminal] + rule[2:])
        for rule in not_left_rec_rules:
            rules.append(rule + [new_nonterminal])
        new_nonterminals.append(new_nonterminal)
        order.insert(0, new_nonterminal)
        for rule in left_rec_rules:
            rules.remove(rule)

nonterminals = nonterminals + new_nonterminals

sort_rules()

# print("Грамматика после удаления левой рекурсии")
#
# for rule in rules:
#     print(rule)
# print()

while True:
    i = 0
    f1 = 0
    l = len(rules)
    while i < l:
        rule = rules[i]
        if rule[1] in nonterminals:
            for rule1 in rules:
                if rule1[0] == rule[1]:
                    rules.append([rule[0]] + rule1[1:] + rule[2:])
            del rules[i]
            l -= 1
            f1 = 1
        else:
            i += 1
    if f1 == 0:
        break

new_rules = []
for rule in rules:
    if rule not in new_rules:
        new_rules.append(rule)

rules = copy.deepcopy(new_rules)

attainable = [start_symbol]

while True:
    f = 0
    for rule in rules:
        if rule[0] in attainable:
            for term in rule[1:]:
                if term in nonterminals and term not in attainable:
                    attainable.append(term)
                    f = 1
    if f == 0:
        break

new_rules = []
for rule in rules:
    if rule[0] in attainable:
        new_rules.append(rule)

rules = copy.deepcopy(new_rules)

sort_rules()

print()
print("Грамматика после приведения к нормальной форме Грейбах методом устранения левой рекурсии")
print()
for rule in rules:
    print(rule[0], "->", end = " ")
    for term in rule[1:]:
        print(term, end = " ")
    print()
print()
print("Стартовый нетерминал -", start_symbol)
print("Порядок нетерминалов -", end = " ")
for o in order:
    print(o, end = " ")
print()
print()

rules = rules_without_unit_null
nonterminals = nonterminals_without_unit_null
start_symbol = start_symbol_without_unit_null

automat = dict()
new_nonterminals = []

for nonterm in nonterminals:
    automat[nonterm] = []

    attainable = [nonterm]
    while True:
        f = 0
        for rule in rules:
            if rule[0] in attainable and rule[1] in nonterminals and rule[1] not in attainable:
                attainable.append(rule[1])
                f = 1
        if f == 0:
            break

    for nt in attainable:
        if nt + nonterm[1:-1].lower() not in new_nonterminals:
            new_nonterminals.append("[" + nt[1:-1] + nonterm[1:-1].lower() + "]")

    for rule in rules:
        if rule[0] in attainable:
            if len(rule) >= 3 and rule[1] in nonterminals:
                automat[nonterm].append(["[" + rule[1][1:-1] + nonterm[1:-1].lower() + "]", rule[2:], "[" + rule[0][1:-1] + nonterm[1:-1].lower() + "]"])
            else:
                automat[nonterm].append(["[N" + nonterm[1:-1].lower() + "]", rule[1:], "[" + rule[0][1:-1] + nonterm[1:-1].lower() + "]"])

grammar = dict()

for nonterm in nonterminals:
    grammar[nonterm] = []
    for rule in automat[nonterm]:
        if rule[2] == "[" + nonterm[1:-1] + nonterm[1:-1].lower() + "]":
            grammar[nonterm].append([rule[0]] + rule[1])
        f = 0
        for rule1 in automat[nonterm]:
            if rule1[0] == nonterm[1:-1] + nonterm[1:-1].lower():
                f = 1
                break
        if rule[2] != nonterm[1:-1] + nonterm[1:-1].lower() or f == 1:
            grammar[nonterm].append([rule[0]] + rule[1] + [rule[2]])

rules = []

for key in grammar.keys():
    rules += grammar[key]

while True:
    f = 0
    i = 0
    l = len(rules)
    while i < l:

        if rules[i][1] in nonterminals:
            f = 1
            for rule1 in grammar[rules[i][1]]:
                if rule1[0] == "[N" + rules[i][1][1:-1].lower() + "]":
                    if len(rules[i]) >= 4:
                        rules.append([rules[i][0]] + rule1[1:] + rules[i][2:])
                    elif len(rules[i]) == 3:
                        rules.append([rules[i][0]] + rule1[1:] + [rules[i][2]])
                    else:
                        rules.append([rules[i][0]] + rule1[1:])
            del rules[i]
            l -= 1
        else:
            i += 1
    if f == 0:
        break


new_rules = []
for rule in rules:
    if len(rule) == 2:
        new_rules.append(rule)
    else:
        for i in range(2, len(rule)):
            if rule[i] in nonterminals:
                if len(rule[i + 1:]) >= 2:
                    rule = rule[:i] + ["[N" + rule[i][1:-1].lower() + "]"] + rule[i + 1:]
                elif len(rule[i + 1:]) == 1:
                    rule = rule[:i] + ["[N" + rule[i][1:-1].lower() + "]"] + [rule[i + 1]]
                else:
                    rule = rule[:i] + ["[N" + rule[i][1:-1].lower() + "]"]
            elif rule[i] in terminals:
                new_nonterminal = find_free_nonterminal_name()
                if len(rule[i + 1:]) >= 2:
                    rule = rule[:i] + [new_nonterminal] + rule[i + 1:]
                elif len(rule[i + 1:]) == 1:
                    rule = rule[:i] + [new_nonterminal] + [rule[i + 1]]
                else:
                    rule = rule[:i] + [new_nonterminal]
                new_rules.append([new_nonterminal, rule[i]])
        new_rules.append(rule)

start_symbol = "[N" + start_symbol[1:-1].lower() + "]"
rules = copy.deepcopy(new_rules)
attainable = [start_symbol]
nonterminals = new_nonterminals[:]

while True:
    f = 0
    for rule in rules:
        if rule[0] in attainable:
            for term in rule[1:]:
                if term in nonterminals and term not in attainable:
                    attainable.append(term)
                    f = 1
    if f == 0:
        break

new_rules = []
for rule in rules:
    if rule[0] in attainable:
        new_rules.append(rule)

rules = copy.deepcopy(new_rules)

new_rules = []
for rule in rules:
    if rule not in new_rules:
        new_rules.append(rule)

rules = copy.deepcopy(new_rules)

print("Грамматика после приведения к нормальной форме Грейбах методом Блюма-Коха")
print()
for rule in rules:
    print(rule[0], "->", end = " ")
    for term in rule[1:]:
        print(term, end = " ")
    print()
print()
print("Стартовый нетерминал -", start_symbol)
print()

for nonterm in automat.keys():
    print("Автомат для нетерминала", nonterm)
    print()
    for rule in automat[nonterm]:
        print(rule[0], "->", end = " ")
        for term in rule[1]:
            print(term, end = " ")
        print("->", rule[2])
    print()