#!/bin/bash -e
# Extracts iVectors on all the train data, which will be what we train the system on.

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load openfst

cd "${EXPT_SCRIPT_DIR}"

# Even though $nj is just 10, each job uses multiple processes and threads.
steps/online/nnet2/train_ivector_extractor.sh --nj 10 --cmd "${TRAIN_CMD}" \
  "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/am-train" \
  "${EXPT_WORK_DIR}/models/diag-ubm" \
  "${EXPT_WORK_DIR}/ivectors/extractor"

# Having a larger number of speakers is helpful for generalization, and to
# handle per-utterance decoding well (iVector starts at zero).
steps/online/nnet2/copy_data_dir.sh \
  --utts-per-spk-max 2 \
  "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/am-train" \
  "${EXPT_WORK_DIR}/data/am-train-2ups"

steps/online/nnet2/extract_ivectors_online.sh --nj 30 --cmd "${TRAIN_CMD}" \
  "${EXPT_WORK_DIR}/data/am-train-2ups" \
  "${EXPT_WORK_DIR}/ivectors/extractor" \
  "${EXPT_WORK_DIR}/ivectors/am-train"

steps/online/nnet2/extract_ivectors_online.sh --nj 8 --cmd "${TRAIN_CMD}" \
  "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/devel" \
  "${EXPT_WORK_DIR}/ivectors/extractor" \
  "${EXPT_WORK_DIR}/ivectors/devel"

steps/online/nnet2/extract_ivectors_online.sh --nj 8 --cmd "${TRAIN_CMD}" \
  "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/eval" \
  "${EXPT_WORK_DIR}/ivectors/extractor" \
  "${EXPT_WORK_DIR}/ivectors/eval"
