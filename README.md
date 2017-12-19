RNAseq for Candida (Clavispora) lusitaniae project from Deborah Hogan / Elora Demers

Samples are listed in samples.txt

Jobs are run as:

* jobs/00_build_index.sh
* jobs/01_hisat2.sh - map the reads - run with array jobs or using parallel
`seq 27 | parallel bash jobs/01_hisat2.sh {}`
* jobs/02_make_bam.sh  - run with array jobs or using parallel
`seq 27 | parallel bash jobs/02_make_bam.sh {}`

