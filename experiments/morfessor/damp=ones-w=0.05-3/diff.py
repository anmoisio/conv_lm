#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys

with open('subword.vocab', 'r', encoding='utf-8') as f:
    v1 = set(f.read().splitlines())

with open('vocab1', 'r', encoding='utf-8') as f:
    v2 = set(f.read().splitlines())

print(v1.difference(v2))