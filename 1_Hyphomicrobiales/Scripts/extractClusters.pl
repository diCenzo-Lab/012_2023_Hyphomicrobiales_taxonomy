#!/usr/bin/perl
use File::Find;
use 5.010;
use Cwd;

$pwd = cwd();
$parent = @ARGV[0];
$out_dir = @ARGV[1];
$strains = @ARGV[2];

find( \&search_all_folder, $parent );

sub search_all_folder {
	chomp $_;
	return if $_ eq '.' or $_ eq '..';
	&read_files ($_) if (-f);
}

sub read_files {
	($filename) = @_;
    $test = 0;
    $count = 0;
    open($in, '<', $filename);
    while(<$in>) {
        if(/>/) {
            if(/Chenggangzhangella/) {
                $test = 1;
            }
            elsif(/Liberibacter/) {
                $test = 1;
            }
            elsif(/Methylobrevis/) {
                $test = 1;
            }
            elsif(/Methyloligella/) {
                $test = 1;
            }
            elsif(/Nitratireductor/) {
                $test = 1;
            }
            else {
                $test = 0;
                $count++;
            }
        }
    }
    close($in);
    if($count == $strains) {
        open($in, '<', "$filename");
        open($out, '>', "$out_dir/$filename");
        while(<$in>) {
            if(/>/) {
            if(/Chenggangzhangella/) {
                $test = 1;
            }
            elsif(/Liberibacter/) {
                $test = 1;
            }
            elsif(/Methylobrevis/) {
                $test = 1;
            }
            elsif(/Methyloligella/) {
                $test = 1;
            }
            elsif(/Nitratireductor/) {
                $test = 1;
            }
                else {
                    $test = 0;
                    print $out ($_);
                }
            }
            elsif($test == 0) {
                print $out ($_);
            }
        }
        close($in);
        close($out);
    }
}

