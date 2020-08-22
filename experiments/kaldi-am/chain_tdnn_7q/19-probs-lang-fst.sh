#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

cd "${EXPT_SCRIPT_DIR}"

mkdir -p data/lang_train
cp -r data/lang/* data/lang_train || exit 1;
rm -rf data/lang_train/tmp
cp data/lang_train_nosp/G.* data/lang_train/