#!/bin/bash -e
#SBATCH --time=4:00:00
#SBATCH --mem=8G
#SBATCH --dependency=afterok:55128628

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/train-functions.sh"

module purge
module load srilm

interpolate_kn  "${EXPT_WORK_DIR}/kn-ip-dsp-web.arpa.gz" \
                "${EXPT_WORK_DIR}/dsp.arpa.gz" "${EXPT_WORK_DIR}/web.arpa.gz"