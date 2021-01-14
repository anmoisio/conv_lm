#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

. ./path.sh
. ./cmd.sh

n=1000
lm_scale=12

am_path=/scratch/work/moisioa3/keskustelu2020/experiments/am/converse_fin
am_dir=${am_path}/exp/chain
am=tdnn7q_sp_ensemble2

ngram=_morph_nosp_4-gram
lang_dir=${am_path}/data/lang_test${ngram}

nbest () {
    local test_set="${1}"
    "${PROJECT_DIR}"/kaldi-utensils/cutlery/get_nbest.sh \
        --cmd "${score_cmd}" \
        --num_best ${n} \
        --LMWT ${lm_scale} \
        "${lang_dir}" \
        rescored_lattices_${test_set}_${am}${ngram} \
        lstm_rescored_${n}best_${test_set}_${am}${ngram}
}

nbest devel
nbest eval