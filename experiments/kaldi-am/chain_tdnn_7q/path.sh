# export KALDI_ROOT=/scratch/work/moisioa3/conv_lm/kaldi
# [ -f $KALDI_ROOT/tools/env.sh ] && . $KALDI_ROOT/tools/env.sh
# export PATH=$PWD/utils/:$KALDI_ROOT/tools/openfst/bin:$PWD:$PATH
# [ ! -f $KALDI_ROOT/tools/config/common_path.sh ] && echo >&2 "The standard file $KALDI_ROOT/tools/config/common_path.sh is not present -> Exit!" && exit 1
# . $KALDI_ROOT/tools/config/common_path.sh
export LC_ALL=C
UTILS_DIR="/scratch/work/moisioa3/conv_lm/experiments/kaldi-am/chain_tdnn_7q/utils"
export PATH="${UTILS_DIR}:${PATH}"