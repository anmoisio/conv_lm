#!/usr/bin/env python
import sys

filename = (sys.argv[1])

with open(filename, 'r', encoding='utf-8') as f:
    if filename[-4:] == '.ref':
        remove = 1
        print('removing utterance id')
    else:
        remove = 0
    content = ' '.join(' '.join(line.split()[remove:]) for line in f.read().splitlines())
    content = content.split(' ')
    freqs = {}
    for word in content:
        if word not in freqs:
            freqs[word] = 1
        else:
            freqs[word] += 1

sorted_freqs = {k: v for k, v in sorted(freqs.items(), reverse=True, key=lambda item: item[1])}

i = 1
for word, freq in sorted_freqs.items():
    print('{} {}\t\t{}'.format(i, word, freq))
    if i == 50: break
    i += 1