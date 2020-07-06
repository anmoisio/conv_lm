#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=7:00:00
#SBATCH --mem=4G

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/vocab-functions.sh"

module purge
module load Morfessor
module load srilm

train_morfessor
