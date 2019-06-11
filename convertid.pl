use strict;

open(INFL, $ARGV[0]) or die "$!";
while(<INFL>){
  next if(/^#/);
  my @t=split /\t/;
  $t[0] =~s/chr//;
  my($id) = $t[-1]=~/Name=(.*?)(\n|\;)/;
#  print $id, "\n";
  if($t[2] =~/transcript/){
    $t[2] = "pre_" . $id;
  }else{
    $t[2] = $id;
  }
  print join("\t", @t);

}
close(INFL);

