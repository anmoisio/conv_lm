#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

cd "${EXPT_SCRIPT_DIR}"

# From 3b system, now using data/lang as the lang directory (we have now added
# pronunciation and silence probabilities), train another SAT system (tri4b).
steps/train_sat.sh --cmd "$train_cmd" 4200 40000 \
  data/am-train \
  data/lang \
  exp/tri3b \
  exp/tri4b || exit 1;
