#!/bin/bash
#SBATCH --ntasks 8 --nodes 1 --mem 8G --out logs/kallisto.%a.log -J kallisto

module load kallisto
CPU=8
N=${SLURM_ARRAY_TASK_ID}
INDIR=raw
OUTDIR=aln
SAMPLEFILE=samples.txt
mkdir -p $OUTDIR

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
 kallisto quant -i genome/Clus.CDS.idx -o results/kallisto/${SAMPLE}.r${REP} -t $CPU --bias  --fr-stranded $INDIR/${FOLDER}/*.fastq.gz
done
