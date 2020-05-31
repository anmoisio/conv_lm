#!/bin/bash -e

source ../../scripts/run-expt.sh "${0}"

module purge
module load kaldi

cd "${EXPT_SCRIPT_DIR}"

steps/decode.sh --nj 17 --cmd "${DECODE_CMD}" \
  "${EXPT_WORK_DIR}/models/tri1/graph-train-nosp" \
  "${EXPT_WORK_DIR}/data/devel" \
  "${EXPT_WORK_DIR}/models/tri1/decode-devel"

steps/decode.sh --nj 17 --cmd "${DECODE_CMD}" \
  "${EXPT_WORK_DIR}/models/tri1/graph-train-nosp" \
  "${EXPT_WORK_DIR}/data/eval" \
  "${EXPT_WORK_DIR}/models/tri1/decode-eval"
