#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

cd "${EXPT_SCRIPT_DIR}"

steps/align_si.sh  --nj 10 --cmd "$train_cmd" \
  data/am-train \
  data/lang_nosp \
  exp/tri2b \
  exp/tri2b_ali  || exit 1; 

steps/train_sat.sh --cmd "$train_cmd" 4200 40000 \
  data/am-train \
  data/lang_nosp \
  exp/tri2b_ali \
  exp/tri3b || exit 1;
