#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"

for test_set in devel
do
	echo "${test_set}"
	collect_transcripts "${test_set}"
done
