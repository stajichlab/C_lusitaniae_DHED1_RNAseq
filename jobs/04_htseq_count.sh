#!/bin/bash
#SBATCH --mem 16G --ntasks 2 --nodes 1 --time 1-0:0:0 --out logs/htseq.log -J htseqcount
# Too slow implmentation
module unload python
module load python/3
echo "This is too slow to really use"

htseq-count --secondary-alignments score -f bam -i gene_id -t exon -s yes -r pos \
 aln/*.gsnap.bam genome/candida_lusitaniae_1_transcripts.gtf > results/htseq/htseq.tab
