#!/bin/bash -e

UTILS_DIR="${EXPT_SCRIPT_DIR}/utils"
export PATH="${UTILS_DIR}:${PATH}"
export TRAIN_CMD="${UTILS_DIR}/slurm.pl --mem 3G --time 1:00:00"
export DECODE_CMD="${UTILS_DIR}/slurm.pl --mem 16G --time 1-00"