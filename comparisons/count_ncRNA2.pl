use strict;

if(@ARGV<1) {
  die "perl count_ncRNA2.pl ncRNA.map";
}

#count  all;
my %c1 =();


open(INFL, $ARGV[0]) or die "$!";
while(<INFL>){
#  next if (!/pre/);
  chomp;
  my @t =split /\t/;
  $c1{$t[-1]} ++ ;
}
close(INFL);


foreach my $m (keys %c1){
     print $m, "\t";
     print $c1{$m}, "\n"; 
}



