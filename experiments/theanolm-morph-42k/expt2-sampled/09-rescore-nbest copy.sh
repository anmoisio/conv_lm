#!/bin/bash -e
#SBATCH --partition gpushort
#SBATCH --time=4:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=7G
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

export NBEST_FROM_LATTICES_N=50

rescore () {
	local test_set="${1}"

	local bolm_scale=10
	BASELINE_LATTICES="${PROJECT_DIR}/lattices/${test_set}/morph-srilm-5-gram/lattice-list"

	for nnlm_weight in 0.5 1.0
	do
		for nnlm_scale in {8..12}
		do
			rescore_theanolm "${nnlm_weight}" "${nnlm_scale}" "${bolm_scale}" "${test_set}"
		done
	done
}

rescore devel
# rescore eval
