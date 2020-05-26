#!/bin/bash -e
# Performs offline decoding that should give the same results as the real
# online decoding.

source ../../scripts/run-expt.sh "${0}"

module purge
module load kaldi

cd "${EXPT_SCRIPT_DIR}"

steps/nnet3/decode.sh --nj 8 --cmd "${DECODE_CMD}" \
  --online-ivector-dir "${IVECTOR_DIR}/devel" \
  --acwt 0.07 \
  "${MODEL_DIR}/graph-fullvocab" \
  "${EXPT_WORK_DIR}/data/devel" \
  "${MODEL_DIR}/decode-fullvocab-devel" |
  tee "${EXPT_SCRIPT_DIR}/decode.log"

steps/nnet3/decode.sh --nj 8 --cmd "${DECODE_CMD}" \
  --online-ivector-dir "${IVECTOR_DIR}/eval" \
  --acwt 0.07 \
  "${MODEL_DIR}/graph-fullvocab" \
  "${EXPT_WORK_DIR}/data/eval" \
  "${MODEL_DIR}/decode-fullvocab-eval" |
  tee --append "${EXPT_SCRIPT_DIR}/decode.log"