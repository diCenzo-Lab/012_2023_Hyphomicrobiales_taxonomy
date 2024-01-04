#!/bin/perl
use File::Find;
use 5.010;
use Cwd;

$pwd = cwd();
$parent = "$pwd/Intermediate_files/perc95_138_out/aligned_marker_prot_seqs/";
$output = "$pwd/Intermediate_files/perc95_138_out/aligned_marker_prot_seqs_trimmed/";

find( \&search_all_folder, $parent );

sub search_all_folder {
	chomp $_;
	return if $_ eq '.' or $_ eq '..';
	&read_files ($_) if (-f);
}

sub read_files {
	($filename) = @_;
	$output2 = $output . $filename;
	system("trimal -in $filename -out $output2 -fasta -automated1")
}


