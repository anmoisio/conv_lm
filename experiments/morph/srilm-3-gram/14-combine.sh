#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

for test_set in devel
do
    for filename in /scratch/work/moisioa3/conv_lm/results/morph/srilm-3-gram-lats-tpn=62-beam=650-order=22/${test_set}/lambda=???-lms={?,??}.trn
    do
        echo combine segmented text in "${filename}" write to "${filename%.trn}"-combined.trn
        "${PROJECT_SCRIPT_DIR}"/combine.py --input-trn "${filename}" --output-trn "${filename%.trn}"-combined.trn
    done
done
