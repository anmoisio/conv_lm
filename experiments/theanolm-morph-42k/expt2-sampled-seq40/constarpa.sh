#!/bin/bash -e
#SBATCH --mem=16G
#SBATCH --time=4:00:00

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

am_path=/scratch/work/moisioa3/keskustelu2020/experiments/am/converse_fin
# ngram=_morph_nosp_4-gram
ngram=_word_fullvocab
lang_dir=${am_path}/data/lang_test${ngram}
# lm=${am_path}/data/morph_lm_4-gram/kn-ip-dsp-web.arpa.gz
lm=/scratch/work/moisioa3/conv_lm/experiments/4gram/ip/kn-ip-dsp-web.arpa.gz

utils/build_const_arpa_lm.sh \
    ${lm} \
    $lang_dir \
    ${lang_dir}/lang_new