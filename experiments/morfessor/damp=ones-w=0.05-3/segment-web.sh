#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=2:00:00
#SBATCH --mem=3G

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/vocab-functions.sh"

module purge

segment_text "${PROJECT_DIR}/data/lm-train/web.txt" "${EXPT_WORK_DIR}/segmented-data/web.txt.gz"