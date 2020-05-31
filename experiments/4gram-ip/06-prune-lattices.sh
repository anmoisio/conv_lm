#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --array=0-49
#SBATCH --time=4:00:00
#SBATCH --mem=1G

source ../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"

module purge
module load speech-scripts
module load srilm

max_nodes=4000
prune_lattices devel "${max_nodes}" 50 "${SLURM_ARRAY_TASK_ID}"
prune_lattices eval "${max_nodes}" 50 "${SLURM_ARRAY_TASK_ID}"
