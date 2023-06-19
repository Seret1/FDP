#!/bin/bash


#SBATCH --account=emm2
#SBATCH --job-name=eggnog
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --output=data/logs/eggnog_%a.out
#SBATCH --error=data/logs/eggnog_%a.err
#SBATCH --array=1-4%4


module load perl

module load eggnog-mapper/2.1.2

source activate eggnog-mapper/2.1.2

ORGANISMS_FILE='/home/psegura/MassanaLab/assemblies/gene_finding/data/raw'

ORGANISM=$( cat ${ORGANISMS_FILE}/sample.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

DATA_DIR="/mnt/lustre/repos/bio/projects/MassanaLab/assemblies/gene_finding/data/clean/${ORGANISM}"

PEPTIDES="${DATA_DIR}/${ORGANISM}_prot.faa" 

OUT_DIR=${DATA_DIR}/${ORGANISM}_eggnog_hmmer

THREADS=24

mkdir -p ${OUT_DIR}

emapper.py \
 -i ${PEPTIDES} \
 --output ${ORGANISM} \
 --output_dir ${OUT_DIR} \
 --itype proteins \
 --cpu ${THREADS} \
 --no_file_comments \
 -m hmmer \
 -d /mnt/lustre/repos/bio/databases/public/eggNOG/eggNOG_v4.5/NOG.hmm
