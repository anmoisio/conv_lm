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
RUN_GPU='srun --gres=gpu:1'
module load kaldi-vanilla
# module list


n=50
lm_scale=10

lang=/scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/lang/train-nosp


utils/build_const_arpa_lm.sh \
    data/local/lm/lm_tglarge.arpa.gz \
    $lang \
    data/lang_nosp_test_tglarge

"${PROJECT_SCRIPT_DIR}/lmrescore_theanolm.sh" --cmd "${RUN_GPU}" \
    --lm-scale $lm_scale \
    --beam $BEAM \
    --max-tokens-per-node $MAX_TOKENS_PER_NODE \
    --recombination-order $RECOMBINATION_ORDER \
    $lang \
    nnlm.h5 \
    /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/models/tdnn/decode-devel \
    decode_lats
