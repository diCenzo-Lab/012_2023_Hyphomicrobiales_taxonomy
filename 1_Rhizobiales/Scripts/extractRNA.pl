#!/usr/bin/perl
use 5.010;

# make arrays with the species names
while(<>) {
	chomp;
	@line = split("\t",$_); # split the input line into an array based on commas
	push(@species,@line[0]); # make an array of the species names
}

# Get the sequences, if full length
$output_file = 'rRNA_phylogeny/genome_extracted_16S_rRNA.fna';
unlink($output_file);
for $species (@species) {
    $count = 0;
    $input_file = 'Genome_files/' . $species . '.RNA.fna';
    open($in, '<', $input_file);
    open($out, '>>', $output_file);
    while(<$in>) {
        chomp;
        if(/>/) {
            if(/16S/) {
                if(/</ || /..>/) {
                    $test = 0;
                }
                else {
                    $test = 1;
                    $count++;
                    print $out ("\n>$species\t");
                }
            }
            else {
                $test = 0;
            }
        }
        elsif($test == 1) {
            print $out ("$_");
        }
    }
    close($in);
    close($out);
}

#Get just the unique sequences
system("sort -u rRNA_phylogeny/genome_extracted_16S_rRNA.fna > rRNA_phylogeny/genome_extracted_16S_rRNA_uniq.fna");
for $species (@species) {
    $count = 0;
    $input_file = 'rRNA_phylogeny/genome_extracted_16S_rRNA_uniq.fna';
    open($in, '<', $input_file);
    while(<$in>) {
        chomp;
        @line = split("\t", $_);
        if(/$species/) {
            $count++;
            print(">$species");
            print("_T");
            if($count == 1) {
                print("\t@line[1]\n");
            }
            else {
                print("_$count\t@line[1]\n");
            }
        }
    }
}

