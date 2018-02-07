grep CDS *.gff3 | perl -p -e 's/ID=(\S+);Parent=(CLUT_(\d+)T\d+)/gene_id "CLUG_$3"; transcript_id "$2";/; 
$new = $_; 
s/\tCDS\t/\texon\t/; 
$_ .= $new' > candida_lusitaniae_1_fixed.gtf

# this was then manually used to replace candida_lusitaniae_1_transcripts.gtf

