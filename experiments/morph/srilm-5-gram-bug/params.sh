#!/bin/bash -e

declare -a TRAIN_FILES=(
	"${PROJECT_DIR}/data/segmented/42k/dsp.txt"
	"${PROJECT_DIR}/data/segmented/42k/web.txt")

UTILS_DIR="${EXPT_SCRIPT_DIR}/utils"
LM="${EXPT_SCRIPT_DIR}/kn-ip-dsp-web.arpa"

export PATH="${UTILS_DIR}:${PATH}"
export TRAIN_CMD="${UTILS_DIR}/slurm.pl --mem 3G --time 1:00:00"
export DECODE_CMD="${UTILS_DIR}/slurm.pl --mem 10G --time 1:00:00"
export MKGRAPH_CMD="${UTILS_DIR}/slurm.pl --mem 4G --time 1:00:00"
export BIG_MEMORY_CMD="${UTILS_DIR}/slurm.pl --mem 8G --time 1:00:00"