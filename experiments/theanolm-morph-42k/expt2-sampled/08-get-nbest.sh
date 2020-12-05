#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

SCORE_CMD="utils/slurm.pl --mem 1G --time 1:00:00"

n=50

nbest () {
    local test_set="${1}"
    "${PROJECT_DIR}"/kaldi-utensils/cutlery/get_nbest.sh \
        --cmd "${SCORE_CMD}" \
        --num_best ${n} \
        /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/graph \
        decode_lats \
        "${PROJECT_DIR}/nbest/${test_set}/morph-5-gram-lstm-rescored-lats-to-${n}best"
}
# nbest devel
nbest eval