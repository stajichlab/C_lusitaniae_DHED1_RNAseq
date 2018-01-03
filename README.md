RNAseq for Candida (Clavispora) lusitaniae project from Deborah Hogan / Elora Demers

Samples are listed in [samples.txt](samples.txt)

Read Mapping stats are in [mapping_stats.tsv](mapping_stats.tsv)

Summary plots and data for RNASeq
* [StringTie Results](plots/RNASeq_stringtieFrags.pdf) - don't use but for comparison. Data file is [DHED1.DESeq.gene_count.tab](reports/DHED1.DESeq.gene_count.tab)
* [GSNAP featureCount Fragments](plots/RNASeq_featureCount_frags.pdf) - also don't use but for comparison. Data file is [DHED1.gsnap_frags.tab](reports/DHED1.gsnap_frags.tab)
* [GSNAP featureCount Reads](plots/RNASeq_featureCount_reads.pdf) - __USE ME__ Data file is [DHED1.gsnap_reads.tab](reports/DHED1.gsnap_reads.tab)

[GSNAP](http://research-pub.gene.com/gmap/) Jobs are run as:

* 00_build_gmap_index.sh **SINGLE**
* 01_gsnap.sh **SLURMARRAY**
```bash
$ seq 24 | parallel bash jobs/01_gsnap.sh {}
# or
$ sbatch --array=1-24 jobs/01_gsnap.sh
```
* jobs/02_make_bam_gsnap.sh - run with array jobs or using parallel **SLURMARRAY**
```bash
$ seq 24 | parallel bash jobs/02_make_bam_gsnap.sh {}
# or
$ sbatch --array=1-24 jobs/02_make_bam_gsnap.sh
```
* 03_stringtie.sh - compute RNAseq expr **SLURMARRAY**
* 04_get_counts.sh - make count table for DEseq **SINGLE**
* 05_stats_pairedend.sh - summarize read-pair strandedness **SLURMARRAY**

Notes about Prior Analyses
====
Earlier analyses used HISAT2 which reportedly would respect strand-specific nature of these RNAseq libraries, but apparently did not. So these were scrapped, but archived for comparison
* jobs/00_build_index.sh **SINGLE**
* jobs/01_hisat2.sh - map the reads - run with array jobs or using parallel **SLURMARRAY**
```bash
$ seq 24 | parallel bash jobs/01_hisat2.sh {}
# or
$ sbatch --array=1-24 jobs/01_hisat2.sh
```
* jobs/02_make_bam.sh  - run with array jobs or using parallel **SLURMARRAY**
```bash
$ seq 24 | parallel bash jobs/02_make_bam.sh {}
# or
$ sbatch --array=1-24 jobs/02_make_bam.sh
```

* 03_stringtie.sh - compute RNAseq expr **SLURMARRAY**
* 04_get_counts.sh - make count table for DEseq **SINGLE**
* 05_stats_pairedend.sh - summarize read-pair strandedness **SLURMARRAY**

Alternative pipline for GSNAP

See the Expression reports from these runs in [reports](reports)
