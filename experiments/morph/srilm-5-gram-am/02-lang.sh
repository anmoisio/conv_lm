#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=4:00:00
#SBATCH --mem=10G

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list 

utils/prepare_lang.sh \
  dict/baseline \
  "[oov]" \
  data/local/lang_tmp_nosp \
  data/lang_nosp
