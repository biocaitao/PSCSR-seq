use strict;

if(@ARGV<3){
  die "perl stat_reads.pl processed.fa processed2.fa matched.fa";

}

my %count1 =();
open(INFL, $ARGV[0]) or die "$!";
while(<INFL>){
  if(/^>/){
    chomp;
    my @t =split /_/, $_;
    $count1{$t[1]}{$t[0]} =1;
  }
}
close(INFL);


my %count2 =();
open(INFL, $ARGV[1]) or die "$!";
while(<INFL>){
  if(/^>/){
    chomp;
    my @t =split /_/, $_;
    $count2{$t[1]}{$t[0]} =1;
  }
}
close(INFL);

my %count3 =();
my %count4 =();
open(INFL, $ARGV[2]) or die "$!";
while(<INFL>){
  if(/^>/){
    chomp;
    my @t =split /_/, $_;
    $count3{$t[1]}{$t[0]} =1;
    $count4{$t[1]}{$t[2]} =1;
  }
}
close(INFL);

foreach my $cell (keys %count1){
  print $cell, "\t";
  print scalar keys %{$count1{$cell}} || 0;
  print "\t";
  print scalar keys %{$count2{$cell}} || 0; 
  print "\t";
  print scalar keys %{$count3{$cell}} || 0;
  print "\t";
  print scalar keys %{$count4{$cell}} || 0;
  print "\n";

}
