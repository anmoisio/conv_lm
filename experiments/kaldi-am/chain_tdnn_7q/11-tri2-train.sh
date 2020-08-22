#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

cd "${EXPT_SCRIPT_DIR}"

# Take a subset of 8000 utterances.
utils/subset_data_dir.sh \
  data/am-train \
  8000 \
  data/am-train-8k

steps/align_si.sh --nj 10 --cmd "$train_cmd" \
  data/am-train-8k \
  data/lang_nosp \
  exp/tri1 \
  exp/tri1_ali || exit 1;

steps/train_lda_mllt.sh --cmd "$train_cmd" \
  --splice-opts "--left-context=3 --right-context=3" 2500 15000 \
  data/am-train-8k \
  data/lang_nosp \
  exp/tri1_ali \
  exp/tri2b || exit 1;


