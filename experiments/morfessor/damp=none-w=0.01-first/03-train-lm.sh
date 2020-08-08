#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=0:30:00
#SBATCH --mem=9G

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/train-functions.sh"
source "${EXPT_SCRIPT_DIR}/params.sh"

module purge
module load variKN
module load anaconda3
module load srilm

train_varikn_ip
