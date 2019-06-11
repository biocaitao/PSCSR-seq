use strict;

open(INFL, $ARGV[0]) or die "$!";

my @lines =<INFL>;
close(INFL);
for(my $i=0; $i<@lines; $i++){
 for(my $j=$i+1; $j<@lines; $j++){
   if(hd($lines[$i], $lines[$j]) <=1){
     print $lines[$i], $lines[$j], "\n";
   }
 }

}

sub hd {
    return ($_[0] ^ $_[1]) =~ tr/\001-\255//;
}

