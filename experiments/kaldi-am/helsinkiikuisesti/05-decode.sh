#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla

cd "${EXPT_SCRIPT_DIR}"

steps/nnet3/decode.sh --nj 1 --cmd "${DECODE_CMD}" \
    --acwt 1.0 \
    --post-decode-acwt 10.0 \
    --online-ivector-dir "${EXPT_WORK_DIR}/../helsinki-ivector/ivectors" \
    "${EXPT_WORK_DIR}/../chain/models/tdnn/graph" \
    "${EXPT_WORK_DIR}/data" \
    "${EXPT_WORK_DIR}/models/chain/decode" |
    tee "${EXPT_SCRIPT_DIR}/decode.log"