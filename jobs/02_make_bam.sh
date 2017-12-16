#!/usr/bin/bash
#SBATCH --nodes 1 --ntasks 1 16gb --time 4:00:00 -J hisat2.makebam --out logs/makebam.%a.log

module load picard
MEM=16
GENOME=genome/candida_lusitaniae_ATCC42720_w_CBS_6936_MT
CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
 CPU=$SLURM_CPUS_ON_NODE
fi

N=$SLURM_ARRAY_TASK_ID
INDIR=aln
OUTDIR=aln
SAMPLEFILE=samples.txt
if [ ! $N ]; then
 N=$1
fi

if [ ! $N ]; then
 echo "cannot run without a number provided either cmdline or --array in sbatch"
 exit
fi

IFS=,
REP=1
sed -n ${N}p $SAMPLEFILE | while read NAME FOLDER;
do
 echo $NAME $FOLDER
 NAME=DHED${NAME}
infile=${INDIR}/${NAME}.r${REP}.sam
bam=${INDIR}/${NAME}.r${REP}.bam
echo "$infile $bam"

if [ ! -f $bam ]; then
 java -Xmx${MEM}g -jar $PICARD AddOrReplaceReadGroups SO=coordinate I=$infile O=$bam \ 
 CREATE_INDEX=true VALIDATION_STRINGENCY=LENIENT TMP_DIR=/scratch/${USER} \ 
 RGID=$NAME.r${REP} RGSM=$NAME.r${REP} RGPL=NextSeq RGPU=Dartmouth RGLB=$NAME.$FOLDER 
 if [ -f $bam ]; then
  rm $infile; touch $infile
  touch $bam
 fi
fi

done
