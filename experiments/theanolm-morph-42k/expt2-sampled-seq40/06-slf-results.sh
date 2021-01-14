#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load sctk

# decode_params="tpn=62-beam=650-order=22"

# results () {
#     local test_set="${1}"
#     "${PROJECT_SCRIPT_DIR}"/score.sh ${test_set} \
#         ${PROJECT_DIR}/results/${EXPT_NAME}/${EXPT_PARAMS}-lats-${decode_params}/${test_set}/lambda=*-lms=*-combined.trn \
#         > results-${test_set}-combined-new.txt
# }

for test_set in eval
do
    # for dir in decode_devel_tdnn7q_sp_ensemble2_50best_morph_nosp_4-gram/nnlm_weight_*
    for dir in rescored_lattices_${test_set}_tdnn7q_sp_ensemble2_morph_nosp_4-gram
    do
        best_wer_file=$(awk '{print $NF}' $dir/scoring_kaldi/best_wer)
        best_wip=$(echo $best_wer_file | awk -F_ '{print $NF}')
        best_lmwt=$(echo $best_wer_file | awk -F_ '{N=NF-1; print $N}')

        filename=$dir/scoring_kaldi/penalty_$best_wip/$best_lmwt.txt

        echo combine segmented text in "${filename}" write to "${filename%.txt}"-combined.txt
        "${PROJECT_SCRIPT_DIR}"/combine.py --id2end --input-trn "${filename}" --output-trn "${filename%.txt}"-combined.trn
        
        "${PROJECT_SCRIPT_DIR}"/score.sh ${test_set} \
            "${filename%.txt}"-combined.trn \
            > ${dir}/scoring_kaldi/normalised-results.txt
    done
done
