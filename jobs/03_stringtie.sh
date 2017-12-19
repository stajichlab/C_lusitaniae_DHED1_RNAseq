#!/usr/bin/bash
#SBATCH --nodes 1 --ntasks 24 --mem 16G 
#SBATCH-J stringtie.estimate --out logs/stringtie.%a.log --time 12:00:00

module load stringtie
N=${SLURM_ARRAY_TASK_ID}
OUTDIR=results
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
REP=1
sed -n ${N}p $SAMPLEFILE | while read NAME FOLDER;
do
 echo $NAME $FOLDER
 NAME=DHED${NAME}
 OUTFILE=$OUTDIR/${NAME}.r${REP}.sam
 echo "$PAIR1 $PAIR2"

 INFILE=$INDIR/${NAME}.r${REP}.bam
 echo "NAME is $NAME REP is $REP infile = $INFILE"
 mkdir -p $OUTDIR/${NAME}.r${REP}
 stringtie --fr -p $CPU -G $GTF -b $OUTDIR/${NAME}.r${REP} -e -o $OUTDIR/${NAME}.r${REP}.stringtie.gtf $INFILE
done
