#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=4:00:00
#SBATCH --mem=3G

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/vocab-functions.sh"

module purge
module load Morfessor
module load srilm
# module load speech-scripts

segment_vocabulary
segment_data
