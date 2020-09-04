#!/bin/bash -e
#SBATCH --time=4:00:00
#SBATCH --mem=12G
#SBATCH --gres=gpu:1
#SBATCH --array=0-127

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"
source "${EXPT_SCRIPT_DIR}/params.sh"

module purge
module load speech-scripts
module load srilm
# module load CUDA
module load cudnn
module load libgpuarray
# module load TheanoLM-develop
module load anaconda3
source activate /scratch/work/groszt1/envs/theanoLM
declare -a DEVICES=(cuda0)
RUN_GPU='srun --gres=gpu:1'

decode () {
	local test_set="${1}"

	local num_batches="128"
	local batch_index="${SLURM_ARRAY_TASK_ID}"

	for nnlm_weight in 0.5 1.0
	do
		for lm_scale in 9 10
		do
			decode_theanolm "${nnlm_weight}" "${lm_scale}" \
			                "${test_set}" \
			                "${num_batches}" "${batch_index}"
		done
	done

	echo "decode ${test_set} finished."
}

module list

decode devel
# decode eval
