#!/usr/bin/bash
#SBATCH --nodes 1 --ntasks 2 --mem 4gb --time 24:00:00 --out logs/prep_DEseq.log
PREFIX=DHED1
OUT=reports
mkdir -p $OUT
cd results
for dir in *.r[12].gsnap
do
 pushd $dir;
 ln -s ../$(basename `pwd`)*.gtf .
 popd
done
cd ..
python scripts/prepDE.py -g $OUT/$PREFIX.DESeq.gene_count.tab -t $OUT/$PREFIX.DESeq.trans_count.tab -i results
