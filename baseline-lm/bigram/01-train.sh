#!/bin/bash -e

source ../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/train-functions.sh"

module purge
module load srilm

train_kn
