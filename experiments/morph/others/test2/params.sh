# morfessor
# MORFESSOR_DAMPENING=ones
# MORFESSOR_CORPUS_WEIGHT=0.05
# RANDOM_SEED="1"
# declare -a TRAIN_FILES=("${data_dir}/lm-train/dsp.txt" "${data_dir}"/lm-train/web{1..6}.txt)

# variKN
declare -a TRAIN_FILES=("${EXPT_WORK_DIR}/segmented-data/dsp.txt" "${EXPT_WORK_DIR}"/segmented-data/web{1..6}.txt)
DEVEL_FILE="${EXPT_WORK_DIR}/segmented-data/devel.txt"
EVAL_FILE="${EXPT_WORK_DIR}/segmented-data/eval.txt"
VARIKN_DSCALE="0.01"
