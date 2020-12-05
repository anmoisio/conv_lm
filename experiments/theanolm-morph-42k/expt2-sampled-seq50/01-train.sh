#!/bin/bash -e
#SBATCH --partition gpu
#SBATCH --time=5-00
#SBATCH --gres=gpu:1
#SBATCH --mem=24G

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/train-functions.sh"

module purge
module load srilm
module load anaconda3 cudnn
source activate /scratch/work/groszt1/envs/theanoLM
RUN_GPU='srun --gres=gpu:1'
module list

export OMP_NUM_THREADS=1

module list 
train_theanolm
