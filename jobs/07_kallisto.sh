#!/bin/bash
#SBATCH --ntasks 8 --nodes 1 --mem 8G --out logs/kallisto.%a.log -J kallisto

module load kallisto
CPU=8
N=${SLURM_ARRAY_TASK_ID}
INDIR=raw
OUTDIR=results
SAMPLEFILE=samples.txt

mkdir -p $OUTDIR/kallisto_fr
mkdir -p $OUTDIR/kallisto_single
mkdir -p $OUTDIR/kallisto_rf

if [ ! $N ]; then
 N=$1
fi

if [ ! $N ]; then
 echo "cannot run without a number provided either cmdline or --array in sbatch"
 exit
fi
IFS=,
sed -n ${N}p $SAMPLEFILE | while read FOLDER SAMPLE REP
do
 echo $FOLDER $SAMPLE
 if [ ! -f $OUTDIR/kallisto/${SAMPLE}.r${REP}/abundance.h5 ]; then
  kallisto quant -i genome/Clus.CDS.idx -o results/kallisto_fr/${SAMPLE}.r${REP} -t $CPU --bias  --fr-stranded $INDIR/${FOLDER}/*.fastq.gz
 fi
 if [ ! -f $OUTDIR/kallisto_rf/${SAMPLE}.r${REP}/abundance.h5 ]; then
  kallisto quant -i genome/Clus.CDS.idx -o results/kallisto_rf/${SAMPLE}.r${REP} -t $CPU --bias  --rf-stranded $INDIR/${FOLDER}/*.fastq.gz
fi

 if [ ! -f $OUTDIR/kallisto_single/${SAMPLE}.r${REP}/abundance.h5 ]; then
  kallisto quant -i genome/Clus.CDS.idx -o $OUTDIR/kallisto_single/${SAMPLE}.r${REP} -t $CPU --bias --single -l 300 --sd 1000 $INDIR/${FOLDER}/*.fastq.gz
 fi
done
