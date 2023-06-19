#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=samtools
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --array=1-4%4

# SHORTCUTS

SAMPLE=$( cat data/clean/assembly/sample.txt |  awk "NR == ${SLURM_ARRAY_TASK_ID}")

TIGS=$(awk '{print $1}' blast_comparisons/data/clean/blast_18S/${SAMPLE}_ONT.best_hit.txt | sed 1d | head -10)

# MODULE LOADS

module load samtools

# OBTAIN 'TIGS' SEQUENCES

for tig in ${TIGS}
do 
 
  samtools faidx nanopore/data/raw/assembly/${SAMPLE}/contigs.fasta ${tig} >> blast_comparisons/data/clean/aligned_seqs_${SAMPLE}.txt

done
