#!/bin/bash -e
#SBATCH --time=1-00
#SBATCH --mem=53G

source ../../../scripts/run-expt.sh "${0}"
cd "${EXPT_SCRIPT_DIR}"

module purge
module load kaldi-vanilla
module list

#options
recog_langs=data/recog_langs

utils/mkgraph.sh --self-loop-scale 1.0 \
    ${recog_langs}/dspweb_morph-42k \
    models/tdnn \
    graph