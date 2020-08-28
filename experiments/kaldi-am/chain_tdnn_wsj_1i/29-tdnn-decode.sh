#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

cd "${EXPT_SCRIPT_DIR}"

test_sets="devel eval"

# training chunk-options
chunk_width=140,100,160

dir=exp/chain/tdnn_sp
tree_dir=exp/chain/tree_a_sp

frames_per_chunk=$(echo $chunk_width | cut -d, -f1)

for data in $test_sets; do
    nspk=$(wc -l <data/${data}_hires/spk2utt)
    steps/nnet3/decode.sh \
        --acwt 1.0 \
        --post-decode-acwt 10.0 \
        --extra-left-context 0 --extra-right-context 0 \
        --extra-left-context-initial 0 \
        --extra-right-context-final 0 \
        --frames-per-chunk $frames_per_chunk \
        --nj $nspk --cmd "$decode_cmd"  --num-threads 4 \
        --online-ivector-dir exp/nnet3/ivectors_${data}_hires \
        $tree_dir/graph \
        data/${data}_hires \
        ${dir}/decode_${data} || exit 1
done