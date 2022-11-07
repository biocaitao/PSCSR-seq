use strict;


if(@ARGV<1){
  die "perl sampling ncRNA.map";
}

my @lines=();
open(INFL, $ARGV[0]) or die "$!";
@lines=<INFL>;
close(INFL);
#downsampling 30K, 50K, 100K, 200K, 300K reads;
my @s =(0.1, 0.1667, 0.333, 0.667, 1);
my %nid = ();
foreach my $line (@lines){
  my @t =split /\t/,  $line;
  $nid{$t[0]} =0;
}
my $totalid = scalar keys %nid;

foreach my $j (@s){
  my $n = $j * $totalid;

  #count miRNAs
  my %miRNA=();
  my $old = "";
  my $c =0;
  for(my $i=0; $i<@lines; $i++){
    
    chomp($lines[$i]);
    my @t =split /\t/, $lines[$i];
    if($t[0] ne $old){
      $old = $t[0];
      $c++;
    }
    if($c > $n){
      last;
    }
    if($lines[$i]=~/pre_/){
      $miRNA{$t[-1]}=1;
    }

  }
  #print counts
  print "sampling", $j,  ",";
  print scalar keys %miRNA ; 
  print  "\n";


}

