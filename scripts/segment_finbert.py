#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import transformers
import torch

parser = argparse.ArgumentParser()
# parser.add_argument('input', type=str, nargs='+', help='text to be tokenized')
parser.add_argument('input', type=str, help='text to be tokenized')
parser.add_argument('output', type=str, help='output text path')
args = parser.parse_args()
# print(args.input, args.output)

model = transformers.BertForMaskedLM.from_pretrained("TurkuNLP/bert-base-finnish-cased-v1") 
model.eval()
if torch.cuda.is_available():
    model = model.cuda()
tokenizer = transformers.BertTokenizer.from_pretrained("TurkuNLP/bert-base-finnish-cased-v1")

with open(args.input, 'r', encoding='utf-8') as rf, open(args.output, 'a', encoding='utf-8') as wf:
    for line in rf.readlines():
        uttid = line.split()[0]
        utterance = ' '.join(line.split()[1:])
        wf.write(uttid + " " + " ".join(tokenizer.tokenize(utterance)).replace(" ##","+ +"))
        wf.write("\n")
        