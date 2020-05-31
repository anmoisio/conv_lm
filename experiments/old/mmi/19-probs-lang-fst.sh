#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

mkdir -p "${EXPT_WORK_DIR}/lang/train"
cp -r "${EXPT_WORK_DIR}/lang/sp/"* "${EXPT_WORK_DIR}/lang/train/"
rm -rf "${EXPT_WORK_DIR}/lang/train.tmp"
cp "${EXPT_WORK_DIR}/lang/train-nosp/G."* "${EXPT_WORK_DIR}/lang/train/"
