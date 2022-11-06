use strict;

my %wl =();
if(@ARGV<1) {
  die "perl parseseq.pl seq.fastq";
}

open(INFL, "$ARGV[0]") or die "$!";

my $find2 = "TGGAAT";

my $li=0;
while(<INFL>){
  my $id =  $_;
  my $seq = <INFL>;
  my $t = <INFL>;
  my $q = <INFL>;
  $li++;
  $id=~ s/ (.*)\n//;;
#  print $id, "\t", $seq;
  
       if( ($seq=~/$find2/ )) {

           print ">", $id, "\n";
           print substr($seq, 10, $-[0]-10), "\n";
         }
      

}

close(INFL);
print STDERR "processed $li raw reads\n";

