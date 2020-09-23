#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla

cd "${EXPT_SCRIPT_DIR}"

#options
expt_dir=lm/data/lm/dspweb


decode () {
    local expt="${1}"
    for test_set in devel eval
    do
        steps/nnet3/decode.sh --nj 8 --cmd "${DECODE_CMD}" \
            --acwt 1.0 \
            --post-decode-acwt 10.0 \
            --online-ivector-dir "${EXPT_WORK_DIR}/ivectors/${test_set}" \
            ${expt_dir}/${expt}/graph \
            "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/${test_set}" \
            "${EXPT_WORK_DIR}/models/tdnn/decode-${test_set}-${expt}" 
    done
}

decode trigram
decode varikn