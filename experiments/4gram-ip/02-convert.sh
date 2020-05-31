#!/bin/bash -e
#SBATCH --time=1:30:00
#SBATCH --mem=8G

module purge
module load srilm
module load AaltoASR
module load speech-scripts

source ../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/prune-functions.sh"

convert_kn kn-ip