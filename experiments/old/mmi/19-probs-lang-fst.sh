#!/bin/bash -e

source ../../scripts/run-expt.sh "${0}"

mkdir -p "${EXPT_WORK_DIR}/lang/train-test"
cp -r "${EXPT_WORK_DIR}/lang/sp-test/"* "${EXPT_WORK_DIR}/lang/train-test/"
rm -rf "${EXPT_WORK_DIR}/lang/train-test.tmp"
cp "${EXPT_WORK_DIR}/lang/train-nosp/G."* "${EXPT_WORK_DIR}/lang/train-test/"
