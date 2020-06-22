#!/bin/bash -e
# Extracts iVectors on all the train data, which will be what we train the system on.

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla

cd "${EXPT_SCRIPT_DIR}"

# iVector extractors can be sensitive to the amount of data, but this one has a
# fairly small dim (defaults to 100) so we don't use all of it, we use just the
# 100k subset (just under half the data).
#
# With --nj 5 or 10 the training fails:
# (ERROR (ivector-extractor-sum-accs[5.5.433~1-7637d]:ExpectToken():io-funcs.cc:209) Expected token "<IvectorExtractorStats>", got instead "BLAS".)
steps/online/nnet2/train_ivector_extractor.sh --cmd "${TRAIN_CMD}" --nj 1 \
    "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/am-train" \
    "${EXPT_WORK_DIR}/../tdnn/models/diag-ubm" \
    "${EXPT_WORK_DIR}/ivectors/extractor"

# having a larger number of speakers is helpful for generalization, and to
# handle per-utterance decoding well (iVector starts at zero).
utils/data/modify_speaker_info.sh \
    --utts-per-spk-max 2 \
    "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/am-train" \
    "${EXPT_WORK_DIR}/data/am-train-max2"

steps/online/nnet2/extract_ivectors_online.sh --cmd "${TRAIN_CMD}" --nj 30 \
    "${EXPT_WORK_DIR}/data/am-train-max2" \
    "${EXPT_WORK_DIR}/ivectors/extractor" \
    "${EXPT_WORK_DIR}/ivectors/am-train"


for data_set in devel eval
do
    steps/online/nnet2/extract_ivectors_online.sh --cmd "${TRAIN_CMD}" --nj 8 \
        "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/${data_set}" \
        "${EXPT_WORK_DIR}/ivectors/extractor" \
        "${EXPT_WORK_DIR}/ivectors/${data_set}"
done
