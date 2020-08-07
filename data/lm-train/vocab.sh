#!/bin/bash

grep -o -E '\+*<*\w+\+*>*' web-dsp.txt | sort -u -f > web-dsp-vocab.txt