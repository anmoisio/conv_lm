#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=4:00:00
#SBATCH --mem=40G

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

utils/mkgraph.sh \
    data/lang_train_nosp \
    exp/mono0a \
    exp/mono0a/graph_nosp
