#!/bin/bash -e
# We need to build a small system just because we need the LDA+MLLT transform
# to train the diag-UBM on top of.
#
# doc: https://kaldi-asr.org/doc/transform.html

source ../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load openfst

cd "${EXPT_SCRIPT_DIR}"

# Train a small system just for its LDA+MLLT transform. We use --num-iters 13
# because after we get the transform (12th iter is the last), any further
# training is pointless.
steps/train_lda_mllt.sh --cmd "${TRAIN_CMD}" \
  --num-iters 13 \
  --realign-iters "" \
  --splice-opts "--left-context=3 --right-context=3" \
  5000 10000 \
  "${EXPT_WORK_DIR}/data/am-train" \
  "${TRAIN_LANG}" \
  "${ALIGNMENTS}" \
  "${PROJECT_DIR}/models/kaldi-mmi"

# universal background model
steps/online/nnet2/train_diag_ubm.sh --nj 10 --cmd "${TRAIN_CMD}" \
  --num-threads 16 \
  --num-frames 400000 \
  "${EXPT_WORK_DIR}/data/am-train" \
  256 \
  "${PROJECT_DIR}/models/kaldi-mmi" \
  "${EXPT_WORK_DIR}/models/diag-ubm"
