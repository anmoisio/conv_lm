#!/bin/bash -e
# Train tri3, which is LDA + MLLT + SAT, with all the data.

source ../../scripts/run-expt.sh "${0}"

module purge
module load kaldi

cd "${EXPT_SCRIPT_DIR}"

steps/align_fmllr.sh --nj 20 --cmd "${TRAIN_CMD}" \
  "${EXPT_WORK_DIR}/data/am-train" \
  "${EXPT_WORK_DIR}/lang/nosp" \
  "${EXPT_WORK_DIR}/models/tri2" \
  "${EXPT_WORK_DIR}/align/tri2"

steps/train_sat.sh --cmd "${TRAIN_CMD}" \
  4200 40000 \
  "${EXPT_WORK_DIR}/data/am-train" \
  "${EXPT_WORK_DIR}/lang/nosp" \
  "${EXPT_WORK_DIR}/align/tri2" \
  "${EXPT_WORK_DIR}/models/tri3"
