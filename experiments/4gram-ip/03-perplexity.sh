#!/bin/bash -e
#SBATCH --time=0:30:00
#SBATCH --mem=4G

source ../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"

module purge
module load speech-scripts
module load srilm

perplexity_kn kn-ip | tee "${EXPT_SCRIPT_DIR}/perplexity.log"