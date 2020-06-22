#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
# module load openfst

cd "${EXPT_SCRIPT_DIR}"

steps/nnet3/train_tdnn.sh \
  --stage 40 \
  --num-epochs 8 \
  --num-jobs-initial 2 \
  --num-jobs-final 14 \
  --splice-indexes "-4,-3,-2,-1,0,1,2,3,4  0  -2,2  0  -4,4 0" \
  --feat-type raw \
  --online-ivector-dir "${EXPT_WORK_DIR}/ivectors/am-train" \
  --cmvn-opts "--norm-means=false --norm-vars=false" \
  --initial-effective-lrate 0.005 \
  --final-effective-lrate 0.0005 \
  --cmd "${CUDA_CMD}" \
  --pnorm-input-dim 2000 \
  --pnorm-output-dim 250 \
  "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/am-train" \
  "${TRAIN_LANG}" \
  "${ALIGNMENTS}" \
  "${EXPT_WORK_DIR}/models/tdnn"
