#!/usr/bin/perl
use 5.010;

# Help menu
if( $ARGV[0] eq '-h' || $ARGV[0] eq '-help' || $ARGV[0] eq '--help' || $ARGV[0] eq '--h') {
    say("A wrapper to automate the EzAAI steps. Required inputs are listed below and are in the order they must be provided.");
    say("\tInput_file\tA file containing paths to all of the genome nucleotide files to be used. Paths should all be present as a column with one genome per line.");
    say("\tOutput_directory\tName to be used for the output directory.");
    say("\tThreads\tHow many threads to use for parallel steps.");
    say("Final files stored as aai.tsv and aai.nwk within the output directory.");
    exit;
}

# Store input variables
$input_file = @ARGV[0];
$output_directory = @ARGV[1];
$output_directory =~ 's/\//g';
$threads = @ARGV[2];

# Create the output directory 
mkdir($output_directory) unless(-d $output_directory);

# Make output directory
system("mkdir $output_directory");

# Get species names
open($in, '<', $input_file);
while(<$in>) {
	chomp;
	@line = split("\t",$_); # split the input line into an array based on commas
	push(@input_paths,@line[0]); # make an array of the species names
}
close($in);

# Extract the proteomes
for $file (@input_paths) {
    @file = split('/', $file);
    $species = @file[-1];
    $species =~ 's/\.fasta//g';
    $species =~ 's/\.fna//g';
    $cmd = 'java -jar /home/Bioinformatics_programs/miscellaneous/EzAAI_v1.2.2.jar extract -t ' . $threads . ' -i ' . $file . ' -o ' . $output_directory . '/' . $species . '.db -l "' . $species . '"';
    system("$cmd");
}

# Calculate AAI
$cmd = 'java -jar /home/Bioinformatics_programs/miscellaneous/EzAAI_v1.2.2.jar calculate -t ' . $threads . ' -i ' . $output_directory . ' -j ' . $output_directory . ' -o ' . $output_directory . '/aai.tsv';
system("$cmd");

# Cluster based on the AAI output
$cmd = 'java -jar /home/Bioinformatics_programs/miscellaneous/EzAAI_v1.2.2.jar cluster -i ' . $output_directory . '/aai.tsv' . ' -o ' . $output_directory . '/aai.nwk';
system("$cmd");

