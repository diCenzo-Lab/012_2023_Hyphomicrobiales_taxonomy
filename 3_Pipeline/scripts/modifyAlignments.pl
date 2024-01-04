#!/bin/perl
use File::Find;
use 5.010;
use Cwd;

$pwd = cwd();
$parent = "$pwd/Intermediate_files/perc95_138_out/aligned_marker_prot_seqs_trimmed/";
$output = "$pwd/Intermediate_files/perc95_138_out/aligned_marker_prot_seqs_modified/";

find( \&search_all_folder, $parent );

sub search_all_folder {
	chomp $_;
	return if $_ eq '.' or $_ eq '..';
	&read_files ($_) if (-f);
}

sub read_files {
	($filename) = @_;
	open $fh, '<', $filename;
	$output2 = $output . $filename;
	open($out,'>',$output2);
	while(<$fh>) {
		if(/>/) {
			chomp;
			@line = split("\ ",$_);
			print $out ("\n@line[0], ,");
		}
		else {
			chomp;
			print $out ($_);
		}
	}
	close($fh);
	close($out);
}


