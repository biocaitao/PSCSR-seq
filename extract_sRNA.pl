use strict;
open(INFL, $ARGV[0]) or die "perl extract_sRNA.pl processed.fa";
while(<INFL>){
  my $id = <INFL>;
  my $seq = <INFL>;
  my $l = length($seq);
  if( $l>=17 and $l<=27){
    print $id;
    print $seq;
    
  }

}
close(INFL);


