#!/bin/bash
#SBATCH --error=data/logs/guppy.err
#SBATCH --mem=10G
#SBATCH -c 32
#SBATCH --gres=gpu:a100:1

module load ont-guppy/6.4.6-CUDA-system

guppy_basecaller -i /mnt/lustre/scratch/nlsas/home/csic/eyg/rmm/fast5 \
 --save_path ${STORE}/data \
 -c rerio/basecall_models/res_dna_r9.4.1_e8.1_sup_v033.cfg \
 --model_file rerio/basecall_models/res_dna_r9.4.1_e8.1_sup_v033.jsn -x "cuda:0"
