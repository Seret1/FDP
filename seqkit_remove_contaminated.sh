#!/bin/sh
# SLURM HEADER
#############################################

# JOB INFO
#SBATCH --job-name=seqkit_grep
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --output=nanopore/data/logs/seqkit_contaminated.out
#SBATCH --error=nanopore/data/logs/seqkit_contaminated.err
#SBATCH --array=1-4%4

module load seqkit

SAMPLE=$( ls /home/psegura/MassanaLab/assemblies/nanopore/data/raw/assembly | awk "NR == ${SLURM_ARRAY_TASK_ID}" )

awk '{print $1}' blast_comparisons/data/clean/blast_virus/${SAMPLE}_ONT_reads_VIRUS.best_hit.txt | sed 1d > blast_comparisons/data/raw/${SAMPLE}_contaminated_reads.txt

QUERY=blast_comparisons/data/raw/${SAMPLE}_contaminated_reads.txt

seqkit grep -v -f ${QUERY} /home/psegura/MassanaLab/assemblies/nanopore/data/raw/${SAMPLE}_reads_without_3k.fasta -o /home/psegura/MassanaLab/assemblies/nanopore/data/raw/${SAMPLE}_reads_no3k_noviral.fasta
