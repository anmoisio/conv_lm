#!/bin/bash -e
#SBATCH --time=1:00:00
#SBATCH --mem=3G
#SBATCH --dependency=afterok:54547613

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/prune-functions.sh"

module purge
module load srilm
module load AaltoASR
module load speech-scripts

convert_kn
