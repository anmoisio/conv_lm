#!/bin/bash -e
# Train mmi, which is a discriminative MMI model.

source ../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load openfst

cd "${EXPT_SCRIPT_DIR}"

steps/align_fmllr.sh --nj 30 --cmd "${TRAIN_CMD}" \
  "${EXPT_WORK_DIR}/data/am-train" \
  "${EXPT_WORK_DIR}/lang/sp" \
  "${EXPT_WORK_DIR}/models/tri3" \
  "${EXPT_WORK_DIR}/align/tri3"

steps/make_denlats.sh --nj 30 --sub-split 30 --cmd "${TRAIN_CMD}" \
  --transform-dir "${EXPT_WORK_DIR}/align/tri3" \
  "${EXPT_WORK_DIR}/data/am-train" \
  "${EXPT_WORK_DIR}/lang/sp" \
  "${EXPT_WORK_DIR}/models/tri3" \
  "${EXPT_WORK_DIR}/denlats/tri3"

steps/train_mmi.sh --cmd "${TRAIN_CMD}" \
  --boost 0.1 \
  "${EXPT_WORK_DIR}/data/am-train" \
  "${EXPT_WORK_DIR}/lang/sp" \
  "${EXPT_WORK_DIR}/align/tri3" \
  "${EXPT_WORK_DIR}/denlats/tri3" \
  "${EXPT_WORK_DIR}/models/mmi3"
