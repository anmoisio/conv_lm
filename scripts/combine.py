#!/usr/bin/env python3
import sys
import argparse

parser = argparse.ArgumentParser(description='PyTorch Transformer Language Model')
parser.add_argument('--input-trn', type=str,
                    help='path to the segmented transcript')
parser.add_argument('--output-trn', type=str,
                    help='path to the output file')
parser.add_argument('--no-space', action='store_true', 
                    help='no space in between ambiguous subword sequences')
args = parser.parse_args()

with open(args.input_trn, 'r', encoding='utf-8') as f:
    trn = f.read()

trn = trn.replace('+ +','')
if args.no_space:
    trn = trn.replace('+ ','')
    trn = trn.replace(' +','')
else:
    trn = trn.replace('+ ',' ')
    trn = trn.replace(' +',' ')

trn = trn.replace('+','')

new = []
for line in trn.splitlines():
    words = line.split()
    id = words[0]
    # new.append(' '.join(words[1:]) + ' ({})'.format(id))
    new.append(' '.join(words))

with open(args.output_trn, 'w', encoding='utf-8') as f:
    for line in new:
        f.write(line + '\n')
