#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load srilm

set -x

lattice-tool \
  -in-lattice-list "${PROJECT_DIR}/lattices/devel/tdnn-baseline/lattice-list" -read-htk \
  -ref-list "${PROJECT_DIR}/data/devel/verbatim.ref" |
  awk '{ subs += $2; ins += $4; del += $6; err += $8; words += $10 }
  END { print "sub", subs, "ins", ins, "del", del, "err", err, "words", words, "wer", err/words }' |
  tee "${EXPT_SCRIPT_DIR}/slf-error.log"

lattice-tool \
  -in-lattice-list "${PROJECT_DIR}/lattices/eval/tdnn-baseline/lattice-list" -read-htk \
  -ref-list "${PROJECT_DIR}/data/eval/verbatim.ref" |
  awk '{ subs += $2; ins += $4; del += $6; err += $8; words += $10 }
  END { print "sub", subs, "ins", ins, "del", del, "err", err, "words", words, "wer", err/words }' |
  tee --append "${EXPT_SCRIPT_DIR}/slf-error.log"
