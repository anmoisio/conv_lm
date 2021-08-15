#!/bin/bash
#SBATCH --time=0:05:00
#SBATCH --mem-per-cpu=1G
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH --job-name=finetune-eg
#SBATCH --output=/scratch/work/moisioa3/conv_lm/finbert-finetune/slurm-output/%x-%j.out

module load cuDNN
module load anaconda
module list

python bert_finetune_eg_cls.py
