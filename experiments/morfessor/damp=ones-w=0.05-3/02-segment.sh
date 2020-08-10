#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=4:00:00
#SBATCH --mem=3G

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/vocab-functions.sh"

MORFESSOR_DAMPENING=ones
MORFESSOR_CORPUS_WEIGHT=0.05
RANDOM_SEED="1"
data_dir="${WORK_DIR}/conv_lm/data"
declare -a TRAIN_FILES=("${data_dir}/lm-train/dsp.txt" "${data_dir}"/lm-train/web{1..6}.txt)
DEVEL_FILE="${data_dir}/devel/plain.txt"
EVAL_FILE="${data_dir}/eval/plain.txt"

module purge
module load Morfessor
module load srilm
# module load speech-scripts
module list

# segment_vocabulary
segment_data
