#!usr/bin/perl
use 5.010;

# Files
#$input = 'aai_summary.tsv';
#$strains = 'speciesList.txt';
$input = @ARGV[0];
$strains = @ARGV[1];


# Get the strains
open($inStrains, '<', $strains);
while(<$inStrains>) {
	chomp;
	@line = split("\t", $_);
	push(@strains, @line[0]);
}
close($inStrains);

# Prepare the first row
print('Strains');
foreach $i (@strains) {
	$i =~ s/Genomes\///;
	$i =~ s/.fna//;
	print("\t$i");
}

# Make the matrix
foreach $i (@strains) {
	print("\n$i");
	foreach $j (@strains) {
		if($i eq $j) {
			print("\t100");
		}
		else {
			open($in, '<', $input);
			while(<$in>) {
                @line = split("\t", $_);
				if($i eq @line[2]) {
					if($j eq @line[3]) {
						@line = split("\t", $_);
						print("\t@line[4]");
					}
				}
                elsif($j eq @line[0]) {
                    if($i eq @line[2]) {
                        @line = split("\t", $_);
                        print("\t@line[4]");
                    }
                }

			}
			close($in);
		}
	}
}
