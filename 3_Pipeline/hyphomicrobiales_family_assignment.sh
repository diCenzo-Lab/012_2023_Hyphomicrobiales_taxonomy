#!/bin/bash

usage() {
  echo "Usage: hyphomicrobiales_family_assignment.sh -g </path/to/genomes/> -x <extension> -d </path/to/data/> -t <num> -i <num>"
  echo "Required inputs:"
  echo "  -g </path/to/genomes/>:       The full path to the directory containing the genome(s) to be classified. Genomes must be provided as whole genome nucleotide fasta files."
  echo "  -x <extension>:       The extension (e.g., fna, fasta) of the file containing the genome sequence. Generally, this will be either fna or fasta."
  echo "  -d </path/to/genomes/>:       The full path to the data folder provided in the same GitHub repository as this script."
  echo "  -t </path/to/genomes/>:       The number of threads to use for all steps except for IQTREE.\n"
  echo "  -i </path/to/genomes/>:       The number of threads to use for IQTREE. We recommend a a maximum of 8 based on IQTREE multithreading efficiency measured on our computer.\n"
}

# Process command-line options
while getopts g:x:d:t:i: flag
do
  case "${flag}" in
        g) genome_path=${OPTARG};;
        x) extension=${OPTARG};;
        d) data_path=${OPTARG};;
        t) thread_count=${OPTARG};;
        i) iqtree_threads=${OPTARG};;
  esac
done

# Check if required arguments are provided
if [ -z $genome_path ]; then
  echo "\nError: Missing required arguments\n"
  usage
  exit 1
fi
if [ -z $extension ]; then
  echo "\nError: Missing required arguments\n"
  usage
  exit 1
fi
if [ -z $data_path ]; then
  echo "\nError: Missing required arguments\n"
  usage
  exit 1
fi
if [ -z $thread_count ]; then
  echo "\nError: Missing required arguments\n"
  usage
  exit 1
fi
if [ -z $iqtree_threads ]; then
  echo "\nError: Missing required arguments\n"
  usage
  exit 1
fi

# Make directories
mkdir Intermediate_files
mkdir Output_files

# Generate list of query genome sequences
ls "$genome_path"/*."$extension" > Intermediate_files/input_genome_list.txt

# Generate lists of the reference marker protein sequences
ls "$data_path"/core_138/protein_sequences/*.faa > Intermediate_files/core_138_protein_list.txt
ls "$data_path"/perc95_138/protein_sequences/*.faa > Intermediate_files/perc95_138_protein_list.txt

# Generate lists of the reference marker protein alignments
ls "$data_path"/core_138/aligned_sequences/*.faaln > Intermediate_files/core_138_alignment_list.txt
ls "$data_path"/perc95_138/aligned_sequences/*.fasta > Intermediate_files/perc95_138_alignment_list.txt

# Identify the core_138 proteins
mkdir Intermediate_files/core_138_out
mkdir Intermediate_files/core_138_tmp
genome2cpAAI.py -q Intermediate_files/input_genome_list.txt -p Intermediate_files/core_138_protein_list.txt -A Intermediate_files/core_138_alignment_list.txt -o Intermediate_files/core_138_out --tmp_dir Intermediate_files/core_138_tmp --threads $thread_count

# Identify the perc95_138 proteins
mkdir Intermediate_files/perc95_138_out
mkdir Intermediate_files/perc95_138_tmp
genome2cpAAI.py -q Intermediate_files/input_genome_list.txt -p Intermediate_files/perc95_138_protein_list.txt -A Intermediate_files/perc95_138_alignment_list.txt -o Intermediate_files/perc95_138_out --tmp_dir Intermediate_files/perc95_138_tmp --threads $thread_count
grep '>' Intermediate_files/core_138_out/aligned_marker_prot_seqs/aligned_86377_gyrB.faaln | cut -f2 -d'>' | cut -f1 -d' ' | sort -u > Intermediate_files/perc95_138_out/species_list.txt
mkdir Intermediate_files/perc95_138_out/aligned_marker_prot_seqs_trimmed/
trimAlignments.pl
mkdir Intermediate_files/perc95_138_out/aligned_marker_prot_seqs_modified/
modifyAlignments.pl
combineAlignments.pl Intermediate_files/perc95_138_out/species_list.txt Intermediate_files/perc95_138_out/aligned_marker_prot_seqs_modified/ > Intermediate_files/perc95_138_out/concatenated_marker_proteins.aln

# Calculate cpAAI using core_138
Rscript compute_cpAAI.R
mv cpAAI_matrix.txt Output_files/

# Make phylogeny using perc95_138
cd Intermediate_files/perc95_138_out/
iqtree2 -s concatenated_marker_proteins.aln -m LG+F+I+R10 --alrt 1000 -J 1000 --jack-prop 0.4 -T $iqtree_threads --prefix perc95_138_phylogeny
cd ../..
cp Intermediate_files/perc95_138_out/perc95_138_phylogeny.treefile Output_files/ML_phylogeny.treefile
