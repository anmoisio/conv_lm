#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH --mem=4G

dot -Tps L.dot -o L.ps