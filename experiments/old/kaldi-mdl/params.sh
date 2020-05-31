#!/bin/bash -e
UTILS_DIR="${EXPT_SCRIPT_DIR}/utils"
MODEL_DIR="${PROJECT_DIR}/models/kaldi-tdnn"
IVECTOR_DIR="${PROJECT_DIR}/models/kaldi-ivectors"
ALIGNMENTS="${PROJECT_DIR}/models/mmi/align/mmi"
LM="${EXPT_WORK_DIR}/kn-ip.arpa.gz"
# LATTICES="tdnn-fullvocab-ip2"

export PATH="${UTILS_DIR}:${PATH}"
export TRAIN_CMD="${UTILS_DIR}/slurm.pl --mem 3G --time 1:00:00"
export DECODE_CMD="${UTILS_DIR}/slurm.pl --mem 8G --time 1:00:00"
# export CUDA_CMD="${UTILS_DIR}/slurm.pl --gpu 1 --mem 3G --time 1:00:00"
# export SCORE_CMD="${UTILS_DIR}/slurm.pl --mem 1G --time 1:00:00"