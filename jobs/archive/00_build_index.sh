#!/usr/bin/bash
#SBATCH --time 4:00:00 --mem 2gb --out logs/build_index.log

module load hisat2

pushd genome
ln -s candida_lusitaniae_ATCC42720_w_CBS_6936_MT.fasta candida_lusitaniae_ATCC42720_w_CBS_6936_MT.fa
hisat2-build candida_lusitaniae_ATCC42720_w_CBS_6936_MT.fa candida_lusitaniae_ATCC42720_w_CBS_6936_MT
