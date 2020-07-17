#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"
 
for test_set in devel eval
do
	collect_transcripts "${test_set}"
done
