# Pre-required enviroment 

a. bowtie (version1, >=1.2.2 ) installed 

b. bowtie reference database 


# the analysis pipeline
#### 1. download raw reads

e.g. 
```bash
> cd comparisons:
> ~/sratoolkit.2.9.6-centos_linux64/bin/prefetch SRR14284465;
> ~/sratoolkit.2.9.6-centos_linux64/bin/fasterq-dump  SRR14284465.sra
```

#### 2. extract sRNAs
e.g.
```bash
> perl parseseq_Hucker.pl  SRR14284465.fastq > SRR14284465.fastq.processed.fa;
> perl  ../extract_sRNA.pl SRR14284465.fastq.processed.fa > SRR14284465.fastq.processed2.fa;
```


#### 3. map reads
e.g.
```bash
> bowtie ../protein_cds --norc -f SRR14284465.fastq.processed2.fa -a -v 0 -m 500 -p 32 --al SRR14284465.matched_protein.fa --un SRR14284465.ncRNA.fa;
> bowtie ../hg38 -f SRR14284465.ncRNA.fa SRR14284465.seq.map -a -v 0 -m 500 -p 32;
```

#### 4. annotate small RNA reads and count ncRNA
e.g.
```bash
> perl  ../filter_ncRNA.pl ../ncRNA.gff3 SRR14284465.seq.map > SRR14284465.ncRNA.map ;
> perl  count_ncRNA2.pl SRR14284465.ncRNA.map > SRR14284465.ncRNA.count;
```

#### 5. calculate the reproducibility
e.g.
```bash
> cut -f 1 SRR14284465.ncRNA.count |sort > SRR14284465.ncRNA.count.sort;
> cut -f 1 SRR14284466.ncRNA.count |sort > SRR14284466.ncRNA.count.sort;
# using comm/uniq command to compare two sorted files
> sh reproducible.sh
```

#### 5. down_sample reads and count miRNAs

```bash
> head -600000 SRR14284465.fastq.processed.fa > SRR14284465.sampling;
> perl   ../extract_sRNA.pl SRR14284465.sampling > SRR14284465.sampling.processed2.fa;
> bowtie ../protein_cds --norc -f SRR14284465.processed2.fa SRR14284465.protein.map -a -v 0 -m 500 -p 32 --al SRR14284465.sampling.matched_protein.fa --un SRR14284465.sampling.ncRNA.fa;
> bowtie ../hg38 -f SRR14284465.sampling.ncRNA.fa SRR14284465.sampling.seq.map -a -v 0 -m 500 -p 32;
> perl  ../filter_ncRNA.pl  ../ncRNA.gff3 SRR14284465.sampling.seq.map > SRR14284465.sampling.ncRNA.map ;
#downsampling 30K, 50K, 100K, 200K, 300K reads and count mirnas;
> perl sampling.pl SRR14284465.sampling.ncRNA.map > sampling.txt;

#similary for PSCSR-seq, we extract raw reads according to cell barcodes and repeat the pipeline
#
```
