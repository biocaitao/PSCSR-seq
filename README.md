# Pre-required enviroment 

a. bowtie (version1, >=1.2.2 ) installed 

b. bowtie reference database </p>


# the analysis pipeline
1. download small RNA annotation database

protein coding cDNA seq from ENSEMBL database:

i.e. 

wegt ftp://ftp.ensembl.org/pub/release-94/fasta/homo_sapiens/cds/Homo_sapiens.GRCh38.cds.all.fa.gz; 

gunzip  Homo_sapiens.GRCh38.cds.all.fa.gz; 

bowtie-build Homo_sapiens.GRCh38.cds.all.fa protein_cds;

miRNA information from miRbase database:

i.e. 

wget ftp://mirbase.org/pub/mirbase/CURRENT/genomes/hsa.gff3

small RNA from ebi RNAcentral

i.e. 

wget ftp://ftp.ebi.ac.uk/pub/databases/RNAcentral/current_release/genome_coordinates/gff3/homo_sapiens.GRCh38.gff3.gz ; 

gunzip homo_sapiens.GRCh38.gff3.gz ; 

2. extract the useful information from the original database

perl filtergff.pl hsa.gff3 homo_sapiens.GRCh38.gff3.gz > ncRNA.gff3 ; 

3. extract reads from sequencing files

i.e.

perl parseseq.pl Icell8-12_CTTGTA_L002_R1_001.fastq.gz > processed.fa;

perl extract_sRNA.pl processed.fa > processed2.fa;

4. mapping reads

bowtie database/protein_cds --norc -f processed2.fa protein.map -a -v 0 -m 500 -p 32 --al matched_protein.fa --un ncRNA.fa;

bowtie database/hg38 -f ncRNA.fa seq.map -a -v 0 -m 500 -p 32 --al matched.fa --un unmatched.fa;

5. annotate small RNA reads

perl filter_ncRNA.pl ncRNA.gff3 seq.map > ncRNA.map ; 

6. reads count for following analysis

perl count_count.pl protein.map ncRNA.map seq.map > ncRNA.count ; 


