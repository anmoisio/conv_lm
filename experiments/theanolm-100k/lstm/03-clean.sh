#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

set -x
rm -rf "${EXPT_WORK_DIR}/rescore"
