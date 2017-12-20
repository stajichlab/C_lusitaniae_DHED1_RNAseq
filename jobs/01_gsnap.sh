#!/usr/bin/bash
#SBATCH --nodes 1 --ntasks 16 --mem 16gb 
#SBATCH --time 12:00:00 -J gmap --out logs/gmap.%a.log

module load gmap

GENOME=genome/candida_lusitaniae_ATCC42720_w_CBS_6936_MT
CPU=2
THREADCOUNT=1
if [ $SLURM_CPUS_ON_NODE ]; then
 CPU=$SLURM_CPUS_ON_NODE
 THREADCOUNT=$(expr $CPU - 2)
 if [ $THREADCOUNT -lt 1 ]; then
  THREADCOUNT=1
 fi
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
 echo "cannot run without a number provided either cmdline or --array in sbatch"
 exit
fi
IFS=,
sed -n ${N}p $SAMPLEFILE | while read FOLDER SAMPLE REP
do
 echo $FOLDER $SAMPLE
 
 OUTFILE=$OUTDIR/${SAMPLE}.r${REP}.gsnap.sam
 READS=$(ls $INDIR/${FOLDER}/*.fastq.gz | perl -p -e 's/\s+/ /g')
 echo "$READS"
 if [ ! -f $OUTFILE ]; then  

  echo "module load gmap" > job_$FOLDER.sh

  echo "gsnap -t $THREADCOUNT -s splicesites -D genome --gunzip \
 -d candida_lusitaniae --read-group-id=$FOLDER --read-group-name=$SAMPLE \
 -A sam $READS > $OUTFILE" >> job_$FOLDER.sh

 bash job_$FOLDER.sh
 unlink job_$FOLDER.sh

 fi

done
