#!/bin/bash -e
#SBATCH --time=1-00
#SBATCH --mem=53G

source ../../../scripts/run-expt.sh "${0}"
cd "${EXPT_SCRIPT_DIR}"

module purge
module load kaldi-vanilla
module list

#Begin options
iter=final
lm_dir=data/lm
nj=8
recog_langs=data/recog_langs
am=chain
dataset=devel
#End options

am=$1
timestamp=`date +%s`
dsname=$(basename $dataset)
extra=_$dsname


mkdir -p logs data/recog_langs 

common/recognize.sh --dataset $dataset \
    --iter $iter \
    --write-to ${write_opts} \
    ${am} \
    ${recog_langs}/${model_type}_${lm_type} \
    &>logs/recognize.d${dataset}.${timestamp}.out