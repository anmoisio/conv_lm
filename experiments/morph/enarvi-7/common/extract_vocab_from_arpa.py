#!/usr/bin/env python3

import sys
import io

input_stream = io.TextIOWrapper(sys.stdin.buffer, encoding='utf-8')
output_stream = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

in_1grams = False
for line in input_stream:
    if line.startswith('\\'):
        if not in_1grams and line.startswith("\\1-gram"):
            in_1grams = True
            continue
        if in_1grams:
            break
    if in_1grams:
        parts = line.split()
        if len(parts) >= 2 and len(parts[1].strip()) > 0:
            w = parts[1].strip()
            if w == '<s>':
                continue
            if w == '</s>':
                continue

            output_stream.write(parts[1].strip())
            output_stream.write('\n')
    
