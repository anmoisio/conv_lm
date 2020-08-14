#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla

cd "${EXPT_SCRIPT_DIR}"

steps/nnet3/decode.sh --nj 2 --cmd "${DECODE_CMD}" \
    --acwt 1.0 \
    --post-decode-acwt 10.0 \
    --online-ivector-dir "${EXPT_WORK_DIR}/../movie-ivector/2movies" \
    "${EXPT_WORK_DIR}/../chain/models/tdnn/graph" \
    "${EXPT_WORK_DIR}/data_movies" \
    "${EXPT_WORK_DIR}/models/chain/decode" |
    tee "${EXPT_SCRIPT_DIR}/decode.log"
