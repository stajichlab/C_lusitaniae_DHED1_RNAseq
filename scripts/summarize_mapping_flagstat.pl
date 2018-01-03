#!/usr/bin/perl

use strict;
use warnings;

my $dir = 'aln';
opendir(DIR,$dir) || die $!;

my %dat;
for my $file ( readdir(DIR)  ) {
    next unless $file =~ /(\S+)\.bam\.stat$/;
    my $pref = $1;
    my $src = ( $pref =~ s/\.gsnap//) ? 'gsnap' : 'hisat';
    open(my $fh => "$dir/$file") || die "$!";
    while(<$fh>) {
	if( /(\d+).+mapped\s+\((\d+\.\d+)/ ){
	    $dat{$pref}->{$src} = [$1,$2];
	}
    }
}
my @cols = qw(STRAIN GSNAP_MAPPED GSNAP_FRAC HISAT_MAPPED HISAT_FRAC);
print join("\t", @cols),"\n";
for my $strain ( sort keys %dat ) {
    print join("\t", $strain, 
	       map { @{$dat{$strain}->{$_} || []} } qw(gsnap hisat)
	),"\n";    
}
    
