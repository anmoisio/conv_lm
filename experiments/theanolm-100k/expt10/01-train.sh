#!/bin/bash -e
#SBATCH --partition gpu
#SBATCH --time=5-00
#SBATCH --gres=gpu:1
#SBATCH --mem=16G

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/train-functions.sh"

module purge

if [[ "$(uname -n)" = t40511* ]]
then
	module load Theano
	export PYTHONPATH="${PYTHONPATH}:${HOME}/git/theanolm"
	export PATH="${PATH}:${HOME}/git/theanolm/bin"
else
	# module load CUDA
	# module load cudnn
	# module load TheanoLM-develop
	# module load Theano/2017.03.28-0c53fb5

	module load anaconda3 srilm cudnn
	source activate /scratch/work/groszt1/envs/theanoLM

	declare -a DEVICES=(gpu)
	RUN_GPU='srun --gres=gpu:1'
fi

module list
train_theanolm
