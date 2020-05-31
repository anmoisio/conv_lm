#!/bin/bash -e
#SBATCH --time=4:00:00
#SBATCH --mem=8G

source ../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/train-functions.sh"

module purge
module load srilm

interpolate_kn /scratch/work/moisioa3/conv_lm/experiments/4gram-ip/kn-ip-dsp-web.arpa.gz /scratch/work/moisioa3/conv_lm/experiments/4gram-ip/dsp.arpa.gz /scratch/work/moisioa3/conv_lm/experiments/4gram-ip/web.arpa.gz