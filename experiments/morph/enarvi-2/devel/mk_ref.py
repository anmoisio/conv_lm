#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys

segmented = sys.argv[1]
ref = sys.argv[2]

with open(segmented, 'r', encoding='utf-8') as f:
    segmented_lines = f.readlines()

with open(ref, 'r', encoding='utf-8') as f:
    ref_lines = f.readlines()

new_ref = []

assert (len(segmented_lines) == len(ref_lines))

ids = [line.split()[0] for line in ref_lines]

for i, id in enumerate(ids):
    new_ref.append(id + ' ' + segmented_lines[i].replace('<s> ', '').replace(' </s>', ''))

# print(new_ref[0])
# print(new_ref[1])
# print(new_ref[2])

with open('text', 'w', encoding='utf-8') as f:
    for line in new_ref:
        f.write(line)
