#!/usr/bin/perl
use 5.010;

# Input files
$species_names_file = @ARGV[0];
$alignment_file = @ARGV[1];

# Save the strings to replace
open($in, '<', $species_names_file);
while(<$in>) {
    chomp;
    @line = split("\t", $_);
    push(@numbers, @line[0]);
    push(@species, @line[2]);
}
close($in);

# Replace the strings
open($in, '<', $alignment_file);
while(<$in>) {
    if(/>/) {
        chomp;
        $header = $_;
        $header =~ s/>//;
        for $i (@numbers) {
            if($i == $header) {
                say(">@species[$i-1]");
            }
        }
    }
    else {
        print($_);
    }
}

