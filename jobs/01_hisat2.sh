#!/usr/bin/bash
#SBATCH --nodes 1 --ntasks 16 --mem 16gb --time 12:00:00 -J hisat2 --out logs/hisat2.%a.log

#PBS -l nodes=1:ppn=16,mem=16gb,walltime=12:00:00 -j oe -N hisat2
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
REP=1

sed -n ${N}p $SAMPLEFILE | while read NAME FOLDER;
do
 echo $NAME $FOLDER
 NAME=DHED${NAME} 
 OUTFILE=$OUTDIR/${NAME}.r${REP}.sam
 PAIR1=$(ls ${INDIR}/${FOLDER}/*_R1_*.gz | perl -p -e 's/\s+/,/g' | perl -p -e 's/,$//')
 PAIR2=$(ls ${INDIR}/${FOLDER}/*_R1_*.gz | perl -p -e 's/\s+/,/g' | perl -p -e 's/,$//')
 echo "$PAIR1 $PAIR2"
 if [ ! -f $OUTFILE ]; then
  hisat2 -p $CPU -x $GENOME --known-splicesite-infile genome/splicesites.txt --dta --dta-cufflinks --secondary --rg-id $NAME -q -1 "$PAIR1" -2 "$PAIR2" -S $OUTFILE
 fi

done
