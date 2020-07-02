#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=4:00:00
#SBATCH --mem=3G
#SBATCH --dependency=afterok:54546824

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/vocab-functions.sh"

module purge
module load Morfessor
module load srilm
# module load speech-scripts

segment_vocabulary
segment_data

python3 count_types_corpus.py <(zcat segmented-data/dsp.txt.gz segmented-data/web.txt.gz)
