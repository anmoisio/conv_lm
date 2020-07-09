#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=2:00:00
#SBATCH --mem=3G
#SBATCH --dependency=afterok:54657903

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/vocab-functions.sh"

data_dir="${WORK_DIR}/conv_lm/data"
DEVEL_FILE="${data_dir}/devel/plain.txt"
EVAL_FILE="${data_dir}/eval/plain.txt"

module purge
module load Morfessor
module load srilm
# module load speech-scripts
module list

segment_vocabulary
segment_data
