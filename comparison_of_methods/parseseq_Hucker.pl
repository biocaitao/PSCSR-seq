use strict;

my %wl =();
if(@ARGV<1) {
  die "perl parseseq.pl seq.fastq";
}

open(INFL, "$ARGV[0]") or die "$!";

#the modification of adapters sound to induce some sequencing errors. 
#cut additional nt to remove adapters completely
my $find2 = "[ACGT]TGGAATTC";

my $li=0;
while(<INFL>){
  my $id =  $_;
  my $seq = <INFL>;
  my $t = <INFL>;
  my $q = <INFL>;
  $li++;
  $id=~ s/ (.*)\n//;;
#  print $id, "\t", $seq;
  
       if( ($seq=~/$find2/ ) ) {
           if($-[0] >=10){
           print ">", $id, "\n";
           print substr($seq, 10, $-[0]-10), "\n";
           }else{
           print ">", $id, "\n";
           print  "\n";


           }
       }elsif(/TGGAATTC/){
           print ">", $id, "\n";
           print "\n";
       }
        
      

}

close(INFL);
print STDERR "processed $li raw reads\n";

