#!/bin/bash -e
# Just create alignments with the final model, for use in other experiments.

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load openfst

cd "${EXPT_SCRIPT_DIR}"

steps/align_fmllr.sh --nj 30 --cmd "${TRAIN_CMD}" \
  "${EXPT_WORK_DIR}/data/am-train" \
  "${EXPT_WORK_DIR}/lang/sp" \
  "${EXPT_WORK_DIR}/models/mmi" \
  "${EXPT_WORK_DIR}/align/mmi"
