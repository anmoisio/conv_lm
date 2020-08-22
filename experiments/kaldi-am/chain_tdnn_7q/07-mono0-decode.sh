#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"
cd "${EXPT_SCRIPT_DIR}"

module purge
module load kaldi-vanilla
module list

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

steps/decode.sh --nj 10 --cmd "$decode_cmd" \
    exp/mono0a/graph_nosp \
    data/devel \
    exp/mono0a/decode_nosp_devel

steps/decode.sh --nj 8 --cmd "$decode_cmd" \
    exp/mono0a/graph_nosp \
    data/eval \
    exp/mono0a/decode_nosp_eval