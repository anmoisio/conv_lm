#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

for test_set in devel eval
do
    cd "${PROJECT_DIR}/lattices/${test_set}/morph-${EXPT_PARAMS}"
    mkdir lats
    cp {1,2,3,4,5,6,7,8}/*.lat.gz lats
    cd lats
    for filename in *.lat.gz
    do 
        echo "${filename}" >> lattice-list
    done

    tar -cvzf "${PROJECT_DIR}/lattices/${test_set}/morph-${EXPT_PARAMS}.tar" .
    rm -r lats
done

