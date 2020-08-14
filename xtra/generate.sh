#!/bin/bash -e
#SBATCH --mem=18G
#SBATCH --time=0:30:00
#SBATCH --gres=gpu:1

. ./path.sh
module list
export PYTHONIOENCODING='utf-8'

python3 generate.py --cuda --data web-dsp --outf gener.txt --checkpoint /scratch/work/moisioa3/conv_lm/transformer-xl/pytorch/LM-TFM-wdtrain/20200806-163347/model.pt