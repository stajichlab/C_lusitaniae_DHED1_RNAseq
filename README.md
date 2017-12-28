RNAseq for Candida (Clavispora) lusitaniae project from Deborah Hogan / Elora Demers

Samples are listed in samples.txt

Jobs are run as:

* jobs/00_build_index.sh
* jobs/01_hisat2.sh - map the reads - run with array jobs or using parallel

`seq 24 | parallel bash jobs/01_hisat2.sh {}`

* jobs/02_make_bam.sh  - run with array jobs or using parallel

`seq 24 | parallel bash jobs/02_make_bam.sh {}`

* 03_stringtie.sh - compute RNAseq expr
* 04_get_counts.sh - make count table for DEseq
* 05_stats_pairedend.sh - summarize read-pair strandedness

Alternative pipline for GSNAP
* 00_build_gmap_index.sh
* 01_gsnap.sh

`seq 24 | parallel bash jobs/01_gsnap.sh {}`


See the reports from this in [reports](reports)
