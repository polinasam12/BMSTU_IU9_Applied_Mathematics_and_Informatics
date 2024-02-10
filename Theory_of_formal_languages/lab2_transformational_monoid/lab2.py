import re
import sys

f = open("test1.txt")
lines = f.readlines()
lines = list(map(lambda x: x.strip(), lines))
lines = list(map(lambda x: re.split("<|>|{|}|,|-| ", x), lines))
lines = list(filter(lambda x: x != "", lines))
for i in range(len(lines)):
    lines[i] = list(filter(lambda x: x != "", lines[i]))
start_state = lines[0][0]
final_states = lines[0][1: len(lines[0])]
transitions = lines[1: len(lines)]
states = []
alphabet = []
for state in lines[0]:
    if state not in states:
        states.append(state)
for transition in transitions:
    if transition[0] not in states:
        states.append(transition[0])
    if transition[2] not in states:
        states.append(transition[2])
    if transition[1] not in alphabet:
        alphabet.append(transition[1])
final_states.sort()
states.sort()
alphabet.sort()

states_indexes = dict()
alphabet_indexes = dict()

for i in range(len(states)):
    states_indexes[i] = states[i]
    states_indexes[states[i]] = i

for i in range(len(alphabet)):
    alphabet_indexes[i] = alphabet[i]
    alphabet_indexes[alphabet[i]] = i

dfa = [[0] * len(states) for i in range(len(alphabet))]
for i in range(len(alphabet)):
    for j in range(len(states)):
        dfa[i][j] = []

for transition in transitions:
    dfa[alphabet_indexes[transition[1]]][states_indexes[transition[0]]].append(states_indexes[transition[2]])

is_determ = True
for i in range(len(alphabet)):
    for j in range(len(states)):
        if len(dfa[i][j]) > 1:
            is_determ = False
if not is_determ:
    print("Автомат недетерминированный")
    sys.exit()

def dfs(dfa, v):
    global visited
    if v not in visited:
        visited.append(v)
        for i in range(len(alphabet)):
            if dfa[i][v] != []:
                for j in range(len(dfa[i][v])):
                    dfs(dfa, dfa[i][v][j])

visited = []
dfs(dfa, states_indexes[start_state])
states_without_remove = visited

dfa_reverse = [[0] * len(states) for i in range(len(alphabet))]
for i in range(len(alphabet)):
    for j in range(len(states)):
        dfa_reverse[i][j] = []

for transition in transitions:
    dfa_reverse[alphabet_indexes[transition[1]]][states_indexes[transition[2]]].append(states_indexes[transition[0]])

visited = []
for final_state in final_states:
    dfs(dfa_reverse, states_indexes[final_state])

states_without_remove = list(set(states_without_remove).intersection(set(visited)))

for i in range(len(alphabet)):
    for j in range(len(states)):
        if j in states_without_remove:
            if dfa[i][j] != [] and dfa[i][j][0] not in states_without_remove:
                dfa[i][j] = []
        else:
            dfa[i][j] = []

new_states = []
for state in states:
    if states_indexes[state] in states_without_remove:
        new_states.append(state)
states = new_states
states.sort()

equivalence_classes = []

for i in range(len(alphabet)):
    equivalence_classes.append([alphabet_indexes[i]])
    for j in range(len(dfa[0])):
        if dfa[i][j] != []:
            equivalence_classes[-1].append([states_indexes[j], states_indexes[dfa[i][j][0]]])

def generate(prefix, k):
    global alphabet
    global w_list
    if k == 0:
        w_list.append(prefix)
    else:
        for i in range(len(alphabet)):
            generate(prefix + alphabet[i], k - 1)

f = True
length = 2
rules = []
while f:
    f = False
    w_list = []
    generate("", length)
    for w in w_list:
        f1 = True
        w1 = w
        while f1:
            f1 = False
            for i in range(len(w1)):
                for j in range(i + 1, len(w1) + 1):
                    for rule in rules:
                        if w1[i: j] == rule[0]:
                            w1 = w1[:i] + rule[1] + w1[j:]
                            f1 = True
        if w == w1:
            conversions = []
            for i in range(len(dfa[0])):
                last_state = i
                for j in range(len(w)):
                    if dfa[alphabet_indexes[w[j]]][last_state] != []:
                        last_state = dfa[alphabet_indexes[w[j]]][last_state][0]
                    else:
                        last_state = ""
                        break
                if last_state != "":
                    conversions.append([states_indexes[i], states_indexes[last_state]])
            conversions.sort()
            f4 = False
            for equivalence in equivalence_classes:
                e = equivalence[1: len(equivalence)]
                e.sort()
                if conversions == e:
                    rules.append([w, equivalence[0]])
                    f4 = True
            if not f4:
                e = [w]
                for conversion in conversions:
                    e.append(conversion)
                equivalence_classes.append(e)
                f = True
    length += 1

print("Правила переписывания")
for rule in rules:
    print(rule[0], "->", rule[1])
print()
print("Классы эквивалентности")
for equivalence in equivalence_classes:
    print(equivalence[0], "=", equivalence[1: len(equivalence)])
print()

def recognized_by_automat(state, w):
    global dfa
    last_state = states_indexes[state]
    for l in w:
        if dfa[alphabet_indexes[l]][last_state] != []:
            last_state = dfa[alphabet_indexes[l]][last_state][0]
        else:
            return False
    if states_indexes[last_state] in final_states:
        return states_indexes[last_state]
    else:
        return False

def state_transition(state, w):
    global dfa
    last_state = states_indexes[state]
    for l in w:
        if dfa[alphabet_indexes[l]][last_state] != []:
            last_state = dfa[alphabet_indexes[l]][last_state][0]
        else:
            return False
    return states_indexes[last_state]

print("Классы эквивалентности, входящие в язык автомата")
for equivalence in equivalence_classes:
    if recognized_by_automat(start_state, equivalence[0]):
        print(equivalence[0])
print()
print("Информация о каждом классе")
print()
for equivalence in equivalence_classes:
    print("Класс w =", equivalence[0])
    print("Классы эквивалентности v, такие, что vw входит в язык автомата")
    for equivalence1 in equivalence_classes:
        if recognized_by_automat(start_state, equivalence1[0] + equivalence[0]):
            print(equivalence1[0])
    print("Классы эквивалентности v, такие, что wv входит в язык автомата")
    for equivalence2 in equivalence_classes:
        if recognized_by_automat(start_state, equivalence[0] + equivalence2[0]):
            print(equivalence2[0])
    print("Пары (v, u), такие, что vwu входит в язык автомата")
    for equivalence3 in equivalence_classes:
        for equivalence4 in equivalence_classes:
            if recognized_by_automat(start_state, equivalence3[0] + equivalence[0] + equivalence4[0]):
                print((equivalence3[0], equivalence4[0]))
    sync_state = state_transition(start_state, equivalence[0])
    if sync_state:
        f5 = True
        for state in states:
            sync_state1 = state_transition(state, equivalence[0])
            if sync_state != sync_state1:
                f5 = False
                break
        if f5:
            print("w синхронизирует A к", sync_state)
        else:
            print("w не синхронизирующее слово")
    else:
        print("w не синхронизирующее слово")
    print()