#!/bin/bash -e
#SBATCH --partition gpu
#SBATCH --time=15-00
#SBATCH --gres=gpu:teslak80:1
#SBATCH --mem=24G

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/train-functions.sh"
source "${EXPT_SCRIPT_DIR}/params.sh"

module purge
module load srilm

if [[ "$(uname -n)" = t40511* ]]
then
	module load Theano
	export PYTHONPATH="${PYTHONPATH}:${HOME}/git/theanolm"
	export PATH="${PATH}:${HOME}/git/theanolm/bin"
else
	module load CUDA
	module load cudnn
	module load libgpuarray
	module load TheanoLM-develop
	RUN_GPU='srun --gres=gpu:1'
fi

export OMP_NUM_THREADS=1

train_theanolm
