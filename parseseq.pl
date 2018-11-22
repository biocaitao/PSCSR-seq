use strict;

my %wl =();

open(INFL, "whitelist.txt") or die"need whitelist.txt file $!";
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

open(INFL, "zcat $ARGV[0] |") or die "$!";
my $max_distance = 2;
my $seqlen = 79;
my $start =8;
#12 nt for NNNNNNCCCCCC
#10 nt for find2 seq
#18 nt for find1 seq
my $end = $seqlen-12-10-18;
my $find1 = "CTGTAGGCACCATCAATC";
my $find2 = "TGGAATTCTC";

while(<INFL>){
  my $id =  $_;
  my $seq = <INFL>;
  my $t = <INFL>;
  my $q = <INFL>;
  $id=~ s/ (.*)\n//;;
#  print $id, "\t", $seq;
  if($seq=~/$find1?/){
#     print $seq;
     if($-[0]>=$start+2){

     if(hd($find2, substr($seq, $-[0]+30, 10)) < 1){
       my $barcode1 = substr($seq, 0, 6);
       my $um1 = substr($seq, 6, 2);
       my $um2 = substr($seq, $-[0]-2, 2);
       my $um3 = substr($seq, $-[0]+18, 6);
       my $barcode2 = substr($seq, $-[0]+24, 6);
       my $bc = $barcode1 . $barcode2;
              
       if(exists $wl{$bc}){

       print ">", $id, "_";
       print $wl{$bc}, "_", $um1, $um2, $um3, "\n";
       print substr($seq, 8, $-[0]-10), "\n";
       }
#print $seq;
     }

     }
   }else{
    for(my $i=$start+2; $i<=$end ; $i++){
      if(hd($find1, substr($seq, $i, 18))<=$max_distance){
#        print $i, "\t", $id, "\t", $seq, substr($seq, $i+30, 10), "\n";
        
         if(hd($find2, substr($seq, $i+30, 10)) <= 1){
           my $barcode1 = substr($seq, 0, 6);
           my $um1 = substr($seq, 6, 2);
           my $um2 = substr($seq, $i-2, 2);
           my $um3 = substr($seq, $i+18, 6);
           my $barcode2 = substr($seq, $i+24, 6);
           my $bc = $barcode1 . $barcode2;
           if(exists $wl{$bc}){

           print ">", $id, "_";
           print $wl{$bc}, "_", $um1, $um2, $um3, "\n";
           print substr($seq, 8, $i-10), "\n";
           }
         }


        last;
       
      }
     
 
    }
  }


}

close(INFL);


sub hd {
    return ($_[0] ^ $_[1]) =~ tr/\001-\255//;
}
