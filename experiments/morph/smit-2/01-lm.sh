#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=01:00:00
#SBATCH --mem=8G

# source ../../../scripts/run-expt.sh "${0}"

module purge
module load phonetisaurus
module load kaldi-vanilla
# module load speech-scripts
module list

# cd "${EXPT_SCRIPT_DIR}"

common/process_lm.sh /scratch/work/moisioa3/conv_lm/experiments/morph/smit-2/lm/data/lm/dspweb/morph-42k/morph-42k-i0.7.arpa data