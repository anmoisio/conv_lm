#!/bin/bash -e

for file in segmented-data/web{1..6}.txt
do
    zcat "${file}".gz > "${file}"
done

zcat segmented-data/dsp.txt.gz > segmented-data/dsp.txt
zcat segmented-data/eval.txt.gz > segmented-data/eval.txt
zcat segmented-data/devel.txt.gz > segmented-data/devel.txt