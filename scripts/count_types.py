#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys

# e.g.: 'python3 count_types.py <(zcat morfessor.segment.gz)'
filename = (sys.argv[1])

with open(filename,'r', encoding='utf-8') as f:
    vocab = f.read()

    types = set()
    for i, line in enumerate(vocab.splitlines()):
        # print(line)
        # if i == 20: break

        subwords = line.split()
        if len(subwords) < 2:
            types.add(subwords[0])
        else:
            new_sws = []
            for i, sw in enumerate(subwords):
                if i == 0:
                    new_sws.append('{}+'.format(sw))
                elif i < len(subwords) - 1:
                    new_sws.append('+{}+'.format(sw))
                else:
                    new_sws.append('+{}'.format(sw))

            for sw in new_sws:
                types.add(sw)

print("{} word types".format(len(types)))
# print(types)

types = list(types)
types.sort()
with open('subword.vocab', 'w', encoding='utf-8') as f:
    for sw in types:
        f.write(sw)
        f.write('\n')
