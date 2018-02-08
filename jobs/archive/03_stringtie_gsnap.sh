#!/usr/bin/bash
#SBATCH --nodes 1 --ntasks 24 --mem 16G 
#SBATCH-J stringtie.estimate --out logs/stringtie.%a.log --time 12:00:00

module load stringtie
N=${SLURM_ARRAY_TASK_ID}
OUTDIR=results/stringtie
INDIR=aln
SAMPLEFILE=samples.txt
GTF=genome/candida_lusitaniae_1_transcripts.gtf

CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
 CPU=$SLURM_CPUS_ON_NODE
fi
mkdir -p $OUTDIR
if [ ! $N ]; then
 N=$1
fi

if [ ! $N ]; then
 echo "cannot run without a number provided either cmdline or --array in qsub"
 exit
fi

IFS=,
sed -n ${N}p $SAMPLEFILE | while read FOLDER SAMPLE REP
do
 echo "$FOLDER $SAMPLE"
 INFILE=$INDIR/${SAMPLE}.r${REP}.gsnap.bam
 echo "NAME is $SAMPLE REP is $REP infile = $INFILE OUTDIR=$OUTDIR/${SAMPLE}.r${REP} " 
 mkdir -p $OUTDIR/${NAME}.r${REP}
 stringtie --rf -p $CPU -G $GTF -b $OUTDIR/${SAMPLE}.r${REP}.gsnap -e -o $OUTDIR/${SAMPLE}.r${REP}.gsnap.stringtie.gtf $INFILE
done
