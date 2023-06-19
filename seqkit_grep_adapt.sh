#!/bin/sh
# SLURM HEADER
#############################################

# JOB INFO
#SBATCH --job-name=seqkit_grep
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --output=data/logs/seqkit_grep_adapt_%A_%a.out
#SBATCH --error=data/logs/seqkit_grep_adapt_%A_%a.err
#SBATCH --array=1-4%4

module load seqkit

SAMPLE=$( ls /home/psegura/MassanaLab/assemblies/nanopore/data/raw/assembly | awk "NR == ${SLURM_ARRAY_TASK_ID}" )
MISMATCHES=8
QUERY=data/raw/query_adapt.fasta

seqkit grep -s -v -m ${MISMATCHES} -f ${QUERY} /home/psegura/MassanaLab/assemblies/nanopore/data/raw/${SAMPLE}_reads_def_headers.fa -o /home/psegura/MassanaLab/assemblies/nanopore/data/raw/${SAMPLE}_reads_FINAL.fasta
