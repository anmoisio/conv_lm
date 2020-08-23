#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

for test_set in eval
do
    for filename in /scratch/work/moisioa3/conv_lm/results/morph/D=0.001-D2=0.002-cutoffs001-n=5-lats-tpn=62-beam=650-order=22/${test_set}/lambda=???-lms=??.trn
    do
        echo combine segmented text in "${filename}" write to "${filename%.trn}"-combined.trn
        "${PROJECT_SCRIPT_DIR}"/combine.py --input-trn "${filename}" --output-trn "${filename%.trn}"-combined.trn
    done
done
