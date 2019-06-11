use strict;

my @barcode1 =("AACCAA",
"TAGTCA",
"CCTAGC",
"AGTCAA",
"CAGGCG",
"CGGAAT",
"GACGAC",
"TCATTC",
"TTCTGA",
"CGATAG",
"ACTGCA",
"CGCAAC",
"AGTTCC",
"CATGGC",
"CTAGCT",
"TAATCG",
"TCCCGA",
"TGGTCC",
"AGAAGA",
"CAGCAT",
"TGGCCT",
"ATGTCA",
"CATTTT",
"CTATAC",
"TACAGC",
"TCGAAG",
"GTTAAG",
"GAGCCT",
"CCGCCT",
"GCGGTT",
"CCGTCC",
"CCAACA",
"CTCAGA",
"TATAAT",
"TCGGCA",
"TCGCGG",
"GTAGAG",
"GTTTCG",
"ACTGAT",
"CAACTA",
"GGAGTT",
"ACTAAG",
"GCAGTC",
"GTATCT",
"AACCTC",
"GTCCGC",
"CGTACG",
"ATGAGC",
"CACCGG",
"CCTTCA",
"GAAGCT",
"GCTCAA",
"GTCATC",
"AACGGT",
"GTGAAA",
"GAGTGG",
"ATTCCT",
"CACGAT",
"CGAATA",
"GACTAT",
"GGATAT",
"TAACGT",
"ACCAGA",
"GTGGCC",
"GGTAGC",
"CAAAAG",
"CACTCA",
"CGGAGA",
"GAGTAA",
"GTAAGA",
"TTACTT",
"AGCGGC"

);
my @barcode2 =("GCGATC",
"TCCTGC",
"AGTGAC",
"ACAGGA",
"CCTCAA",
"GTGGTT",
"ACTAGT",
"TCCATT",
"CGAAGT",
"AACGCT",
"TGGTAT",
"GAACTG",
"ACTTCG",
"CTCACG",
"CAGGAG",
"AAGTTC",
"CCAGTC",
"GTATGC",
"CATTGA",
"GGCTCA",
"ATGCCA",
"CAGATT",
"AGTCTT",
"TCAGCT",
"GTCTAT",
"ATGTGG",
"TACTCG",
"CGTTAG",
"ACCGAG",
"GTTCTC",
"TCGCAC",
"TGCGTA",
"CTACGA",
"TGACTC",
"AGAACA",
"CATCCT",
"GCTGAT",
"AGACGG",
"GTGAAG",
"CTCTTC",
"TGTTCC",
"GAAGCC",
"ACCACC",
"GCGTGA",
"GTGAGT",
"ATCTCT",
"TGTCCT",
"ACGGAT",
"CAACAT",
"GTCGTG",
"AATCTG",
"TACATC",
"AGGTGC",
"CATGGC",
"TTAGCC",
"TCGCTA",
"GAATGA",
"AGCCAA",
"CTCCTT",
"TAAGGT",
"AGGATG",
"TTGTCG",
"GATTAG",
"ATAGAG",
"TGTGTC",
"CAATCC",
"ACCTTA",
"CCTGTT",
"CACTGT",
"CTAACT",
"ATTCAT",
"TCTTGG"
);
if(1){
foreach my $a (@barcode1){
  foreach my $b(@barcode2){
    my $t = $a . $b;
    my @ts = mismatchstr($t);
    print $a, $b,"\t", join(",", @ts),  "\n";
  }

}
}else{
  open(INFL,  "temp") or die "$!";
  while(<INFL>){
    chomp; 
    my @ts =  mismatchstr($_);
    print $_,"\t", join(",", @ts),  "\n";


  }
  close(INFL);


}



my @dict =("A", "G", "C", "T", "N");
sub mismatchstr2 {
  my($str,$s ) = @_;
  if(length($str)==1){
   
    my @t = grep {$str ne $_} @dict;
    foreach my $i (@t){
      print $s, $i,"\n";
    }
  }else{
    my $e = substr($str, 0, 1);
    my @t =grep {$e ne $_} @dict;
    foreach my $i (@t){
      $a = $s.$i;
#      print $a;
      my $l = substr($str, 1, length($str)-1);
      mismatchstr($l, $a)

    }

  }
  

}

sub mismatchstr {
my ($test) =@_;
my @str =split //, $test;
my @str2 =();
my @dict = ("A", "G", "C", "T", "N");;
for(my $i=0; $i<@str; $i++){
  my @t = grep {$str[$i] ne $_} @dict;
  foreach my $e (@t){
   
    my @s = @str;
    $s[$i] = $e;
    my $s2 = join("", @s);
    push @str2, $s2;
  }

}
return @str2;
}


