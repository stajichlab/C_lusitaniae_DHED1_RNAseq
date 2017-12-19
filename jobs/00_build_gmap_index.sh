#!/usr/bin/bash
#SBATCH --time 2:00:00 --mem 2G 

module load gmap
cd genome
gmap_build -D=. -d candida_lusitaniae candida_lusitaniae_ATCC42720_w_CBS_6936_MT.fasta
gtf_splicesites < candida_lusitaniae_1_transcripts.gtf | iit_store -o candida_lusitaniae/candida_lusitaniae.maps/splicesites.iit
gtf_introns < candida_lusitaniae_1_transcripts.gtf | iit_store -o candida_lusitaniae/candida_lusitaniae.maps/introns.iit
