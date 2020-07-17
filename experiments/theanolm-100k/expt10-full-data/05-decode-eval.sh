#!/bin/bash -e
#SBATCH --partition gpushort
#SBATCH --time=4:00:00
#SBATCH --mem=16G
#SBATCH --gres=gpu:1
#SBATCH --array=0-79


#--partition batch,coin
#--time=4:00:00
#--mem=20G
#--array=0-127

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
	# module load TheanoLM-develop
	# module load anaconda3 gcc
	# source activate /scratch/work/groszt1/envs/theanoLM
	# declare -a DEVICES=(cpu)


	module load cudnn
	module load libgpuarray
	# module load TheanoLM-develop

	module load anaconda3
	source activate /scratch/work/groszt1/envs/theanoLM
	declare -a DEVICES=(cuda0)
	RUN_GPU='srun --gres=gpu:1'
fi
module list
decode_theanolm 0.5 11 eval 128 "${SLURM_ARRAY_TASK_ID}"
decode_theanolm 0.5 12 eval 128 "${SLURM_ARRAY_TASK_ID}"

echo "decode-eval finished."
