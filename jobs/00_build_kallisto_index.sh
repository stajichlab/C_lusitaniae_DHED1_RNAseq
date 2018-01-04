#!/usr/bin/bash
#SBATCH --time 4:00:00 --mem 2gb --out logs/build_index.log

module load kallisto

pushd genome

# module load GAL
# gal_dump_CDS_sequence candida_lusitaniae_1.gff3 candida_lusitaniae_ATCC42720_w_CBS_6936_MT.fa > candida_lusitaniae_1.cds.fasta
# perl -i -p -e 's/>CLUT_/>CLUG_/' candida_lusitaniae_1.cds.fasta
kallisto index -i Clus.CDS.idx candida_lusitaniae_1.cds.fasta
