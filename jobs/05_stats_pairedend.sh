#!/usr/bin/bash
#SBATCH --nodes 1 --ntasks 1 --mem 2G --time 2:00:00 
#SBATCH -p short --out logs/inferexpr.%a.log -J inferexp

GENOME=genome/candida_lusitaniae_ATCC42720_w_CBS_6936_MT
BEDGENES=genome/candida_lusitaniae_1_transcripts.bed
CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
 CPU=$SLURM_CPUS_ON_NODE
fi

N=${SLURM_ARRAY_TASK_ID}
INDIR=raw
OUTDIR=aln
REPORTDIR=reports
mkdir -p $REPORTDIR
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
 BAM=$OUTDIR/${SAMPLE}.r${REP}.bam
 GSNAPBAM=$OUTDIR/${SAMPLE}.r${REP}.gsnap.bam
 if [ -f $BAM ]; then
  if [ ! -f $REPORTDIR/$SAMPLE.r${REP}.pairedreport.txt ]; then
   infer_experiment.py -s 1000000 -i $BAM -r $BEDGENES > $REPORTDIR/$SAMPLE.r${REP}.pairedreport.txt
  fi
 fi
 if [ -f $GSNAPBAM ]; then
  if [ ! -f $REPORTDIR/$SAMPLE.r${REP}.gsnap.pairedreport.txt ]; then
   infer_experiment.py -s 1000000 -i $GSNAPBAM -r $BEDGENES > $REPORTDIR/$SAMPLE.r${REP}.gsnap.pairedreport.txt
 fi
 fi
done

