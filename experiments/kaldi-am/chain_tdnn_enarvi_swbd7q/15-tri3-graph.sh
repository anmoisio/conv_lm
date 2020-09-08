#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=4:00:00
#SBATCH --mem=25G

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

# print Kaldi repo version for logging
echo 'Kaldi version:'
git --no-pager --git-dir="${KALDI_ROOT}/.git/" log -n 1 --pretty=oneline 
echo

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

utils/mkgraph.sh \
    data/lang_train_nosp \
    exp/tri3b \
    exp/tri3b/graph_nosp || exit 1;
