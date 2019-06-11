use strict;
if(@ARGV<2){
  die "usage: perl filtergff.pl database/hsa.gff3 database/homo_sapiens.GRCh38.gff3.gz ";
}

open(INFL, $ARGV[0]) or die "$!";
while(<INFL>){
  if(/pre_/){
    print $_; 
  }


}
close(INFL);

my %conds=(
"rRNA"=>200000,
"snoRNA"=>5000,
"snRNA"=>1000,
"tRNA"=>1000
);

my %infor2 =();
open(INFL, $ARGV[1]) or die "$!";
while(<INFL>){
  next if (!/transcript/);
#  /type=(.*?);ID=(.*?)[;\n]/;
#  print $1, " ", $2, "\n";
  /type=(.*?)[;\n]/;
  my $type = $1;
  /ID=(.*?)[;\n]/;
  my $name = $1;
  my @t =split /\t/, $_;
  my $d = $t[4]-$t[3];
  if(exists $conds{$type} and $conds{$type}>$d){
    $infor2{$name}=$_;
#    print $_;
  } 

}
close(INFL);
my %infor =();
foreach my $name (keys %infor2){
  my @t=split /\t/, $infor2{$name};
  my($type) = $t[-1] =~ /type=(.*?);/;
  my $range = $t[3]. ",". $t[4];
# type, chr, strand, range
#  print $name, " " , $type, $t[0], " ", $t[6],  " " , $range, "\n";
  $infor{$type}{$t[0]}{$t[6]}{$range}= $name;
}

foreach my $type (keys %infor){
  my $typeid = 0;
  foreach my $chr ( keys %{$infor{$type}}){
    foreach my $strand ( keys %{$infor{$type}{$chr}}){
      my @ranges = keys %{$infor{$type}{$chr}{$strand}};
      my @mergelines=();
      my @lines = sort sortline @ranges;
      $mergelines[0] = $lines[0] . "," . $infor{$type}{$chr}{$strand}{$lines[0]};
      for(my $i=1; $i<@lines; $i++){
        my( $start1, $end1, $id1) = split /,/, $mergelines[-1];
        my ($start2, $end2) = split /,/ , $lines[$i];
        my $id2 = $infor{$type}{$chr}{$strand}{$lines[$i]};
        if(overlap($start1, $end1, $start2, $end2)){
          $mergelines[-1] = min($start1, $start2) . "," . max($end1, $end2) .  "," . $id1 . "||". $id2;
        }else{
          my $l = $start2 . ",". $end2 . "," . $id2;
          push @mergelines,$l;
        }
  
      }

#      my $typeid = 0;
      foreach my $l (@mergelines){
#        print $type, " ", $chr, " ", $strand, " ", $l, "\n";
        my @t=split /,/, $l;
        print $chr, "\t.\t", $type, "_", $typeid++,  "\t", $t[0], "\t", $t[1], "\t.\t", $strand, "\t.\t", "ID=", $t[2], "\n";
      }
    }
 
  }

}

sub sortline{
  my ($starta, $enda) = split /,/, $a;
  my ($startb, $endb) = split /,/, $b;
  $starta <=> $startb;
}

sub overlap {
  my $overlap=1;
  my ($a, $b, $c, $d) =@_;

  if(($a<$c)&&($b<$c)){
    $overlap=0;
  }
  if(($a>$d)&&($b>$d)){
    $overlap=0;

  }
  return $overlap;

}

sub max {
  my ($a, $b) =@_;
  
  if($a >$b){
    return $a;
  }else{
    return $b;
  }
}

sub min {
  my ($a, $b) =@_;
  
  if($a <$b){
    return $a;
  }else{
    return $b;
  }
}

