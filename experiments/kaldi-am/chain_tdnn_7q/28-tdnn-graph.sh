#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=1-00
#SBATCH --mem=53G

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

# note: you don't necessarily have to change the treedir name
# each time you do a new experiment-- only if you change the
# configuration in a way that affects the tree.
tree_dir=exp/chain/tree_a_sp
lang=data/lang_chain

utils/lang/check_phones_compatible.sh \
    data/lang_train_nosp/phones.txt \
    $lang/phones.txt

utils/mkgraph.sh \
    --self-loop-scale 1.0 \
    data/lang_train_nosp \
    $tree_dir \
    $tree_dir/graph || exit 1;
