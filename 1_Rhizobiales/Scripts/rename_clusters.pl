#!/usr/bin/perl
use File::Find;
use 5.010;
use Cwd;

$pwd = cwd();
$parent = "$pwd/get_homologues_output_protein";
find( \&search_all_folder, $parent );

sub search_all_folder {
	chomp $_;
	return if $_ eq '.' or $_ eq '..';
	&read_files ($_) if (-f);
}

sub read_files {
	($filename) = @_;
    $file = "$parent/$filename";
    $outfile = $pwd . '/get_homologues_output_protein_renamed/' . $filename;
    open($in, '<', $file);
    open($out, '>', $outfile);
    while(<$in>) {
        if(/>/) {
            @line = split("\\|", $_);
            $species = @line[3];
            $species =~ s/\.gbff//;
            say $out (">$species");
        }
        else {
            print $out ($_);
        }
    }
    close($in);
    close($out);
}


