#!/bin/bash -e
# Performs offline decoding that should give the same results as the real
# online decoding.

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

# print Kaldi repo version for logging
echo 'Kaldi version:'
git --no-pager --git-dir=/scratch/work/moisioa3/conv_lm/kaldi/.git/ log -n 1
echo

cd "${EXPT_SCRIPT_DIR}"

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

steps/decode_fmllr.sh --nj 17 --cmd "$decode_cmd" \
    exp/tri3b_mmi_b0.1/graph_nosp \
    data/devel \
    exp/tri3b_mmi_b0.1/decode_nosp_devel || exit 1;

# steps/decode_fmllr.sh --nj 17 --cmd "$decode_cmd" \
#     exp/tri3b/graph_nosp \
#     data/eval \
#     exp/tri3b/decode_nosp_eval || exit 1;

