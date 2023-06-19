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

grep bacteria data/clean/quast_busco_tiara/tiara_c/contigs/${SAMPLE} | awk '{print $1}' > data/clean/to_remove/${SAMPLE}_to_remove.txt 
grep archaea data/clean/quast_busco_tiara/tiara_c/contigs/${SAMPLE} | awk '{print $1}' >> data/clean/to_remove/${SAMPLE}_to_remove.txt

module load seqkit

seqkit grep \
 -v data/clean/${SAMPLE}/${SAMPLE}.contigs.fasta \
 -f data/clean/to_remove/${SAMPLE}_to_remove.txt > data/clean/${SAMPLE}/${SAMPLE}.contigs.fasta

