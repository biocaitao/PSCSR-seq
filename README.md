# Pre-required enviroment 

a. bowtie (version1, >=1.2.2 ) installed 

b. bowtie reference database 


# the analysis pipeline
#### 1. download small RNA annotation database

- protein coding cDNA seq from ENSEMBL database: 
e.g. 
```bash
> wegt ftp://ftp.ensembl.org/pub/release-94/fasta/homo_sapiens/cds/Homo_sapiens.GRCh38.cds.all.fa.gz;  
> gunzip  Homo_sapiens.GRCh38.cds.all.fa.gz;  
> bowtie-build Homo_sapiens.GRCh38.cds.all.fa protein_cds;
```
- miRNA information from miRbase database:
e.g. 
```bash
> wget ftp://mirbase.org/pub/mirbase/CURRENT/genomes/hsa.gff3
> perl convertid.pl hsa.gff3 > hsa_new.gff3
> grep -v pre hsa.gff3 > miRNA.gff3
```
- small RNA from ebi RNAcentral: 
e.g. 
```bash
> wget ftp://ftp.ebi.ac.uk/pub/databases/RNAcentral/current_release/genome_coordinates/gff3/homo_sapiens.GRCh38.gff3.gz ;   
> gunzip homo_sapiens.GRCh38.gff3.gz ; 
```
#### 2. extract the useful information from the original database
e.g.
```bash
> perl filtergff.pl hsa_new.gff3 homo_sapiens.GRCh38.gff3 > ncRNA.gff3 ; 
```

#### 3. extract reads from sequencing files
e.g.

```bash
> perl parseseq.pl Icell8-12_CTTGTA_L002_R1_001.fastq.gz > processed.fa;  
> perl extract_sRNA.pl processed.fa > processed2.fa;
```

#### 4. mapping reads
e.g.
```bash
> bowtie database/protein_cds --norc -f processed2.fa protein.map -a -v 0 -m 500 -p 32 --al matched_protein.fa --un ncRNA.fa;  
> bowtie database/hg38 -f ncRNA.fa seq.map -a -v 0 -m 500 -p 32 --al matched.fa --un unmatched.fa;
```

#### 5. annotate small RNA reads
e.g.
```bash
> perl filter_ncRNA.pl ncRNA.gff3 seq.map > ncRNA.map ; 
```
#### 6. reads count for following analysis
a. sRNA count
```bash
> perl count_ncRNA.pl ncRNA.map  > ncRNA.count ; 
```
b. mature miRNA count
```bash
> perl filter_ncRNA.pl mature_miRNA.gff3 seq.map > miRNA.map ; 
> perl count_miRNA.pl mRNA.map > miRNA.count ; 
> perl perl degenerate.pl  mature.fa  miRNA.count hsa  > miRNA.count.deg ; 
```

#### 7. reads stat for QC
```bash
#CellID, Nraw_reads, NsRNA_reads, Nmapping_reads, Numi_counts
> perl  stat_reads.pl processed.fa  processed2.fa matched.fa > stat_reads.txt;
```

Usually, for 500M raw reads (one HiSeqX10 lane, 150nt single end reads), the pipeline takes about 6 hrs and 90G memory. 

