grep CDS *.gff3 | perl -p -e 's/ID=(\S+);Parent=(CLUT_(\d+)T\d+)/gene_id "CLUG_$3"; transcript_id "$3";/' > candida_lusitaniae_1_fixed.gtf
