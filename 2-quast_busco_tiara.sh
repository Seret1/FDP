#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=qbt
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --output=data/logs/qbt_%a.out
#SBATCH --error=data/logs/qbt_%a.err 
#SBATCH --array=1-4%4

#================================================

##########VARIABLES#########

mkdir -p data/clean/quast_busco_tiara/quast_c/
mkdir -p data/clean/quast_busco_tiara/busco_c/
mkdir -p data/clean/quast_busco_tiara/tiara_c/

# Path to files

DATA_DIR='data/raw/sample.txt'
SAMPLE=$(cat ${DATA_DIR} | awk "NR == ${SLURM_ARRAY_TASK_ID}")

BUSCO_db=/home/psegura/MassanaLab/assemblies/eukaryota_odb10

NUM_THREADS=6

# QUAST

module load quast

quast.py \
 --contig-thresholds 0,1000,3000,5000 \
 -o data/clean/quast_busco_tiara/quast_c/${SAMPLE} \
 -t ${NUM_THREADS} \
 /home/psegura/MassanaLab/assemblies/nanopore/data/raw/assembly/${SAMPLE}/${SAMPLE}.contigs.fasta # input

# BUSCO

cd data/clean/quast_busco_tiara/busco_c/

export AUGUSTUS_CONFIG_PATH="/home/psegura/MassanaLab/assemblies/data/augustus/config/"

module load busco/5.4.6
conda activate busco-5.4.6

busco -i /home/psegura/MassanaLab/assemblies/nanopore/data/raw/assembly/${SAMPLE}/${SAMPLE}.contigs.fasta\
 -o ${SAMPLE} \
 -l ${BUSCO_db} \
 -m geno

cd /home/psegura/MassanaLab/assemblies/nanopore 

# SPADES

module load tiara

tiara \
 -i data/raw/assembly/${SAMPLE}/${SAMPLE}.contigs.fasta \
 -o data/clean/quast_busco_tiara/tiara_c/${SAMPLE}

