#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh


utils/mkgraph.sh \
    data/lang_nosp_test_tgpr \
    exp/tri1 \
    exp/tri1/graph_nosp_tgpr || exit 1;

