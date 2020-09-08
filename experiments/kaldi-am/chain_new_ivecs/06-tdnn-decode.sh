#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

cd "${EXPT_SCRIPT_DIR}"

decode_sets="devel eval"

dir=exp/chain/tdnn_new

for decode_set in $decode_sets; do
    steps/nnet3/decode.sh --nj 8 --cmd "$decode_cmd" \
        --acwt 1.0 \
        --post-decode-acwt 10.0 \
        --online-ivector-dir exp/nnet3/ivectors_${decode_set}_hires \
        $dir/graph \
        ../mmi/data/${decode_set} \
        $dir/decode_${decode_set}
done