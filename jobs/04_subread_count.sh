#!/bin/bash 
#SBATCH --nodes 1 --ntasks 8 --mem 12G -J subreadcount -p short
#SBATCH --time 2:0:0 --out logs/subread_count.%a.log

module load subread/1.6.0

GENOME=genome/candida_lusitaniae_ATCC42720_w_CBS_6936_MT.fasta
GFF=genome/candida_lusitaniae_1_transcripts.gtf
OUTDIR=results/featureCounts
INDIR=aln
EXTENSION=gsnap.bam
mkdir -p $OUTDIR
TEMP=/scratch
SAMPLEFILE=samples.txt

CPUS=$SLURM_CPUS_ON_NODE
N=${SLURM_ARRAY_TASK_ID}

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
    OUTFILE=$OUTDIR/$SAMPLE.r${REP}.gsnap_reads.tab
    INFILE=$INDIR/$SAMPLE.r${REP}.$EXTENSION
    echo "$FOLDER $SAMPLE $REP $OUTFILE $INFILE"
    if [ ! -f $OUTFILE ]; then
	featureCounts -g gene_id -T $CPUS -G $GENOME -s 1 -a $GFF \
            --tmpDir $TEMP  \
	    -o $OUTFILE -F GTF $INFILE
    fi

    OUTFILE=$OUTDIR/$SAMPLE.r${REP}.gsnap_reads.nostrand.tab
    INFILE=$INDIR/$SAMPLE.r${REP}.$EXTENSION
    echo "$FOLDER $SAMPLE $REP $OUTFILE $INFILE"
    if [ ! -f $OUTFILE ]; then
	featureCounts -g gene_id -T $CPUS -G $GENOME -s 0 -a $GFF \
            --tmpDir $TEMP \
	    -o $OUTFILE -F GTF $INFILE
    fi

    OUTFILE=$OUTDIR/$SAMPLE.r${REP}.gsnap_frags.tab
    INFILE=$INDIR/$SAMPLE.r${REP}.$EXTENSION
    echo "$FOLDER $SAMPLE $REP $OUTFILE $INFILE"
    if [ ! -f $OUTFILE ]; then
	featureCounts -g gene_id -T $CPUS -G $GENOME -s 1 -a $GFF \
            --tmpDir $TEMP \
	    -o $OUTFILE -F GTF -p $INFILE
    fi
done

