#!/bin/bash -e
#SBATCH --time=1-00
#SBATCH --mem=53G

#options
recog_langs=data/recog_langs
lm_dir=data/lm
nj=8
am=chain

module purge
module load kaldi-vanilla

utils/mkgraph.sh --self-loop-scale 1.0 \
    ${recog_langs}/dspweb_morph-42k \
    ${am} \
    graph