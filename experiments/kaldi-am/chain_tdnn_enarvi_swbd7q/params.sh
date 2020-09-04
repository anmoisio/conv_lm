#!/bin/bash

export train_cmd="utils/slurm.pl --mem 3G --time 1:00:00"
export decode_cmd="utils/slurm.pl --mem 16G --time 1:00:00"

# export CUDA_CMD="utils/slurm.pl --gpu 1 --mem 3G --time 1:00:00"
# export SCORE_CMD="utils/slurm.pl --mem 1G --time 1:00:00"

export LC_ALL=C
UTILS_DIR=$PWD/utils/
export PATH="${UTILS_DIR}:${PATH}"