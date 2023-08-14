#!usr/bin/perl
use 5.010;

$output = 'Input_files/genomeList.txt';

open($out, '>', $output);
while(<>) {
	unless(/#/ or /GenBank/) {
		chomp;
		$_ =~ s/\"//g;
		@line = split("\t", $_);
		unless(@line[17] eq "") {
			@line[1] =~ s/\ /_/g;
			@line[1] =~ s/__/_/g;
			@line[1] =~ s/__/_/g;
			@line[1] =~ s/__/_/g;
			@line[1] =~ s/__/_/g;
			@line[1] =~ s/__/_/g;
			if(@line[1] eq "") {
				$total++;
				@line[1] = "NoStrain$total";
			}
			say $out ("@line[1]\t@line[17]");
		}
	}
}
close($out);

