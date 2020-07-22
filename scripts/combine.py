#!/usr/bin/env python3
import sys

input_trn = sys.argv[1]
output_trn = sys.argv[2]

with open(input_trn, 'r', encoding='utf-8') as f:
    trn = f.read()

trn = trn.replace('+ +','')
trn = trn.replace('+ ',' ')
trn = trn.replace(' +',' ')
trn = trn.replace('+','')

new = []
for line in trn.splitlines():
    words = line.split()
    id = words[0]
    # new.append(' '.join(words[1:]) + ' ({})'.format(id))
    new.append(' '.join(words))

with open(output_trn, 'w', encoding='utf-8') as f:
    for line in new:
        f.write(line + '\n')
