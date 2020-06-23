#!/bin/bash -e
#SBATCH --partition gpushort
#SBATCH --time=0:00:30
#SBATCH --cpus-per-task=1
#SBATCH --mem=3G
#SBATCH --gres=gpu:1

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"

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
	module load TheanoLM-develop
fi

rescore () {
	local test_set="${1}"

	local bolm_scale=15
	BASELINE_LATTICES="${PROJECT_DIR}/lattices/${test_set}/tdnn-baseline/lattice-list"

	for nnlm_weight in 0.5 0.75 1.0
	do
		for nnlm_scale in {12..18}
		do
			rescore_theanolm "${nnlm_weight}" "${nnlm_scale}" "${bolm_scale}" "${test_set}"
		done
	done
}

rescore devel
rescore eval
