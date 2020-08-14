MORFESSOR_DAMPENING=none
MORFESSOR_CORPUS_WEIGHT=0.01

declare -a TRAIN_FILES=("${PROJECT_DIR}/data/segmented/dsp.txt" "${PROJECT_DIR}/data/segmented/web.txt")
DEVEL_FILE="${PROJECT_DIR}/data/segmented/devel.txt"
EVAL_FILE="${PROJECT_DIR}/data/segmented/eval.txt"
VARIKN_DSCALE="0.01"