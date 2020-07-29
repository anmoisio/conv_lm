#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import io

input_stream = io.TextIOWrapper(sys.stdin.buffer, encoding='utf-8')
output_stream = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

m=sys.argv[1]
ma = {}
for line in input_stream:
  key = line.strip()
  val = key.lower()
  ma[key] = val
  output_stream.write("{}\n".format(val))

with open(m, 'w', encoding='utf-8') as f:
  for key, val in sorted(ma.items()):
    print("{}\t{}".format(key, val), file=f)
