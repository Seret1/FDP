#!/bin/sh

DATA_DIR=data/clean/quast_busco_tiara/busco_c/
OUT_FILE=data/clean/quast_busco_tiara/busco_c/busco_c_report.txt

HEADERS_SAMPLE=$(ls ${DATA_DIR} | grep 'run' | head -1)
HEADERS=$(cat ${DATA_DIR}/${HEADERS_SAMPLE}/short_summary_*txt | grep -v '^#' | sed '/^$/d' | grep -v '%' | perl -pe 's/.*\d+\s+//' | tr '\n' '\t')

echo -e "Sample\t${HEADERS}" > ${OUT_FILE}

for SAMPLE in $(ls ${DATA_DIR} | grep run | cut -f2,3 -d'_')
do
  REPORT=$(cat ${DATA_DIR}/run_${SAMPLE}/short_summary_${SAMPLE}.txt | \
  grep -v '^#' | perl -pe 's/^\n//' | awk '{print $1}' | tr '\n' '\t')
  echo -e "${SAMPLE}\t${REPORT}" >> ${OUT_FILE}
done

DATA_DIR=data/clean/quast_busco_tiara/tiara_c/
OUT_FILE=data/clean/quast_busco_tiara/tiara_c/tiara_c_report.txt


for SAMPLE in $(ls ${DATA_DIR} | grep '^log')
do
  cat ${DATA_DIR}/${SAMPLE} | \
  grep -e 'archaea' -e 'bacteria' -e 'eukarya' -e 'organelle' -e 'unknown' | \
  awk -v var=${SAMPLE} '{print var$0}' OFS='\t' \
  >> ${OUT_FILE}
done

DATA_DIR=data/clean/quast_busco_tiara/quast_c/
OUT_FILE=data/clean/quast_busco_tiara/quast_c/quast_c_report.txt

HEADERS_SAMPLE=$(ls ${DATA_DIR} | head -1)
HEADERS=$(cat ${DATA_DIR}/${HEADERS_SAMPLE}/transposed_report.tsv | head -1)

echo -e "Sample\t${HEADERS}" > ${OUT_FILE}

for SAMPLE in $(ls ${DATA_DIR} | grep -v txt)
do
  REPORT=$(cat ${DATA_DIR}/${SAMPLE}/transposed_report.tsv | tail -1)
  echo -e "${SAMPLE}\t${REPORT}" >> ${OUT_FILE}
done
