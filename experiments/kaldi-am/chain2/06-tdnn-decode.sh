#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

cd "${EXPT_SCRIPT_DIR}"


dir=exp/chain/tdnn
decode_set=devel

steps/nnet3/decode.sh --nj 8 --cmd "$decode_cmd" \
    --acwt 1.0 \
    --post-decode-acwt 10.0 \
    --online-ivector-dir ../chain/ivectors/${decode_set} \
    $dir/graph \
    ../mmi/data/${decode_set} \
    $dir/decode_${decode_set}