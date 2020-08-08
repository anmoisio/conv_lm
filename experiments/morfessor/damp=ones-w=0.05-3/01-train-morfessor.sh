#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=7:00:00
#SBATCH --mem=4G

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/vocab-functions.sh"

# params
MORFESSOR_DAMPENING=ones
MORFESSOR_CORPUS_WEIGHT=0.05
RANDOM_SEED="1"
data_dir="${WORK_DIR}/conv_lm/data"
declare -a TRAIN_FILES=("${data_dir}/lm-train/dsp.txt" "${data_dir}"/lm-train/web{1..6}.txt)

module purge
module load Morfessor
module load srilm
module list

train_morfessor
