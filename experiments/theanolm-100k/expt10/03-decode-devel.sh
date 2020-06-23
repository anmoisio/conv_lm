#!/bin/bash -e
#SBATCH --partition gpushort
#SBATCH --time=4:00:00
#SBATCH --mem=16G
#SBATCH --gres=gpu:1
#SBATCH --array=0-79

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"
source "${EXPT_SCRIPT_DIR}/params.sh"

module purge
module load speech-scripts
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
	declare -a DEVICES=(cuda0)
	RUN_GPU='srun --gres=gpu:1'
fi

decode_theanolm_devel
