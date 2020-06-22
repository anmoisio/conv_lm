#!/bin/bash -e
# Performs offline decoding that should give the same results as the real
# online decoding.

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla

cd "${EXPT_SCRIPT_DIR}"

steps/nnet3/decode.sh --nj 8 --cmd "${DECODE_CMD}" \
  --online-ivector-dir "${EXPT_WORK_DIR}/ivectors/devel" \
  --acwt 0.07 \
  "${EXPT_WORK_DIR}/models/tdnn/graph-baseline" \
  "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/devel" \
  "${EXPT_WORK_DIR}/models/tdnn/decode-devel" |
  tee "${EXPT_SCRIPT_DIR}/decode.log"

steps/nnet3/decode.sh --nj 8 --cmd "${DECODE_CMD}" \
  --online-ivector-dir "${EXPT_WORK_DIR}/ivectors/eval" \
  --acwt 0.07 \
  "${EXPT_WORK_DIR}/models/tdnn/graph-baseline" \
  "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/eval" \
  "${EXPT_WORK_DIR}/models/tdnn/decode-eval" |
  tee --append "${EXPT_SCRIPT_DIR}/decode.log"
