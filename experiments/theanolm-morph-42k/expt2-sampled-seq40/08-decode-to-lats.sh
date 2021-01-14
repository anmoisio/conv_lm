#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"
source "${EXPT_SCRIPT_DIR}/params.sh"

# module purge
# module load speech-scripts
# module load srilm
# module load cudnn
# module load libgpuarray
# module load anaconda3
# source activate /scratch/work/groszt1/envs/theanoLM
# declare -a DEVICES=(cuda0)
# RUN_GPU='srun --gres=gpu:1'
# module load kaldi-vanilla
# module list

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
DECODE_CMD="utils/slurm.pl --mem 16G --time 3-00"

. ./cmd.sh
. ./path.sh

lm_scale=11

am_path=/scratch/work/moisioa3/keskustelu2020/experiments/am/converse_fin
am_dir=${am_path}/exp/chain
am=tdnn7q_sp_ensemble2

# ngram=_morph_nosp_4-gram
ngram=_word_fullvocab
lang_dir=${am_path}/data/lang_test${ngram}

# ls ${am_dir}/${am}/decode_devel${ngram}_nj30

steps2/lmrescore_theanolm.sh --cmd "${DECODE_CMD}" \
    --lm-scale $lm_scale \
    --beam $BEAM \
    --max-tokens-per-node $MAX_TOKENS_PER_NODE \
    --recombination-order $RECOMBINATION_ORDER \
    ${lang_dir}/lang_new \
    nnlm.h5 \
    ${am_dir}/${am}/decode_devel${ngram}_nj30 \
    rescored_lattices_devel_${am}${ngram}_lms${lm_scale}

steps2/lmrescore_theanolm.sh --cmd "${DECODE_CMD}" \
    --lm-scale $lm_scale \
    --beam $BEAM \
    --max-tokens-per-node $MAX_TOKENS_PER_NODE \
    --recombination-order $RECOMBINATION_ORDER \
    ${lang_dir}/lang_new \
    nnlm.h5 \
    ${am_dir}/${am}/decode_eval${ngram}_nj17 \
    rescored_lattices_eval_${am}${ngram}_lms${lm_scale}