#!/bin/bash -e
#SBATCH --time=0:10:00
#SBATCH --mem=3G
#SBATCH --dependency=afterok:54547736

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"
source "${EXPT_SCRIPT_DIR}/params.sh"

module purge
module load speech-scripts
module load variKN

perplexity_kn_morph | tee "${EXPT_SCRIPT_DIR}/perplexity.log"
