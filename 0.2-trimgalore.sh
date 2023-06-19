#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=trimgalore
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --output=data/logs/trimgalore_%J_%a.out
#SBATCH --error=data/logs/trimgalore_%J_%a.err
#SBATCH --array=1-4%4

# Load module

module load cutadapt

source activate cutadapt

module load fastqc 

# Variables

DATA_PATH="/home/psegura/MassanaLab/assemblies/corrected/data/raw"
OUT_DIR="data/clean/trimgalore"

SAMPLE=$( ls /home/psegura/MassanaLab/assemblies/nanopore/data/raw/assembly | awk "NR == ${SLURM_ARRAY_TASK_ID}")
THREADS=6

# Run trimgalore

/mnt/lustre/repos/bio/projects/MassanaLab/Programs/TrimGalore-0.6.6/trim_galore  \
  --paired ${DATA_PATH}/${SAMPLE}_R1.fq ${DATA_PATH}/${SAMPLE}_R2.fq -o ${OUT_DIR} \
  --length 75
