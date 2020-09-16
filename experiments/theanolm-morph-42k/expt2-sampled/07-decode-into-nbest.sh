#!/bin/bash -e
#SBATCH --time=4:00:00
#SBATCH --mem=12G
#SBATCH --gres=gpu:1
#SBATCH --array=0-7

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"
source "${EXPT_SCRIPT_DIR}/params.sh"

module purge
module load speech-scripts
module load srilm
module load cudnn
module load libgpuarray
module load anaconda3
source activate /scratch/work/groszt1/envs/theanoLM
declare -a DEVICES=(cuda0)
RUN_GPU='srun --gres=gpu:1'
module list


n=50
lm_scale=10

steps/lmrescore_theanolm_nbest.sh --cmd "${RUN_GPU}" \
    --N $n \
    --lm-scale $lm_scale \
    /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/lang/train-nosp \
    nnlm.h5 \
    /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/models/tdnn/decode-devel \
    decode_nbest
