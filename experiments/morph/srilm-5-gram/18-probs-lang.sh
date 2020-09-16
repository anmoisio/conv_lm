#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --mem=10G

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

cd "${EXPT_SCRIPT_DIR}"

utils/prepare_lang.sh \
    data/local/dict \
    "[oov]" \
    data/local/lang_tmp \
    data/lang || exit 1;