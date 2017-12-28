Raw counts for GSNAP based strand-specific alignments
======
Note that gene and transcript values will be identical because no isoforms (or introns) for C. lusitaniae

* [DHED1.DESeq.gene_count.tab](DHED1.DESeq.gene_count.tab) - per gene raw read count for each expr & replicate
* [DHED1.DESeq.trans_count.tab](DHED1.DESeq.trans_count.tab) - per transcript raw read count for each expr & replicate
* [DHED1.DESeq.CPM.csv](DHED1.DESeq.CPM.csv) - EdgeR based Counts-Per-Million. See [compute_cpm.R](../Rscripts/compute_cpm.R)

HISAT2 run (which did not respect strand)
=====
For comaprison the Hisat2 results - not to be used for further analysis
* [DHED1.DESeq.trans_count.unstranded.tab](DHED1.DESeq.trans_count.unstranded.tab)
* [DHED1.DESeq.gene_count.unstranded.tab](DHED1.DESeq.gene_count.unstranded.tab)

There are other files in here which reflect validation of the strand-specific nature of the libraries, will be in the github raw folder but not linked directly on the website as they do not add much information.
