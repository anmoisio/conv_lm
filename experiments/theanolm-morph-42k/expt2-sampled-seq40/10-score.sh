#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

. ./cmd.sh
. ./path.sh

cd "${EXPT_SCRIPT_DIR}"

n=50
lm_scale=11

am_path=/scratch/work/moisioa3/keskustelu2020/experiments/am/converse_fin
am_dir=${am_path}/exp/chain
am=tdnn7q_sp_ensemble2

# ngram=_morph_nosp_4-gram
ngram=_word_fullvocab
lang_dir=${am_path}/data/lang_test${ngram}

# for test_set in eval
# do
#   for lmw in "1.0" "0.5"
#   do
#     local/score.sh \
#       --cmd "${decode_cmd}" \
#       /scratch/work/moisioa3/keskustelu2020/experiments/am/converse_fin/data/${test_set} \
#       "${lang_dir}" \
#       "decode_${test_set}_${am}_${n}best${ngram}/nnlm_weight_${lmw}"
#   done
# done

for test_set in devel eval
do
  local/score.sh \
    --cmd "${decode_cmd}" \
    /scratch/work/moisioa3/keskustelu2020/experiments/am/converse_fin/data/${test_set} \
    "${lang_dir}" \
    "rescored_lattices_${test_set}_${am}${ngram}_lms${lm_scale}"

done