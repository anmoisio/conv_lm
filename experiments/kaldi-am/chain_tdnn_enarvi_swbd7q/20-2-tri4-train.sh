#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

cd "${EXPT_SCRIPT_DIR}"

steps/align_fmllr.sh --nj 30 --cmd "$train_cmd" \
    data/train_nodup \
    data/lang \
    exp/tri3 \
    exp/tri3_ali_nodup

steps/train_sat.sh  --cmd "$train_cmd" \
    11500 200000 \
    data/train_nodup \
    data/lang \
    exp/tri3b_ali \
    exp/tri4b