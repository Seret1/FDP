#!/bin/bash

#SBATCH --account=emm2
#SBATCH --job-name=v_blast
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --output=blast_comparisons/data/logs/virus_reads_%A_%a.out
#SBATCH --error=blast_comparisons/data/logs/virus_reads_%A_%a.err 
#SBATCH --array=1-4%4

mkdir -p blast_comparisons/data/clean/blast_virus/

SAMPLE_PATH='/home/psegura/MassanaLab/assemblies/nanopore/data/raw/'
SAMPLE=$( cat ${SAMPLE_PATH}/sample.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")
DATA_DIR='/home/psegura/MassanaLab/assemblies/nanopore/data/raw/'

# Load modules

module load blast

# CREATE DATABASE

makeblastdb -in ${DATA_DIR}/query_seq.fasta -dbtype nucl -parse_seqids -out ${DATA_DIR}/virus_db


# Blast DB's

DB_BLAST="${DATA_DIR}/virus_db"

# Run name

RUN_NAME=$(echo ${SAMPLE} | awk -F'/' '{print $NF}') # take run name from fasta

# Out dir and filenames

DB_NAME=$(echo ${DB_BLAST} | awk -F'/' '{print $NF}') # take db name from db

OUT_DIR=blast_comparisons/data/clean/blast_virus/

THREADS=24

# BLAST

## Nanopore contigs

date
echo "Blast nanopore ${DB_NAME}"
blastn \
 -max_target_seqs 10 \
 -db ${DB_BLAST} \
 -outfmt '6 qseqid sseqid pident length qstart qend sstart send evalue stitle slen qlen' \
 -perc_identity 80 \
 -query nanopore/data/raw/${SAMPLE}_reads_def_headers.fa \
 -out ${OUT_DIR}/${SAMPLE}_ONT.reads_VIRUS_blast.out \
 -evalue 0.0001 \
 -num_threads ${THREADS}

### Best hit

LC_ALL=C sort \
 -k1,1 -k9,9g \
 ${OUT_DIR}/${SAMPLE}_ONT.reads_VIRUS_blast.out | \
 sort -u -k1,1 --merge > ${OUT_DIR}/${SAMPLE}_ONT_reads_VIRUS.best_hit.txt

date
echo 'Blast finished'

echo -e "query_id\tsubject_id\t%_identity\taln_len\tq_start\tq_end\ts_start\ts_end\te_value\tseq_title\tseq_len\tlen_reads" | cat - blast_comparisons/data/clean/blast_virus/${SAMPLE}_ONT.reads_VIRUS_blast.out > blast_comparisons/data/clean/blast_virus/${SAMPLE}_ONT.reads_VIRUS_blast.out.GOOD

echo -e "query_id\tsubject_id\t%_identity\taln_len\tq_start\tq_end\ts_start\ts_end\te_value\tseq_title\tseq_len\tlen_reads" | cat - blast_comparisons/data/clean/blast_virus/${SAMPLE}_ONT_reads_VIRUS.best_hit.txt > blast_comparisons/data/clean/blast_virus/${SAMPLE}_ONT_reads_VIRUS.best_hit.txt.GOOD

# remove not good files

rm blast_comparisons/data/clean/blast_virus/${SAMPLE}_ONT.reads_VIRUS_blast.out

rm blast_comparisons/data/clean/blast_virus/${SAMPLE}_ONT_reads_VIRUS.best_hit.txt

mv blast_comparisons/data/clean/blast_virus/${SAMPLE}_ONT.reads_VIRUS_blast.out.GOOD blast_comparisons/data/clean/blast_virus/${SAMPLE}_ONT.reads_VIRUS_blast.out

mv blast_comparisons/data/clean/blast_virus/${SAMPLE}_ONT_reads_VIRUS.best_hit.txt.GOOD blast_comparisons/data/clean/blast_virus/${SAMPLE}_ONT_reads_VIRUS.best_hit.txt

