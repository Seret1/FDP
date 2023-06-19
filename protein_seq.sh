#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=samtools
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --array=1-4%4

# SHORTCUTS

SAMPLE=$( cat data/raw/sample.txt |  awk "NR == ${SLURM_ARRAY_TASK_ID}")

#SEQS=$(awk '{print $1}' data/raw/ | sed 1d | head -10)

# MODULE LOADS

module load samtools

# OBTAIN PROTEIN SEQUENCES

# GH3

for prot in $( cat data/raw/${SAMPLE}_GH3.txt )
do

  samtools faidx data/clean/${SAMPLE}/${SAMPLE}_prot.faa ${prot} >> data/clean/GH3_proteins.txt

done

# GH20

for prot in $( cat data/raw/${SAMPLE}_GH20.txt )
do
  
  samtools faidx data/clean/${SAMPLE}/${SAMPLE}_prot.faa ${prot} >> data/clean/GH20_proteins.txt

done

# V-ATP

for prot in $( cat data/raw/${SAMPLE}_V-ATP.txt )
do
  
  samtools faidx data/clean/${SAMPLE}/${SAMPLE}_prot.faa ${prot} >> data/clean/V-ATP_proteins.txt

done

# H-PP

for prot in $( cat data/raw/${SAMPLE}_H-PP.txt )
do
  
  samtools faidx data/clean/${SAMPLE}/${SAMPLE}_prot.faa ${prot} >> data/clean/H-PP_proteins.txt

done

