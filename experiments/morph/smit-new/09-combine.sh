#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

for test_set in devel
do
    for filename in ${RESULTS_DIR}/${test_set}/*[0-9].trn
    do
        echo combine segmented text in "${filename}" write to "${filename%.trn}"-combined.trn
        "${PROJECT_SCRIPT_DIR}"/combine.py --input-trn "${filename}" --output-trn "${filename%.trn}"-combined.trn
    done
done
