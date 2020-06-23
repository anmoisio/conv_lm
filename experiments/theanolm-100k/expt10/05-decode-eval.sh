#!/bin/bash -e
#SBATCH --partition batch,coin
#SBATCH --time=4:00:00
#SBATCH --mem=20G
#SBATCH --array=0-127

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
	module load TheanoLM-develop
	declare -a DEVICES=(cpu)
fi

decode_theanolm 0.5 14 eval 128 "${SLURM_ARRAY_TASK_ID}"
decode_theanolm 1.0 13 eval 128 "${SLURM_ARRAY_TASK_ID}"

echo "decode-eval finished."
