#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi

cd "${EXPT_SCRIPT_DIR}"

# Make a subset with the shortest 2000 utterances.
utils/subset_data_dir.sh --shortest \
  "${EXPT_WORK_DIR}/data/am-train" \
  2000 \
  "${EXPT_WORK_DIR}/data/am-train-2kshort"

steps/train_mono.sh --nj 10 --cmd "${TRAIN_CMD}" \
  "${EXPT_WORK_DIR}/data/am-train-2kshort" \
  "${EXPT_WORK_DIR}/lang/nosp" \
  "${EXPT_WORK_DIR}/models/mono0"
