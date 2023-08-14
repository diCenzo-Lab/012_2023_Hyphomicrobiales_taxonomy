# Download the genomes
mkdir Output/ # Make an output directory
mkdir Genome_files/ # Make directory to hold genome files
perl Scripts/parseGenomeList.pl Input_files/Phyllobacteriaceae.txt # Parse the NCBI genome table to get info to download genomes
sed -i 's/_type_strain://' Input_files/genomeList.txt # Fix formatting of one strain
sed -i "s/\t/_T\t/" Input_files/genomeList.txt # Add the T for type strain
sort -u Input_files/genomeList.txt > tmp.txt # Sort the genome list
mv tmp.txt Input_files/genomeList.txt # Move the file
perl Scripts/downloadGenomes.pl Input_files/genomeList.txt # Download the genomes of interest
mkdir Genome_files_modified/ # Make directory to hold modified genomes
perl Scripts/fixOrganism.pl Input_files/genomeList.txt # Fix the organism field of the GenBank files
rm -r Genome_files/ # Remove original genome files
mv Genome_files_modified/ Genome_files/ # Rename folder





# Run get_homologues and get the consensus core genome
get_homologues.pl -n 32 -e -d Genome_files # Run get_homologues using the BDBH algorithm 
get_homologues.pl -n 32 -G -e -d Genome_files # Run get_homologues using the COGtriangles algorithm
get_homologues.pl -n 32 -M -e -d Genome_files # Run get_homologues using the OMCL algorithm
cd Genome_files_homologues/ # Change directory
find . -type d # List the directories and modify the following code accordingly
compare_clusters.pl -d BartonellabacilliformisKC583T_f0_alltaxa_algBDBH_e1_,BartonellabacilliformisKC583T_f0_alltaxa_algCOG_e1_,BartonellabacilliformisKC583T_f0_alltaxa_algOMCL_e1_ -o core_58 -t 58 -n # Identify the core genome and get gene sequences
compare_clusters.pl -d BartonellabacilliformisKC583T_f0_alltaxa_algBDBH_e1_,BartonellabacilliformisKC583T_f0_alltaxa_algCOG_e1_,BartonellabacilliformisKC583T_f0_alltaxa_algOMCL_e1_ -o core_58 -t 58 # Identify the core genome and get the protein sequences
cd core_58/ # Change directory
run_get_phylomarkers_pipeline.sh -R 1 -t PROT -n 16 -A I -I 8 # Get the marker proteins and concatenated alignment
cd ../../ # Change directory





# Run get_homologues and get the consensus core genome using gene presence threshold of 95%
get_homologues.pl -n 32 -e -d Genome_files -t 56 # Run get_homologues using the BDBH algorithm 
get_homologues.pl -n 32 -G -e -d Genome_files -t 56 # Run get_homologues using the COGtriangles algorithm
get_homologues.pl -n 32 -M -e -d Genome_files -t 56 # Run get_homologues using the OMCL algorithm
cd Genome_files_homologues/ # Change directory
find . -type d # List the directories and modify the following code accordingly
compare_clusters.pl -d BartonellabacilliformisKC583T_f0_56taxa_algBDBH_e1_,BartonellabacilliformisKC583T_f0_56taxa_algCOG_e1_,BartonellabacilliformisKC583T_f0_56taxa_algOMCL_e1_ -o core_56 -t 56 -n # Identify the core genome and get gene sequences
compare_clusters.pl -d BartonellabacilliformisKC583T_f0_56taxa_algBDBH_e1_,BartonellabacilliformisKC583T_f0_56taxa_algCOG_e1_,BartonellabacilliformisKC583T_f0_56taxa_algOMCL_e1_ -o core_56 -t 56 # Identify the core genome and get the protein sequences
cd core_56/ # Change directory
mkdir get_homologues_output_protein/ # Make directory for the get_homologues protein output
mkdir get_homologues_output_nucleotide/ # Make directory for the get_homologues nucleotide output
mv *faa get_homologues_output_protein/ # Move the protein files
mv *fna get_homologues_output_nucleotide/ # Move the nucleotide files
mkdir get_homologues_output_protein_renamed/ # Make directory for the get_homologues protein output
mkdir Mafft/ # Make folder for the mafft alignmnets
mkdir Trimal/ # Make folder for the trimmed alignments
mkdir TrimalModified/ # Make folder for modified trimmed alignments
cp ../../Input_files/genomeList.txt . # Get genomeList.txt file
perl ../../Scripts/rename_clusters.pl # Rename the proteins in preparation of combining alignments
perl ../../Scripts/align_trim.pl # Run mafft and trimal on all individual sets of proteins
perl ../../Scripts/modifyTrimal.pl # Modify the trimal files for concatenation
perl ../../Scripts/combineAlignments.pl > concatenated_alignment.fasta # Concatenate the alignment files
mkdir MafftModified
perl ../../Scripts/modifyMafft.pl # Modify the mafft files for concatenation
perl ../../Scripts/combineAlignments_mafft.pl > concatenated_alignment.untrimmed.fasta # Concatenate the alignment files
cd ../../ # Change directory





# Run get_homologues and get the consensus core genome without the two genomes missing >10% of genes
get_homologues.pl -n 32 -e -d Genome_files -t 56 # Run get_homologues using the BDBH algorithm 
get_homologues.pl -n 32 -G -e -d Genome_files -t 56 # Run get_homologues using the COGtriangles algorithm
get_homologues.pl -n 32 -M -e -d Genome_files -t 56 # Run get_homologues using the OMCL algorithm
mkdir Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algBDBH_e1_reduced/ # Make directory to hold cleaned clusters
mkdir Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algCOG_e1_reduced/ # Make directory to hold cleaned clusters
mkdir Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algOMCL_e1_reduced/ # Make directory to hold cleaned clusters
perl Scripts/extractClusters.pl Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algBDBH_e1_ /workingdisk1/George/1_Rhizobiales/2_Phyllobacteriaceae/Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algBDBH_e1_reduced/ 56 # Extract clusters without reduced genomes
perl Scripts/extractClusters.pl Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algCOG_e1_ /workingdisk1/George/1_Rhizobiales/2_Phyllobacteriaceae/Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algCOG_e1_reduced/ 56 # Extract clusters without reduced genomes
perl Scripts/extractClusters.pl Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algOMCL_e1_ /workingdisk1/George/1_Rhizobiales/2_Phyllobacteriaceae/Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algOMCL_e1_reduced/ 56 # Extract clusters without reduced genomes
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algBDBH_e1_ Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algBDBH_e1_full # Rename original clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algCOG_e1_ Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algCOG_e1_full # Rename original clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algOMCL_e1_ Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algOMCL_e1_full # Rename original clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algBDBH_e1_reduced Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algBDBH_e1_ # Rename folders containing the clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algCOG_e1_reduced Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algCOG_e1_ # Rename folders containing the clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algOMCL_e1_reduced Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algOMCL_e1_ # Rename folders containing the clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algBDBH_e1_.cluster_list Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algBDBH_e1_full.cluster_list # Rename the now outdated cluster lists
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algCOG_e1_.cluster_list Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algCOG_e1_full.cluster_list # Rename the now outdated cluster lists
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algOMCL_e1_.cluster_list Genome_files_homologues/BartonellabacilliformisKC583T_f0_56taxa_algOMCL_e1_full.cluster_list # Rename the now outdated cluster lists
cd Genome_files_homologues/ # Change directory
find . -type d # List the directories and modify the following code accordingly
compare_clusters.pl -d BartonellabacilliformisKC583T_f0_56taxa_algBDBH_e1_,BartonellabacilliformisKC583T_f0_56taxa_algCOG_e1_,BartonellabacilliformisKC583T_f0_56taxa_algOMCL_e1_ -o core_56B -n # Identify the core genome and get gene sequences
compare_clusters.pl -d BartonellabacilliformisKC583T_f0_56taxa_algBDBH_e1_,BartonellabacilliformisKC583T_f0_56taxa_algCOG_e1_,BartonellabacilliformisKC583T_f0_56taxa_algOMCL_e1_ -o core_56B # Identify the core genome and get the protein sequences
cd core_56B/ # Change directory
run_get_phylomarkers_pipeline.sh -R 1 -t PROT -n 16 -A I -I 8 # Get the marker proteins and concatenated alignment
cd ../../ # Change directory





# Run get_homologues and get the consensus core genome without the two genomes missing lots of genes and using gene presence threshold of 95%
get_homologues.pl -n 32 -e -d Genome_files -t 54 # Run get_homologues using the BDBH algorithm 
get_homologues.pl -n 32 -G -e -d Genome_files -t 54 # Run get_homologues using the COGtriangles algorithm
get_homologues.pl -n 32 -M -e -d Genome_files -t 54 # Run get_homologues using the OMCL algorithm
mkdir Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algBDBH_e1_reduced/ # Make directory to hold cleaned clusters
mkdir Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algCOG_e1_reduced/ # Make directory to hold cleaned clusters
mkdir Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algOMCL_e1_reduced/ # Make directory to hold cleaned clusters
perl Scripts/extractClusters_2.pl Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algBDBH_e1_ /workingdisk1/George/1_Rhizobiales/2_Phyllobacteriaceae/Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algBDBH_e1_reduced/ 54 # Extract clusters without reduced genomes
perl Scripts/extractClusters_2.pl Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algCOG_e1_ /workingdisk1/George/1_Rhizobiales/2_Phyllobacteriaceae/Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algCOG_e1_reduced/ 54 # Extract clusters without reduced genomes
perl Scripts/extractClusters_2.pl Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algOMCL_e1_ /workingdisk1/George/1_Rhizobiales/2_Phyllobacteriaceae/Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algOMCL_e1_reduced/ 54 # Extract clusters without reduced genomes
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algBDBH_e1_ Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algBDBH_e1_full # Rename original clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algCOG_e1_ Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algCOG_e1_full # Rename original clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algOMCL_e1_ Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algOMCL_e1_full # Rename original clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algBDBH_e1_reduced Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algBDBH_e1_ # Rename folders containing the clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algCOG_e1_reduced Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algCOG_e1_ # Rename folders containing the clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algOMCL_e1_reduced Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algOMCL_e1_ # Rename folders containing the clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algBDBH_e1_.cluster_list Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algBDBH_e1_full.cluster_list # Rename the now outdated cluster lists
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algCOG_e1_.cluster_list Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algCOG_e1_full.cluster_list # Rename the now outdated cluster lists
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algOMCL_e1_.cluster_list Genome_files_homologues/BartonellabacilliformisKC583T_f0_54taxa_algOMCL_e1_full.cluster_list # Rename the now outdated cluster lists
cd Genome_files_homologues/ # Change directory
find . -type d # List the directories and modify the following code accordingly
compare_clusters.pl -d BartonellabacilliformisKC583T_f0_54taxa_algBDBH_e1_,BartonellabacilliformisKC583T_f0_54taxa_algCOG_e1_,BartonellabacilliformisKC583T_f0_54taxa_algOMCL_e1_ -o core_54 -n # Identify the core genome and get gene sequences
compare_clusters.pl -d BartonellabacilliformisKC583T_f0_54taxa_algBDBH_e1_,BartonellabacilliformisKC583T_f0_54taxa_algCOG_e1_,BartonellabacilliformisKC583T_f0_54taxa_algOMCL_e1_ -o core_54 # Identify the core genome and get the protein sequences
cd core_54/ # Change directory
mkdir get_homologues_output_protein/ # Make directory for the get_homologues protein output
mkdir get_homologues_output_nucleotide/ # Make directory for the get_homologues nucleotide output
mv *faa get_homologues_output_protein/ # Move the protein files
mv *fna get_homologues_output_nucleotide/ # Move the nucleotide files
mkdir get_homologues_output_protein_renamed/ # Make directory for the get_homologues protein output
mkdir Mafft/ # Make folder for the mafft alignmnets
mkdir Trimal/ # Make folder for the trimmed alignments
mkdir TrimalModified/ # Make folder for modified trimmed alignments
cp ../../Input_files/genomeList.txt . # Get genomeList.txt file
grep -v 'Chenggangzhangella' genomeList.txt | grep -v 'Liberibacter' | grep -v 'Methylobrevis' | grep -v 'Methyloligella' | grep -v 'Nitratireductor' > genomeList_reduced.txt
mv genomeList_reduced.txt genomeList.txt
perl ../../Scripts/rename_clusters.pl # Rename the proteins in preparation of combining alignments
perl ../../Scripts/align_trim.pl # Run mafft and trimal on all individual sets of proteins
perl ../../Scripts/modifyTrimal.pl # Modify the trimal files for concatenation
perl ../../Scripts/combineAlignments.pl > concatenated_alignment.fasta # Concatenate the alignment files
mkdir MafftModified
perl ../../Scripts/modifyMafft.pl # Modify the mafft files for concatenation
perl ../../Scripts/combineAlignments_mafft.pl > concatenated_alignment.untrimmed.fasta # Concatenate the alignment files
cd ../../ # Change directory





# Recreate the core_58 phylogeny with an independent IQ-TREE run with jackkniving
mkdir Phylogeny/ # Make directory for the phylogeny output
mkdir Phylogeny/core_58/ # Make directory for the phylogeny with all 105 strains
tar -xvzf Genome_files_homologues/core_58/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/PhiPack/non_recomb_FAA_alns/top_*_markers_ge70perc/concatenated_alignment_files.tgz -C Genome_files_homologues/core_58/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/PhiPack/non_recomb_FAA_alns/top_*_markers_ge70perc/ # Uncompress alignment file
cp Genome_files_homologues/core_58/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/PhiPack/non_recomb_FAA_alns/top_*_markers_ge70perc/concat_protAlns.faainf Phylogeny/core_58/concat_protAlns.faainf # Get the trimmed alignment from get_phylomarkers
cd Phylogeny/core_58/ # Change directory
ls -1 ../../Genome_files/ | sed 's/.gbff//' > strain_names.txt # Get the strain names and fix the naming of one strain
paste ../../Genome_files_homologues/core_58/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/tree_labels.list strain_names.txt > numbered_strain_list.txt # Pair the numbers with the strain names
perl ../../Scripts/fix_alignment_headers.pl numbered_strain_list.txt concat_protAlns.faainf > concat_protAlns.species.faainf # Replace the numbers with the species name
iqtree2 -s concat_protAlns.species.faainf -m MF --mset LG -T 16 --prefix Phyllobacteriaceae_model # Determine the best fit model and use it for the next step
best_model=$(grep 'Best-fit' Phyllobacteriaceae_model.log | cut -f3 -d' ')
echo $best_model #LG+F+R6
iqtree2 -s concat_protAlns.species.faainf -m $best_model --alrt 1000 -J 1000 --jack-prop 0.4 -T 16 --prefix Phyllobacteriaceae_phylogeny # Create the final phylogeny
cd ../../ # Change directory
cp Phylogeny/core_58/Phyllobacteriaceae_phylogeny.treefile Output/Phyllobacteriaceae_phylogeny_58.treefile # Copy file to final output folder





# Create a core_56 phylogeny
mkdir Phylogeny/core_56/ # Make directory for the 95% phylogeny
cp Genome_files_homologues/core_56/concatenated_alignment.fasta Phylogeny/core_56/ # Get the alignment
cd Phylogeny/core_56/ # Change directory
iqtree2 -s concatenated_alignment.fasta -m MF --mset LG -T 16 --prefix Phyllobacteriaceae_expanded_model # Determine the best fit model and use it for the next step
best_model=$(grep 'Best-fit' Phyllobacteriaceae_expanded_model.log | cut -f3 -d' ')
echo $best_model #LG+F+R8
iqtree2 -s concatenated_alignment.fasta -m $best_model --alrt 1000 -J 1000 --jack-prop 0.4 -T 16 --prefix Phyllobacteriaceae_expanded_phylogeny # Create the final phylogeny
cd ../.. # Change directory
cp Phylogeny/core_56/Phyllobacteriaceae_expanded_phylogeny.treefile Output/Phyllobacteriaceae_phylogeny_56.treefile # Copy file to final output folder





# Recreate the core_56B phylogeny with an independent IQ-TREE run with jackkniving
mkdir Phylogeny/core_56B/ # Make directory for the phylogeny with just the 103 strains
tar -xvzf Genome_files_homologues/core_56B/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/PhiPack/non_recomb_FAA_alns/top_*_markers_ge70perc/concatenated_alignment_files.tgz -C Genome_files_homologues/core_56B/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/PhiPack/non_recomb_FAA_alns/top_*_markers_ge70perc/ # Uncompress alignment file
cp Genome_files_homologues/core_56B/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/PhiPack/non_recomb_FAA_alns/top_*_markers_ge70perc/concat_protAlns.faainf Phylogeny/core_56B/concat_protAlns.faainf # Get the trimmed alignment from get_phylomarkers
cd Phylogeny/core_56B/ # Change directory
ls -1 ../../Genome_files/ | sed 's/.gbff//' | grep -v 'Chenggangzhangella' | grep -v 'Liberibacter' | grep -v 'Methylobrevis' | grep -v 'Methyloligella' | grep -v 'Nitratireductor' > strain_names.txt # Get the strain names and fix the naming of one strain
paste ../../Genome_files_homologues/core_56B/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/tree_labels.list strain_names.txt > numbered_strain_list.txt # Pair the numbers with the strain names
perl ../../Scripts/fix_alignment_headers.pl numbered_strain_list.txt concat_protAlns.faainf > concat_protAlns.species.faainf # Replace the numbers with the species name
iqtree2 -s concat_protAlns.species.faainf -m MF --mset LG -T 16 --prefix Phyllobacteriaceae_reduced_model # Determine the best fit model and use it for the next step
best_model=$(grep 'Best-fit' Phyllobacteriaceae_reduced_model.log | cut -f3 -d' ')
echo $best_model #LG+F+R5
iqtree2 -s concat_protAlns.species.faainf -m $best_model --alrt 1000 -J 1000 --jack-prop 0.4 -T 16 --prefix Phyllobacteriaceae_reduced_phylogeny # Create the final phylogeny
cd ../../ # Change directory
cp Phylogeny/core_56B/Phyllobacteriaceae_reduced_phylogeny.treefile Output/Phyllobacteriaceae_phylogeny_56B.treefile # Copy file to final output folder





# Create a core_54 phylogeny
mkdir Phylogeny/core_54/ # Make directory for the 95% phylogeny
cp Genome_files_homologues/core_54/concatenated_alignment.fasta Phylogeny/core_54/ # Get the alignment
cd Phylogeny/core_54/ # Change directory
iqtree2 -s concatenated_alignment.fasta -m MF --mset LG -T 16 --prefix Phyllobacteriaceae_expanded_model # Determine the best fit model and use it for the next step
best_model=$(grep 'Best-fit' Phyllobacteriaceae_expanded_model.log | cut -f3 -d' ')
echo $best_model #LG+F+R8
iqtree2 -s concatenated_alignment.fasta -m $best_model --alrt 1000 -J 1000 --jack-prop 0.4 -T 16 --prefix Phyllobacteriaceae_expanded_phylogeny # Create the final phylogeny
cd ../.. # Change directory
cp Phylogeny/core_54/Phyllobacteriaceae_expanded_phylogeny.treefile Output/Phyllobacteriaceae_phylogeny_54.treefile # Copy file to final output folder





# Perform cpAAI using the same core protein dataset
mkdir cpAAI_analysis/ # Make a directory for the cpAAI analysis
mkdir cpAAI_analysis/cpAAI_reference/ # Make a directory to hold the reference proteins
mkdir cpAAI_analysis/cpAAI_reference/get_homologues_output_protein/ # Make a directory to hold the reference proteins
mkdir cpAAI_analysis/cpAAI_reference/get_homologues_output_protein_renamed/ # Make a directory to hold the reference proteins
mkdir cpAAI_analysis/new_genomes/ # Make directory to hold the nucleotide fasta file for the new genomes
mkdir cpAAI_analysis/genome2cpAAI_out/ # Make a directory to hold the genome2cpAAI output data
grep '=' ../1_Rhizobiales/Genome_files_homologues/core_138/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_08Jul23/PhiPack/non_recomb_FAA_alns/top_59_markers_ge70perc/concatenation_coordinates.txt | cut -f1 -d'_' | sed 's/faaln/faa/' | sed 's/_cluo//' > Input_files/cpAAI_reference_set.txt # Get list of the core_138 core proteins
cat Input_files/cpAAI_reference_set.txt | while read line # Copy the reference proteins
do
    cp ../1_Rhizobiales/Genome_files_homologues/core_138/"$line"*.faa cpAAI_analysis/cpAAI_reference/get_homologues_output_protein/
done
cd cpAAI_analysis/cpAAI_reference/ # Change directory
perl ../../Scripts/rename_clusters.pl # Rename the proteins in preparation of combining alignments
cd ../../ # Change directory
grep 'Bartonella' Input_files/genomeList.txt | grep -v 'bac' > Input_files/newGenomes.txt # Get list of just the new genomes
grep 'Flavimaribacter' Input_files/genomeList.txt >> Input_files/newGenomes.txt # Get list of just the new genomes
perl Scripts/downloadGenomes_fna.pl Input_files/newGenomes.txt # Download the genomes of interest
mv Genome_files/*.fna cpAAI_analysis/new_genomes/ # Move the genomic fasta files
file cpAAI_analysis/new_genomes/*.fna | cut -f1 -d':' > Input_files/genome_file_list.txt # Get list of nucleotide fasta files
file cpAAI_analysis/cpAAI_reference/get_homologues_output_protein_renamed/*.faa | cut -f1 -d':' > Input_files/cpAAI_reference_file_list.txt # Get list of protein reference files
file cpAAI_analysis/cpAAI_reference/aligned_reference_set_renamed/*.faaln | cut -f1 -d':' > Input_files/cpAAI_reference_alignment_file_list.txt # Get list of protein reference files
mkdir tmp/ # Make temporary directory
python Scripts/genome2cpAAI.py -q Input_files/genome_file_list.txt -p Input_files/cpAAI_reference_file_list.txt -o cpAAI_analysis/genome2cpAAI_out --threads 16 --tmp_dir tmp --aligner clustalo
rm -r tmp





# Calculate cpAAI from the core_58 marker proteins
cp Genome_files_homologues/core_58/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/PhiPack/non_recomb_FAA_alns/top_*_markers_ge70perc/concat_protAlns.faa Output/Rhizobiales_alignment_58.faa # Get untrimmed alignment
perl Scripts/fix_alignment_headers.pl Phylogeny/core_58/numbered_strain_list.txt Output/Rhizobiales_alignment_58.faa > temp.faa # Fix headers
mv temp.faa Output/Rhizobiales_alignment_58.faa # Rename file
Rscript Scripts/cpAAI_figures_58.r # Make heatmaps
Rscript Scripts/cpAAI_figures_58_mixed.r # Make heatmaps
sed -i 's/\"//g' Output/rooted_cpAAI_58_matrix.txt
sed -i 's/ /\t/g' Output/rooted_cpAAI_58_matrix.txt
cat <(echo -ne '\t') Output/rooted_cpAAI_58_matrix.txt > temp.txt
mv temp.txt Output/rooted_cpAAI_58_matrix.txt
sed -i 's/\"//g' Output/rooted_cpAAI_58_mixed_matrix.txt
sed -i 's/ /\t/g' Output/rooted_cpAAI_58_mixed_matrix.txt
cat <(echo -ne '\t') Output/rooted_cpAAI_58_mixed_matrix.txt > temp.txt
mv temp.txt Output/rooted_cpAAI_58_mixed_matrix.txt
perl Scripts/extractAAI.pl Output/rooted_cpAAI_58_matrix.txt > Output/cpAAI_58_list.txt


