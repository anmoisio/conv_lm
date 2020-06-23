#!/bin/bash -e
#SBATCH --partition gpushort
#SBATCH --time=4:00:00
#SBATCH --mem=8G
#SBATCH --gres=gpu:1
#SBATCH --array=0-63

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

decode () {
	local test_set="${1}"

	local num_batches="64"
	local batch_index="${SLURM_ARRAY_TASK_ID}"

	BASELINE_LATTICES="${PROJECT_DIR}/lattices/${test_set}/tdnn-baseline/lattice-list"

	for nnlm_weight in 0.5 0.75 1.0
	do
		for lm_scale in {12..15}
		do
			decode_theanolm "${nnlm_weight}" "${lm_scale}" \
			                "${test_set}" \
			                "${num_batches}" "${batch_index}"
		done
	done
}

decode devel
decode eval
