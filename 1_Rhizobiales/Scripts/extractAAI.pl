#!usr/bin/perl
use 5.010;

$n = 0;
while(<>) {
  chomp;
  $n++;
  if($n == 1) {
    @names = split("\t", $_);
  }
  else {
    @line = split("\t", $_);
    for($i = 1; $i < scalar(@line); $i++) {
      if(@line[$i] == 100) {
        say("@line[0]\t@names[$i]\t@line[$i]");
        last;
      }
      else {
        say("@line[0]\t@names[$i]\t@line[$i]");
      }
    }
  }
}
