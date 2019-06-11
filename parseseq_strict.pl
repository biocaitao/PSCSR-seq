use strict;

my %wl =();
if(@ARGV<2) {
  die "perl parseseq.pl whitelist.txt seq.gz";
}

open(INFL, "$ARGV[0]") or die"need whitelist.txt file $!";
while(<INFL>){
  chomp;
  my @t =split /\t/;
#   print $t[0], "\n";
  $wl{$t[0]}=$t[0];
  my @t2 =split /,/, $t[1];
  foreach my $id (@t2){
#     print $id, "\n";
     $wl{$id}=$t[0];
  }
}
close(INFL);

open(INFL, "zcat $ARGV[1] |") or die "$!";
my $find1 = "GACAGACAAATCACGAAA([ACGT][ACGT])AAA([ACGT][ACGT])AAA([ACGT][ACGT])";
my $find2 = "CTGTAGGCAC";
my $li=0; 
while(<INFL>){
  my $id =  $_;
  $li++;
  my $seq = <INFL>;
  my $t = <INFL>;
  my $q = <INFL>;
  $id=~ s/ (.*)\n//;;
#  print $id, "\t", $seq;
  if($seq=~/$find1?/){
#     print $seq;
     my $p1 = $-[0];
     my $s1 = $+[0];
     
     if(1){
       my $um1 = $1;
       my $um2 = $2;
       my $um3 = $3;

       if( ($seq=~/$find2/ )and ($-[0] < length($seq)-30)) {
         my $um4 = substr($seq, $-[0]-2, 2);
         my $s2 = $-[0]-2 - $s1;
#         print $-[0]-2, " ", $s1, "\n";
         if($s2>=0){
         my $barcode1 = substr($seq, 0, 6);
         my $barcode2 = substr($seq, $-[0]+24, 6);
         my $bc = $barcode1 . $barcode2;

         if(exists $wl{$bc}){

           print ">", $id, "_";
           print $wl{$bc}, "_", $um1, $um2, $um3, $um4 ,"\n";
           print substr($seq, $s1, $s2), "\n";
         }
         }
      
     }

   }
 }

}

close(INFL);
print STDERR "processed $li reads\n";

sub hd {
    return ($_[0] ^ $_[1]) =~ tr/\001-\255//;
}
