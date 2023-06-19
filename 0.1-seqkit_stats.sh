#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=seqkit
#SBATCH --cpus-per-task=24
#SBATCH --ntasks-per-node=1
#SBATCH --output=data/logs/seqkit_%J_%a.out
#SBATCH --error=data/logs/seqkit_%J_%a.err
#SBATCH --array=1-4%4

SAMPLE_PATH='/home/psegura/MassanaLab/assemblies/nanopore/data/raw/'
SAMPLE=$( cat ${SAMPLE_PATH}/sample.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

DATA=data/raw/assembly_${SAMPLE}/${SAMPLE}.contigs.fasta # change to your filepath
THREADS=24
OUT=data/clean/seqout_${SAMPLE}.txt

module load seqkit

seqkit stats \
  ${DATA} \
  -j ${THREADS} > ${OUT}
