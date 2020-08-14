#!/bin/bash -e
#SBATCH --mem=4G
#SBATCH --time=00:10:00
export LC_ALL=C

utils/validate_lang.pl --skip-determinization-check lang/nosp
