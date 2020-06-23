#!/bin/bash -e
#SBATCH --partition coin,batch
#SBATCH --time=0:05:00
#SBATCH --mem=4G

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"

if [[ "$(uname -n)" = t40511* ]]
then
        module load Theano
        export PYTHONPATH="${PYTHONPATH}:${HOME}/git/theanolm"
        export PATH="${PATH}:${HOME}/git/theanolm/bin"
else
        module purge
	module load TheanoLM-develop
	declare -a DEVICES=(cpu)
	RUN_GPU='srun --gres=gpu:1'
fi

word_scores_theanolm
