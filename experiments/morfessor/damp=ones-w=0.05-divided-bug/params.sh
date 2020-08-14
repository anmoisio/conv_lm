MORFESSOR_DAMPENING=ones
MORFESSOR_CORPUS_WEIGHT=0.05

declare -a TRAIN_FILES=("${EXPT_WORK_DIR}/segmented-data/dsp.txt" "${EXPT_WORK_DIR}"/segmented-data/web{1..6}.txt)
DEVEL_FILE="${EXPT_WORK_DIR}/segmented-data/devel.txt"
EVAL_FILE="${EXPT_WORK_DIR}/segmented-data/eval.txt"
VARIKN_DSCALE="0.01"