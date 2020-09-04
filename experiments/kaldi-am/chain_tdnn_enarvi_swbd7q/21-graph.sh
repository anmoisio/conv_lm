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

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.

utils/mkgraph.sh \
    data/lang_train_nosp \
    exp/tri3b_mmi_b0.1 \
    exp/tri3b_mmi_b0.1/graph_nosp