#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"
cd "${EXPT_SCRIPT_DIR}"

module purge
module load kaldi-vanilla
module list

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

# steps/decode_fmllr.sh --nj 17 --cmd "$decode_cmd" \
#     exp/tri3b/graph_nosp \
#     data/devel \
#     exp/tri3b/decode_nosp_devel || exit 1;

steps/decode_fmllr.sh --nj 17 --cmd "$decode_cmd" \
    exp/tri3b/graph_nosp \
    data/eval \
    exp/tri3b/decode_nosp_eval || exit 1;
