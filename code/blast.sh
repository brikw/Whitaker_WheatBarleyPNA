#!/bin/bash
#SBATCH --job-name="blast"
#SBATCH --time=1:00:00   # walltime 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32   # 16 processor core(s) per node X 2 threads per core
#SBATCH --partition=short    # partition type
#SBATCH --mail-user=briana.whitaker@usda.gov
#SBATCH --mail-type=FAIL

cd /project/mpm_fhb_genomics/whitaker
date
pwd
module load blast+/2.11.0

makeblastdb -in sh_general_release_dynamic_10.05.2021.fasta -dbtype nucl -title "fungalDB"

blastn -query ./kmers/all_1-75bp_kmers13-17.fasta -db sh_general_release_dynamic_10.05.2021.fasta -word_size 13 -perc_identity 100 -out ./kmers/all_1-75bp_kmers13-17_hits.csv -outfmt '10 std' -num_threads 16

blastn -query ./kmers/Gm_kmers13-17.fasta -db sh_general_release_dynamic_10.05.2021.fasta -word_size 13 -perc_identity 100 -out ./kmers/Gm_kmers13-17_hits.csv -outfmt '10 std' -num_threads 16

blastn -query ./kmers/Hv_kmers13-17.fasta -db sh_general_release_dynamic_10.05.2021.fasta -word_size 13 -perc_identity 100 -out ./kmers/Hv_kmers13-17_hits.csv -outfmt '10 std' -num_threads 16

blastn -query ./kmers/Ta_kmers13-17.fasta -db sh_general_release_dynamic_10.05.2021.fasta -word_size 13 -perc_identity 100 -out ./kmers/Ta_kmers13-17_hits.csv -outfmt '10 std' -num_threads 16

blastn -query ./kmers/Zm_kmers13-17.fasta -db sh_general_release_dynamic_10.05.2021.fasta -word_size 13 -perc_identity 100 -out ./kmers/Zm_kmers13-17_hits.csv -outfmt '10 std' -num_threads 16                                                                                                  

#std='qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore

date

# used this code for blasting whole genomes with reference ITS contig
#gunzip Hvulgare_462_r1.fa.gz
#makeblastdb -in Hvulgare_462_r1.fa -dbtype nucl -title "barleyGenome"
#blastn -query Hv_ncbi_consensus.fasta -db Hvulgare_462_r1.fa -word_size 48 -perc_identity 60 -out Hvulgare_462_r1__queryHv_ncbi_consensus.txt -outfmt '6 std qseqid sseqid pident' -num_threads 16
