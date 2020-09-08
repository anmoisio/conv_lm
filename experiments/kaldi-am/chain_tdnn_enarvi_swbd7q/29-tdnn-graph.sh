#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=1-00
#SBATCH --mem=53G

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

# print Kaldi repo version for logging
echo 'Kaldi version:'
git --no-pager --git-dir=/scratch/work/moisioa3/conv_lm/kaldi/.git/ log -n 1
echo

# note: you don't necessarily have to change the treedir name
# each time you do a new experiment-- only if you change the
# configuration in a way that affects the tree.
lang=data/lang_chain_nospeed

utils/lang/check_phones_compatible.sh \
    data/lang_train_nosp/phones.txt \
    $lang/phones.txt

utils/mkgraph.sh \
    --self-loop-scale 1.0 \
    data/lang_train_nosp \
    exp/chain/tdnn7q_noivec_nosp \
    exp/chain/tdnn7q_noivec_nosp/graph || exit 1;
