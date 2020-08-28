#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=4:00:00
#SBATCH --mem=25G

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

utils/mkgraph.sh \
    data/lang_train_nosp \
    exp/tri4b \
    exp/tri4b/graph_nosp || exit 1;
