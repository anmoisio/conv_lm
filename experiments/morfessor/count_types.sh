#!/bin/bash -e
#SBATCH --time=00:10:00
#SBATCH --mem=4G
#SBATCH -o word-types-%j.txt

for corpusdir in ./*
do
    echo "${corpusdir}"
    python3 /scratch/work/moisioa3/conv_lm/scripts/count_types.py <(zcat "${corpusdir}"/morfessor.segment.gz)
done