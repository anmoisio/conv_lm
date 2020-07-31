import sys

filename = (sys.argv[1])

with open(filename,'r', encoding='utf-8') as f:
    vocab = f.read()

    types = set()
    for i, line in enumerate(vocab.splitlines()):
        # print(line)
        # if i == 20: break

        subwords = line.split()
        for sw in subwords:
            types.add(sw)

print("{} word types".format(len(types)))
# print(types)