### Load libraries

library(readr)
library(tidyverse)
library(readxl)

### Main directory

DATA_DIR <- "data/clean/quast_busco_tiara/tiara_c/"


### Re-format TIARA

tiara <- read_tsv(sprintf("%stiara_c_report.txt", DATA_DIR), col_names = FALSE)

write_tsv(tiara, sprintf("%stiara_c_report.tsv", DATA_DIR))


tiara_new <- read_tsv(sprintf("%stiara_c_report.tsv", DATA_DIR))

df <- separate(tiara_new, X2, c("type", "num"))

data_wide <- spread(df, type, num)

write_tsv(data_wide, sprintf("%stiara_c_report_GOOD.tsv", DATA_DIR))


### Read QUAST, BUSCO & TIARA report files

rm(list = ls())

base <- data.frame(matrix(NA, nrow = 3, ncol = 17))

colnames(base) <- c("Sample", "Mb (>= 0 )", "Mb (> =1k)", "Mb (>= 3kb)", "Mb (>= 5Kb)", "contigs (>= 1Kb)", "contigs (>= 3Kb)", "contigs (>= 5Kb)", "Largest contig", "GC (%)", "N50", "Complete BUSCOs", "Fragmented BUSCOs", "Completeness (%) (out of 255)", "%-bact", "%-euk", "all tiara")

quast <- read_tsv(sprintf("%squast_c_report.txt", "/home/psegura/MassanaLab/assemblies/nanopore/data/clean/quast_busco_tiara/quast_c/"))
busco <- read_tsv(sprintf("%sbusco_c_report.txt", "/home/psegura/MassanaLab/assemblies/nanopore/data/clean/quast_busco_tiara/busco_c/"))
tiara <- read_tsv(sprintf("%stiara_c_report_GOOD.tsv", "/home/psegura/MassanaLab/assemblies/nanopore/data/clean/quast_busco_tiara/tiara_c/"))

### QUAST 

base$Sample <- quast$Sample

base[2:5] <- quast[7:10] / 1000000

base[6:8] <- quast[4:6]

base$`Largest contig` <- quast$`Largest contig`

base$`GC (%)` <- quast$`GC (%)`

base$N50 <- quast$N50


### BUSCO

base$`Complete BUSCOs` <- busco$`Complete and single-copy BUSCOs (S)`

base$`Fragmented BUSCOs` <- busco$`Missing BUSCOs (M)`

base$`Completeness (%) (out of 255)` <- round(100*(base$`Complete BUSCOs` + base$`Fragmented BUSCOs`)/255, 2)


### TIARA

### check if bacteria and archaea have representation

for (i in 1:dim(tiara)[1]){
  for (j in 1:dim(tiara)[2]){
    if (is.na(tiara[i,j]) == TRUE){
      tiara[i,j] = 0
    }
  }
}

base$`all tiara` <- tiara$bacteria + tiara$archaea + tiara$eukarya + tiara$organelle + tiara$unknown

base$`%-bact` <- round(100* tiara$bacteria / base$`all tiara`, 1)

base$`%-euk` <- round(100* tiara$eukarya / base$`all tiara`, 1)


### Write final summary table

write_tsv(base, sprintf("%sqbt_summary_ONT_contigs.tsv", "/home/psegura/MassanaLab/assemblies/nanopore/data/clean/quast_busco_tiara/"))

