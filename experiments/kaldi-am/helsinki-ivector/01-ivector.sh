#!/bin/bash -e
# Extracts iVectors on all the train data, which will be what we train the system on.

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla

cd "${EXPT_SCRIPT_DIR}"

# having a larger number of speakers is helpful for generalization, and to
# handle per-utterance decoding well (iVector starts at zero).
utils/data/modify_speaker_info.sh \
    --utts-per-spk-max 2 \
    /scratch/work/moisioa3/conv_lm/experiments/kaldi-am/helsinkiikuisesti/data \
    "${EXPT_WORK_DIR}/data/am-train-max2"

steps/online/nnet2/extract_ivectors_online.sh --cmd "${TRAIN_CMD}" --nj 1 \
    "${EXPT_WORK_DIR}/data/am-train-max2" \
    "${EXPT_WORK_DIR}/extractor" \
    "${EXPT_WORK_DIR}/ivectors"

