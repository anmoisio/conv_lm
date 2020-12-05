#!/bin/bash -e
#SBATCH --mem=16G
#SBATCH --time=4:00:00

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

lang=/scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/lang/train-nosp

utils/build_const_arpa_lm.sh \
    /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/kn-ip-dsp-web.arpa.gz \
    $lang \
    lang_new