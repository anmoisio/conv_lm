#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

cd "${EXPT_SCRIPT_DIR}"

decode_sets="devel eval"

dir=exp/chain/tdnn7q_sp_noivec

for decode_set in $decode_sets; do
    steps/nnet3/decode.sh --nj 8 --cmd "$decode_cmd" \
        --acwt 1.0 \
        --post-decode-acwt 10.0 \
        $dir/graph \
        data/${decode_set}_hires \
        $dir/decode_${decode_set}
done