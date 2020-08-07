#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

for test_set in devel
do
    for filename in "${RESULTS_DIR}"/"${test_set}"/lats-lms={?,??}-order=5.trn
    do
        echo combine segmented text in "${filename}" write to "${filename%.trn}"-combined.trn
        "${PROJECT_SCRIPT_DIR}"/combine.py "${filename}" "${filename%.trn}"-combined.trn
    done
done
