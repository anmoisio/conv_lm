#!/bin/bash -e
#SBATCH --partition gpushort
#SBATCH --time=0:05:00
#SBATCH --mem=3G
#SBATCH --gres=gpu:1

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"

if [[ "$(uname -n)" = t40511* ]]
then
	module load Theano
	export PYTHONPATH="${PYTHONPATH}:${HOME}/git/theanolm"
	export PATH="${PATH}:${HOME}/git/theanolm/bin"
else
	module purge
	module load CUDA
	module load cudnn
	module load TheanoLM-develop
fi

module list
perplexity_theanolm
