use strict;
open(INFL, $ARGV[0]) or die "perl extract_sRNA.pl processed.fa";
while(<INFL>){
  my $id = $_;
  my $seq = <INFL>;
  my $l = length($seq);
#  print $id, $seq, "\n";
  if( $l>=15 and $l<=39){
    print $id;
    print $seq;
    
  }

}
close(INFL);


