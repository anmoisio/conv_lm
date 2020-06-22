#!/bin/bash -e

source ../../scripts/run-expt.sh "${0}"

module purge
module load kaldi

cd "${EXPT_SCRIPT_DIR}"

# steps/decode_fmllr.sh --nj 17 --cmd "${DECODE_CMD}" \
#   "${EXPT_WORK_DIR}/models/mmi-nosp/graph-train-nosp2" \
#   "${EXPT_WORK_DIR}/data/devel" \
#   "${EXPT_WORK_DIR}/models/mmi-nosp/decode-devel-nosp2"

steps/decode_fmllr.sh --nj 17 --cmd "${DECODE_CMD}" \
  "${EXPT_WORK_DIR}/models/mmi-nosp/graph-train-nosp2" \
  "${EXPT_WORK_DIR}/data/eval" \
  "${EXPT_WORK_DIR}/models/mmi-nosp/decode-eval-nosp2"
