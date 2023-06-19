#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=aug
#SBATCH --cpus-per-task=18
#SBATCH --mem=50G
#SBATCH --ntasks-per-node=1
#SBATCH --output=data/logs/aug.out
#SBATCH --error=data/logs/aug.err 
#SBATCH --array=1-4%4

#================================================	
##########VARIABLES#########

SAMPLE_FILE='data/raw/sample.txt'
SAMPLE=$( cat ${SAMPLE_FILE} | awk "NR == ${SLURM_ARRAY_TASK_ID}")

ASS_DIR=/mnt/lustre/repos/bio/projects/MassanaLab/assemblies/corrected/data/clean/corrected_assembly/
RES_DIR=/mnt/lustre/repos/bio/projects/MassanaLab/assemblies/gene_finding/data/clean/
BUS_DIR=/mnt/lustre/repos/bio/projects/MassanaLab/assemblies/corrected/data/clean/quast_busco_tiara/busco_c/clean

# Load modules

module load blast

# Parameters
		
NUM_THREADS=18

###########SCRIPT###########

#cd ${DATA_DIR}

#Runing Augustus

export AUGUSTUS_CONFIG_PATH=/mnt/lustre/repos/bio/projects/MassanaLab/assemblies/gene_finding/data/raw/augustus/config
export PATH=$PATH:/mnt/lustre/repos/bio/projects/MassanaLab/assemblies/gene_finding/data/raw/augustus/bin
export PATH=$PATH:/mnt/lustre/repos/bio/projects/MassanaLab/assemblies/gene_finding/data/raw/augustus/scripts
export PATH=$PATH:/mnt/lustre/repos/bio/projects/MassanaLab/Programs/scipio/

#Runing Augustus
module load perl

##Preparing training files

mkdir -p ${RES_DIR}/${SAMPLE}

cd ${RES_DIR}/${SAMPLE}

if [ $SAMPLE = 'CAE71' ] || [ $SAMPLE = 'CAE72' ] || [ $SAMPLE = 'PAR' ]
then
cat ${BUS_DIR}/run_${SAMPLE}/single_copy_busco_sequences/*.faa | sed "s/\:.*asta\:/_/g" > ${SAMPLE}_busco.fasta

elif [ $SAMPLE = 'mediocremonas' ] || [ $SAMPLE = 'cafeteria' ]
then 

cat ${BUS_DIR}/${SAMPLE}/run_eukaryota_odb10/busco_sequences/single_copy_busco_sequences/*.faa | sed "s/\:.*asta\:/_/g" > ${SAMPLE}_busco.fasta

fi

perl /mnt/lustre/repos/bio/projects/MassanaLab/Programs/scipio/scipio.pl ${ASS_DIR}/${SAMPLE}/contigs_corrected_clean2.fasta ${SAMPLE}_busco.fasta > ${SAMPLE}_scipiout

cat ${RES_DIR}/${SAMPLE}/${SAMPLE}_scipiout | perl /mnt/lustre/repos/bio/projects/MassanaLab/assemblies/gene_finding/data/raw/augustus/scripts/yaml2gff.1.4.pl --filterstatus=\"incomplete\"> ${SAMPLE}_yamlout.gff

perl /mnt/lustre/repos/bio/projects/MassanaLab/assemblies/gene_finding/data/raw/augustus/scripts/scipiogff2gff.pl --in=${RES_DIR}/${SAMPLE}/${SAMPLE}_yamlout.gff --out=${SAMPLE}_traingenes.gff

##generating training file

perl /mnt/lustre/repos/bio/projects/MassanaLab/assemblies/gene_finding/data/raw/augustus/scripts/autoAug_DLEEE2.pl --species=${SAMPLE} --genome=${ASS_DIR}/${SAMPLE}/contigs_corrected_clean2.fasta --trainingset=${SAMPLE}_traingenes.gff

##runing Augustus
/mnt/lustre/repos/bio/projects/MassanaLab/assemblies/gene_finding/data/raw/augustus/bin/augustus --species=${SAMPLE} ${ASS_DIR}/${SAMPLE}/contigs_corrected_clean2.fasta > ${SAMPLE}_augustus.gff

##Generating protein and transcript sequences from gff file
perl /mnt/lustre/repos/bio/projects/MassanaLab/assemblies/gene_finding/data/raw/augustus/scripts/getAnnoFasta.pl ${RES_DIR}/${SAMPLE}/${SAMPLE}_augustus.gff --seqfile=${ASS_DIR}/${SAMPLE}/contigs_corrected_clean2.fasta  --chop_cds

##Parsing sequences and adding Species name on each transcript and protein

cat ${SAMPLE}_augustus.codingseq | sed "s/>/>${SAMPLE}_/g" > ${SAMPLE}_cdna.fna

cat ${SAMPLE}_augustus.aa | sed "s/>/>${SAMPLE}_/g" > ${SAMPLE}_prot.faa

