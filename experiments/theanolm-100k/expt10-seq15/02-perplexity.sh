#!/bin/bash -e
#SBATCH --partition coin,batch
#SBATCH --time=1:00:00
#SBATCH --mem=8G

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"

if [[ "$(uname -n)" = t40511* ]]
then
	module load Theano
	export PYTHONPATH="${PYTHONPATH}:${HOME}/git/theanolm"
	export PATH="${PATH}:${HOME}/git/theanolm/bin"
else
	module purge
	# module load TheanoLM-develop
	module load anaconda3 gcc
	source activate /scratch/work/groszt1/envs/theanoLM
	declare -a DEVICES=(cpu)
	RUN_GPU='srun --gres=gpu:1'
fi
module list
perplexity_theanolm
