#!/bin/bash -e
#SBATCH --time=1:30:00
#SBATCH --mem=8G

source ../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/train-functions.sh"

module purge
module load srilm
module load speech-scripts

train_kn_ip