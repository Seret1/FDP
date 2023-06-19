#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=grep_remove
#SBATCH --cpus-per-task=24
#SBATCH --ntasks-per-node=1
#SBATCH --output=data/logs/grep_remove.out
#SBATCH --error=data/logs/grep_remove.err
#SBATCH --array=1-4%4

#================================================
DATA_DIR='data/raw/sample.txt'
SAMPLE=$( cat ${DATA_DIR}| awk "NR == ${SLURM_ARRAY_TASK_ID}")

module load seqkit

seqkit seq -m 3001 /home/psegura/MassanaLab/assemblies/nanopore/data/raw/${SAMPLE}_raw_reads.fasta > data/raw/${SAMPLE}_reads_without_3k.fasta # create a new fasta with reads larger than 3000bp
