
c=0
for file in `ls *.sort`
do
  fs[$c]=$file
  ((c++))

done


for(( i=0;i<${#fs[@]}-1;i++)) do

  for(( j=i+1;j<${#fs[@]};j++)) do
    echo ${fs[i]};
    echo ${fs[j]};

    comm -12 ${fs[i]}  ${fs[j]} |wc -l

   cat  ${fs[i]} ${fs[j]} |sort|uniq|wc -l

  done;
done;


