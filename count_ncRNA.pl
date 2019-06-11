use strict;

if(@ARGV<1) {
  die "perl count_ncRNA.pl ncRNA.map";
}

#count  all;
my %c1 =();
#multireads
my %mr =();
my %mr2 =();

open(INFL, $ARGV[0]) or die "$!";
while(<INFL>){
  chomp;
  my @t =split /\t/;
  my @t2 = split /_/, $t[0];
  $mr{$t[0]} =1;
  $c1{$t[-1]}{$t2[1]}{$t2[2]}=1;
  $mr2{$t2[1]}{$t2[2]}{$t[-1]}=1;
  
}
close(INFL);

my %others=();
open(INFL, "matched.fa") or die "need matched_protein.fa file and match.fa file";
while(<INFL>){
  if (/^>/){
  chomp; 
  my $id = substr($_, 1,length($_));
  if(exists $mr{$id}){
    next;
  }else{
    my @t2 = split /_/, $id;
    $others{$t2[1]}{$t2[2]}=1;
  }
  }
}
close(INFL);

my %protein=();
open(INFL, "matched_protein.fa") or die "need matched_protein.fa file and match.fa file";
while(<INFL>){
  if (/^>/){
   my @t2 = split /_/;
   $protein{$t2[1]}{$t2[2]}=1;
  }
}
close(INFL);

print "gene\tcell\tcount\n";
foreach my $m (keys %c1){
   foreach my $c (keys %{$c1{$m}}){
     print $m, "\t";
     print $c, "\t";
     my $nu = 0;
     my %umis =();
     
     foreach my $u ( keys %{$c1{$m}{$c}} ){
       if(!exists $umis{$u}){
         my $ng= scalar keys %{$mr2{$c}{$u}};
         $nu+= 1/$ng;
         my @misumis = mismatchstr($u);
         $umis{$_}++ for (@misumis);
       }
     }
     print $nu;
     print "\n"; 
   }
}


foreach my $c (keys %others){
   print "others\t", $c, "\t";
   my $nu =0;
   my %umis=();
   foreach  my $u (keys %{$others{$c}}){
     if(!exists $umis{$u}){
       $nu++;
       my @misumis = mismatchstr($u);
       $umis{$_}++ for (@misumis);
     }
   }
   print $nu;
   print "\n";
}

foreach my $c (keys %protein){
   print "protein\t", $c, "\t";
   my $nu =0;
   my %umis=();
   foreach  my $u (keys %{$protein{$c}}){

     if(!exists $umis{$u}){
       $nu++;
       my @misumis = mismatchstr($u);
       $umis{$_}++ for (@misumis);
     }

   }
   print $nu;
   print "\n";
}


sub hd {
    return ($_[0] ^ $_[1]) =~ tr/\001-\255//;
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
