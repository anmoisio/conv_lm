#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=01:00:00
#SBATCH --mem=8G

source ../../../scripts/run-expt.sh "${0}"
cd "${EXPT_SCRIPT_DIR}"

module purge
module load kaldi-vanilla
module list

expt=varikn

"${EXPT_SCRIPT_DIR}"/common/process_lm.sh \
    "${EXPT_SCRIPT_DIR}"/lm/data/lm/dspweb/${expt}/kn.arpa \
    "${EXPT_SCRIPT_DIR}"/lm/data/lm/dspweb/${expt}