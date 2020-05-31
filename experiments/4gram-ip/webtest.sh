#!/bin/bash -e
#SBATCH --time=0:30:00
#SBATCH --mem=8G

source ../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"

module purge
module load srilm

ngram-count -order 4 -limit-vocab -interpolate1 -interpolate2 -interpolate3 -interpolate4 -interpolate5 -interpolate6 -gt4min 2 -gt5min 2 -gt6min 2 -text /scratch/work/moisioa3/conv_lm/data/lm-train/web.txt -lm /scratch/work/moisioa3/conv_lm/experiments/4gram-ip/web.arpa.gz -kndiscount1 -kndiscount2 -kndiscount3 -kndiscount4 -kndiscount5 -kndiscount6 -vocab <(cut -f1 /scratch/work/moisioa3/conv_lm/experiments/4gram-ip/word.vocab)