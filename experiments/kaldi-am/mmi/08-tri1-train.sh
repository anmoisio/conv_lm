#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi

cd "${EXPT_SCRIPT_DIR}"

# Take a subset of 4000 utterances.
utils/subset_data_dir.sh \
  "${EXPT_WORK_DIR}/data/am-train" \
  4000 \
  "${EXPT_WORK_DIR}/data/am-train-4k"

steps/align_si.sh --nj 10 --cmd "${TRAIN_CMD}" \
  "${EXPT_WORK_DIR}/data/am-train-4k" \
  "${EXPT_WORK_DIR}/lang/nosp" \
  "${EXPT_WORK_DIR}/models/mono0" \
  "${EXPT_WORK_DIR}/align/mono0"

steps/train_deltas.sh --cmd "${TRAIN_CMD}" \
  2000 10000 \
  "${EXPT_WORK_DIR}/data/am-train-4k" \
  "${EXPT_WORK_DIR}/lang/nosp" \
  "${EXPT_WORK_DIR}/align/mono0" \
  "${EXPT_WORK_DIR}/models/tri1"
