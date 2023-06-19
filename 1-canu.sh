#!/bin/bash

#SBATCH --account=emm2
#SBATCH --job-name=canu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --output=data/logs/canu_%J_%a.out
#SBATCH --error=data/logs/canu_%J_%a.err
#SBATCH --mem=250G
#SBATCH --array=1-4%4

module load canu/2.1.1

SAMPLE_PATH='/home/psegura/MassanaLab/assemblies/nanopore/data/raw/sample.txt/'
NAME=$( cat ${SAMPLE_PATH}/sample.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")
READS='data/raw'
OUT_DIR='data/raw/'

canu \
 -d ${OUT_DIR}/assembly_${SAMPLE}/ \
 -p ${NAME} \
 genomeSize=40m \
 -nanopore ${READS}/fastq_${SAMPLE}/*
