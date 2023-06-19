#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=spades
#SBATCH --cpus-per-task=24
#SBATCH --ntasks-per-node=1
#SBATCH --output=data/logs/spades_%a.out
#SBATCH --error=data/logs/spades_%a.err 
#SBATCH --array=1-4%4

#================================================

##########VARIABLES#########

# Load modules

module load spades
SAMPLE_PATH='/home/psegura/MassanaLab/assemblies/illumina/data/raw/sample.txt/'
NAME=$( cat ${SAMPLE_PATH}/sample.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

mkdir -p data/clean/assembly/${SAMPLE}

# Path to files

DATA_DIR='data/clean/trimgalore'

OUT_DIR="data/clean/assembly/${SAMPLE}"

# Parameters

NUM_THREADS=24

###########SCRIPT########

spades.py \
 -1 ${DATA_DIR}/${SAMPLE}_R1_val_1.fq \
 -2 ${DATA_DIR}/${SAMPLE}_R2_val_2.fq \
 -t ${NUM_THREADS} \
 --sc \
 -k 21,33,55,77,99 \
 -o ${OUT_DIR}
