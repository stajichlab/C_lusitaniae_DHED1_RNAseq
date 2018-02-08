#!/usr/bin/bash
#SBATCH --nodes 1 --ntasks 16 --mem 16gb --time 12:00:00 -J hisat2 --out logs/hisat2.%a.log

module load hisat2

GENOME=genome/candida_lusitaniae_ATCC42720_w_CBS_6936_MT
CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
 CPU=$SLURM_CPUS_ON_NODE
fi

N=${SLURM_ARRAY_TASK_ID}
INDIR=raw
OUTDIR=aln
SAMPLEFILE=samples.txt
mkdir -p $OUTDIR

if [ ! $N ]; then
 N=$1
fi

if [ ! $N ]; then
 echo "cannot run without a number provided either cmdline or -t in qsub"
 exit
fi
IFS=,
sed -n ${N}p $SAMPLEFILE | while read FOLDER SAMPLE REP
do
 echo $FOLDER $SAMPLE
 
 OUTFILE=$OUTDIR/${SAMPLE}.r${REP}.sam
 PAIR1=$(ls ${INDIR}/${FOLDER}/*_R1_*.gz | perl -p -e 's/\s+/,/g' | perl -p -e 's/,$//')
 PAIR2=$(ls ${INDIR}/${FOLDER}/*_R1_*.gz | perl -p -e 's/\s+/,/g' | perl -p -e 's/,$//')
 echo "$PAIR1 $PAIR2"
 if [ ! -f $OUTFILE ]; then
  hisat2 --rna-strandness RF -p $CPU -x $GENOME --known-splicesite-infile genome/splicesites.txt --dta --dta-cufflinks --secondary --rg-id $FOLDER -q -1 "$PAIR1" -2 "$PAIR2" -S $OUTFILE
 fi

done
