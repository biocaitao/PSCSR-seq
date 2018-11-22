use strict;

my $binlen=10;
if(@ARGV<2){
  die "perl filter_miRNA.pl ~/data/database/ncRNA.gff seq.map;";
}

my %ncRNA=();
open(INFL, $ARGV[0]) or die "$!";
while(<INFL>){
  chomp;
  my @t =split /\t/;
  my $id = $t[2] ;
#-1 shift to 0 base
  my $bin_start = $t[3]-$binlen-1;
  my $bin_end = $t[4] -1;
  for(my $i=$bin_start; $i<=$bin_end; $i++){
    $ncRNA{$t[0]}{$t[6]}{$i} =$id;
  }

}
close(INFL);


open(INFL, $ARGV[1]) or die "$!";
while(<INFL>){
  chomp;
  my @t=split /\t/;
  my $po = $t[3];
  if(exists $ncRNA{$t[2]}{$t[1]}{$po}){
       $t[0] =~s/ (.*)//;
       print join("\t", @t);
       print "\t";
       print $ncRNA{$t[2]}{$t[1]}{$po}, "\n";

  }
 

}
close(INFL);
