#!/usr/bin/perl
use 5.010;

# make arrays with the species names
while(<>) {
	chomp;
	@line = split("\t",$_); # split the input line into an array based on commas
	push(@species,@line[0]); # make an array of the species names
}

# fix the naming
for $species (@species) {
    $input_file = 'Genome_files/' . $species . '.gbff';
    $output_file = 'Genome_files_modified/' . $species . '.gbff';
    open($in, '<', $input_file);
    open($out, '>', $output_file);
    while(<$in>) {
        if(/ORGANISM/) {
        say $out ("  ORGANISM  $species");
        }
        elsif(/SOURCE/) {
        say $out ("SOURCE      $species");
        }
        else {
            print $out ("$_");
        }
    }
    close($in);
    close($out);
}
