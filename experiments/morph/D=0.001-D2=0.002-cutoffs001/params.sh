# variKN
declare -a TRAIN_FILES=("${PROJECT_DIR}/data/segmented-data/42k/dsp.txt" "${PROJECT_DIR}/data/segmented-data/42k/"web{1..6}.txt)
DEVEL_FILE="${PROJECT_DIR}/data/segmented-data/42k/devel.txt"
EVAL_FILE="${PROJECT_DIR}/data/segmented-data/42k/eval.txt"
VARIKN_DSCALE="0.001"
VARIKN_DSCALE2="0.002"

UTILS_DIR="${EXPT_SCRIPT_DIR}/utils"
LM="${EXPT_SCRIPT_DIR}/kn.arpa"

export PATH="${UTILS_DIR}:${PATH}"
export TRAIN_CMD="${UTILS_DIR}/slurm.pl --mem 3G --time 1:00:00"
export DECODE_CMD="${UTILS_DIR}/slurm.pl --mem 10G --time 1:00:00"
export MKGRAPH_CMD="${UTILS_DIR}/slurm.pl --mem 4G --time 1:00:00"
export BIG_MEMORY_CMD="${UTILS_DIR}/slurm.pl --mem 8G --time 1:00:00"