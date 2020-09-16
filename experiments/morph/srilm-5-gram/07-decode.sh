#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla

cd "${EXPT_SCRIPT_DIR}"

steps/nnet3/decode.sh --nj 8 --cmd "${DECODE_CMD}" \
    --acwt 1.0 \
    --post-decode-acwt 10.0 \
    --beam 25 \
    --lattice-beam 15 \
    --online-ivector-dir "${EXPT_WORK_DIR}/ivectors/devel" \
    "${EXPT_WORK_DIR}/graph" \
    "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/devel" \
    "${EXPT_WORK_DIR}/models/tdnn/decode-devel-beam25-lbeam15" #|
    # tee "${EXPT_SCRIPT_DIR}/decode.log"

# steps/nnet3/decode.sh --nj 8 --cmd "${DECODE_CMD}" \
#     --acwt 1.0 \
#     --post-decode-acwt 10.0 \
#     --online-ivector-dir "${EXPT_WORK_DIR}/ivectors/eval" \
#     "${EXPT_WORK_DIR}/graph" \
#     "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/eval" \
#     "${EXPT_WORK_DIR}/models/tdnn/decode-eval" |
#     tee --append "${EXPT_SCRIPT_DIR}/decode.log"