# variKN
declare -a TRAIN_FILES=("${EXPT_WORK_DIR}/segmented-data/dsp.txt" "${EXPT_WORK_DIR}"/segmented-data/web{1..6}.txt)
DEVEL_FILE="${EXPT_WORK_DIR}/segmented-data/devel.txt"
EVAL_FILE="${EXPT_WORK_DIR}/segmented-data/eval.txt"
VARIKN_DSCALE="0.01"
VARIKN_DSCALE2="0.005"

UTILS_DIR="${EXPT_SCRIPT_DIR}/utils"
LM="${EXPT_SCRIPT_DIR}/kn.arpa"

export PATH="${UTILS_DIR}:${PATH}"
export TRAIN_CMD="${UTILS_DIR}/slurm.pl --mem 3G --time 1:00:00"
export DECODE_CMD="${UTILS_DIR}/slurm.pl --mem 10G --time 1:00:00"
export MKGRAPH_CMD="${UTILS_DIR}/slurm.pl --mem 4G --time 1:00:00"
export BIG_MEMORY_CMD="${UTILS_DIR}/slurm.pl --mem 8G --time 1:00:00"