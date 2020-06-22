#!/bin/bash -e
# Train tri2, which is LDA + MLLT, on 8k data.

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi

cd "${EXPT_SCRIPT_DIR}"

# Take a subset of 8000 utterances.
utils/subset_data_dir.sh \
  "${EXPT_WORK_DIR}/data/am-train" \
  8000 \
  "${EXPT_WORK_DIR}/data/am-train-8k"

steps/align_si.sh --nj 10 --cmd "${TRAIN_CMD}" \
  "${EXPT_WORK_DIR}/data/am-train-8k" \
  "${EXPT_WORK_DIR}/lang/nosp" \
  "${EXPT_WORK_DIR}/models/tri1" \
  "${EXPT_WORK_DIR}/align/tri1"

steps/train_lda_mllt.sh --cmd "${TRAIN_CMD}" \
  --splice-opts "--left-context=3 --right-context=3" \
  2500 15000 \
  "${EXPT_WORK_DIR}/data/am-train-8k" \
  "${EXPT_WORK_DIR}/lang/nosp" \
  "${EXPT_WORK_DIR}/align/tri1" \
  "${EXPT_WORK_DIR}/models/tri2"
