#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=polish
#SBATCH --cpus-per-task=24
#SBATCH --ntasks-per-node=1
#SBATCH --output=data/logs/npolish.out
#SBATCH --error=data/logs/npolish.err 
#SBATCH --mem=150G
#SBATCH --array=1-4%4
#================================================

##########VARIABLES#########

# Load modules

module load nextpolish/1.4.1
source activate 

# shortcuts

SAMPLE=$( cat /home/psegura/MassanaLab/assemblies/nanopore/data/raw/sample.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

###########SCRIPT###########

nextPolish data/raw/run_${SAMPLE}.cfg
