#!/bin/bash -e

CONFIG_DIR="${PROJECT_DIR}/configs"
data_dir="${WORK_DIR}/conv_lm/data"
declare -a TRAIN_FILES=("${data_dir}/lm-train/dsp.txt" "${data_dir}/lm-train/web.txt")
DEVEL_FILE="${data_dir}/devel/plain.txt"
EVAL_FILE="${data_dir}/eval/plain.txt"