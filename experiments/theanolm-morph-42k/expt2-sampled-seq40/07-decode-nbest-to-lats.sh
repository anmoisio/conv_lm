#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"
# source "${PROJECT_SCRIPT_DIR}/score-functions.sh"
source "${EXPT_SCRIPT_DIR}/params.sh"

module purge
module load speech-scripts
module load srilm
module load kaldi-vanilla
# module load cudnn
# module load libgpuarray
module load anaconda3
source activate /scratch/work/groszt1/envs/theanoLM
# declare -a DEVICES=(cuda0)
# RUN_GPU='srun --gres=gpu:1'
module list

# DECODE_CMD="utils/slurm.pl --mem 16G --time 1:00:00"

. ./path.sh
. ./cmd.sh

n=50
lm_scale=12

am_path=/scratch/work/moisioa3/keskustelu2020/experiments/am/converse_fin
am_dir=${am_path}/exp/chain
am=tdnn7q_sp_ensemble2

ngram=_morph_nosp_4-gram
lang_dir=${am_path}/data/lang_test${ngram}

for test_set in eval
do
    decode_dir=${am_dir}/${am}/decode_${test_set}${ngram}

    steps/lmrescore_theanolm_nbest.sh --cmd "${decode_cmd}" \
        --N $n \
        --lm-scale $lm_scale \
        "${lang_dir}" \
        nnlm.h5 \
        "${decode_dir}" \
        "decode_${test_set}_${am}_${n}best${ngram}"
done