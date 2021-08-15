#!/bin/bash
#SBATCH --time=0:30:00
#SBATCH --job-name=finetunefinbert
#SBATCH --mem-per-cpu=8G
#SBATCH --cpus-per-task=1
#SBATCH --output=/scratch/work/moisioa3/conv_lm/finbert-finetune/slurm-output/%x-%j.out
# SBATCH --gres=gpu:1

# module load cuDNN
module load anaconda
module list

python3 train2.py