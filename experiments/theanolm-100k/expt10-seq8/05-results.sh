#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"
source ../../../scripts/score-functions.sh
 
for test_set in eval
do
	echo asd
	collect_transcripts "${test_set}"
done
