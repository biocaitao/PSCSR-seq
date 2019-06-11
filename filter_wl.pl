open(INFL, "$ARGV[0]") or die"need whitelist.txt file $!";
my %bc = ();

while(<INFL>){
  chomp;
  my @t =split /\t/;
#  print $t[0], "\n";
  $bc{$t[0]}=1;
}

close(INFL);


open(INFL, "$ARGV[0]") or die"need whitelist.txt file $!";
while(<INFL>){
  chomp;
  my @t =split /\t/;
  print $t[0], "\t";
  my @t2 =split /,/, $t[1];
  foreach my $id (@t2){
    if(! exists $bc{$id}){
     print $id, ",";
    }
  }
  print "\n";
}
close(INFL);
