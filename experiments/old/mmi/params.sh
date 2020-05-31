UTILS_DIR="${EXPT_SCRIPT_DIR}/utils"
TRAIN_TRN="${PROJECT_DIR}/data/am-train/verbatim.trn"
BASELINE_LM="${PROJECT_DIR}/experiments/4gram-ip/kn-ip.arpa.gz"

export PATH="${UTILS_DIR}:${PATH}"
export TRAIN_CMD="${UTILS_DIR}/slurm.pl --mem 3G --time 1:00:00"
export DECODE_CMD="${UTILS_DIR}/slurm.pl --mem 10G --time 1:00:00"
export MKGRAPH_CMD="${UTILS_DIR}/slurm.pl --mem 4G --time 1:00:00"
export BIG_MEMORY_CMD="${UTILS_DIR}/slurm.pl --mem 8G --time 1:00:00"
