#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=1-00
#SBATCH --mem=53G

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

utils/mkgraph.sh \
    --self-loop-scale 1.0 \
    ../chain_tdnn_enarvi_swbd7q/data/lang_train_nosp \
    exp/chain/tdnn \
    exp/chain/tdnn/graph || exit 1;
