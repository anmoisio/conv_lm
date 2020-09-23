#!/bin/bash -e
#SBATCH --time=1-00
#SBATCH --mem=53G

source ../../../scripts/run-expt.sh "${0}"
cd "${EXPT_SCRIPT_DIR}"

module purge
module load kaldi-vanilla
module list

#options
expt_dir=lm/data/lm/dspweb
expt=trigram

recog_langs=${expt_dir}/${expt}/recog_langs

utils/lang/check_phones_compatible.sh \
    data/lang/phones.txt \
    ${recog_langs}/dspweb_${expt}/phones.txt

utils/mkgraph.sh --self-loop-scale 1.0 \
    ${recog_langs}/dspweb_${expt} \
    models/tdnn \
    ${expt_dir}/${expt}/graph