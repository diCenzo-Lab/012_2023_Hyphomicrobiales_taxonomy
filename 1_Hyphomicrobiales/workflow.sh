# Download the genomes
mkdir Output/ # Make an output directory
mkdir Genome_files/ # Make directory to hold genome files
perl Scripts/parseGenomeList.pl Input_files/Rhizobiales.txt # Parse the NCBI genome table to get info to download genomes
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
compare_clusters.pl -d BartonellabacilliformisKC583T_f0_alltaxa_algBDBH_e1_,BartonellabacilliformisKC583T_f0_alltaxa_algCOG_e1_,BartonellabacilliformisKC583T_f0_alltaxa_algOMCL_e1_ -o core_143 -t 143 -n # Identify the core genome and get gene sequences
compare_clusters.pl -d BartonellabacilliformisKC583T_f0_alltaxa_algBDBH_e1_,BartonellabacilliformisKC583T_f0_alltaxa_algCOG_e1_,BartonellabacilliformisKC583T_f0_alltaxa_algOMCL_e1_ -o core_143 -t 143 # Identify the core genome and get the protein sequences
cd core_143/ # Change directory
run_get_phylomarkers_pipeline.sh -R 1 -t PROT -n 16 -A I # Get the marker proteins and concatenated alignment
cd ../../ # Change directory





# Run get_homologues and get the consensus core genome using gene presence threshold of 95%
get_homologues.pl -n 32 -e -d Genome_files -t 136 # Run get_homologues using the BDBH algorithm 
get_homologues.pl -n 32 -G -e -d Genome_files -t 136 # Run get_homologues using the COGtriangles algorithm
get_homologues.pl -n 32 -M -e -d Genome_files -t 136 # Run get_homologues using the OMCL algorithm
cd Genome_files_homologues/ # Change directory
find . -type d # List the directories and modify the following code accordingly
compare_clusters.pl -d BartonellabacilliformisKC583T_f0_136taxa_algBDBH_e1_,BartonellabacilliformisKC583T_f0_136taxa_algCOG_e1_,BartonellabacilliformisKC583T_f0_136taxa_algOMCL_e1_ -o core_136 -t 136 -n # Identify the core genome and get gene sequences
compare_clusters.pl -d BartonellabacilliformisKC583T_f0_136taxa_algBDBH_e1_,BartonellabacilliformisKC583T_f0_136taxa_algCOG_e1_,BartonellabacilliformisKC583T_f0_136taxa_algOMCL_e1_ -o core_136 -t 136 # Identify the core genome and get the protein sequences
cd core_136/ # Change directory
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





# Run get_homologues and get the consensus core genome without the five genomes missing >10% of genes
get_homologues.pl -n 32 -e -d Genome_files -t 138 # Run get_homologues using the BDBH algorithm 
get_homologues.pl -n 32 -G -e -d Genome_files -t 138 # Run get_homologues using the COGtriangles algorithm
get_homologues.pl -n 32 -M -e -d Genome_files -t 138 # Run get_homologues using the OMCL algorithm
mkdir Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algBDBH_e1_reduced/ # Make directory to hold cleaned clusters
mkdir Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algCOG_e1_reduced/ # Make directory to hold cleaned clusters
mkdir Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algOMCL_e1_reduced/ # Make directory to hold cleaned clusters
perl Scripts/extractClusters.pl Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algBDBH_e1_ /workingdisk1/George/1_Rhizobiales/1_Rhizobiales/Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algBDBH_e1_reduced/ 138 # Extract clusters without reduced genomes
perl Scripts/extractClusters.pl Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algCOG_e1_ /workingdisk1/George/1_Rhizobiales/1_Rhizobiales/Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algCOG_e1_reduced/ 138 # Extract clusters without reduced genomes
perl Scripts/extractClusters.pl Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algOMCL_e1_ /workingdisk1/George/1_Rhizobiales/1_Rhizobiales/Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algOMCL_e1_reduced/ 138 # Extract clusters without reduced genomes
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algBDBH_e1_ Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algBDBH_e1_full # Rename original clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algCOG_e1_ Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algCOG_e1_full # Rename original clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algOMCL_e1_ Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algOMCL_e1_full # Rename original clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algBDBH_e1_reduced Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algBDBH_e1_ # Rename folders containing the clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algCOG_e1_reduced Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algCOG_e1_ # Rename folders containing the clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algOMCL_e1_reduced Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algOMCL_e1_ # Rename folders containing the clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algBDBH_e1_.cluster_list Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algBDBH_e1_full.cluster_list # Rename the now outdated cluster lists
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algCOG_e1_.cluster_list Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algCOG_e1_full.cluster_list # Rename the now outdated cluster lists
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algOMCL_e1_.cluster_list Genome_files_homologues/BartonellabacilliformisKC583T_f0_138taxa_algOMCL_e1_full.cluster_list # Rename the now outdated cluster lists
cd Genome_files_homologues/ # Change directory
find . -type d # List the directories and modify the following code accordingly
compare_clusters.pl -d BartonellabacilliformisKC583T_f0_138taxa_algBDBH_e1_,BartonellabacilliformisKC583T_f0_138taxa_algCOG_e1_,BartonellabacilliformisKC583T_f0_138taxa_algOMCL_e1_ -o core_138 -n # Identify the core genome and get gene sequences
compare_clusters.pl -d BartonellabacilliformisKC583T_f0_138taxa_algBDBH_e1_,BartonellabacilliformisKC583T_f0_138taxa_algCOG_e1_,BartonellabacilliformisKC583T_f0_138taxa_algOMCL_e1_ -o core_138 # Identify the core genome and get the protein sequences
cd core_138/ # Change directory
run_get_phylomarkers_pipeline.sh -R 1 -t PROT -n 16 -A I # Get the marker proteins and concatenated alignment
cd ../../ # Change directory





# Run get_homologues and get the consensus core genome without the five genomes missing lots of genes and using gene presence threshold of 95%
get_homologues.pl -n 32 -e -d Genome_files -t 132 # Run get_homologues using the BDBH algorithm 
get_homologues.pl -n 32 -G -e -d Genome_files -t 132 # Run get_homologues using the COGtriangles algorithm
get_homologues.pl -n 32 -M -e -d Genome_files -t 132 # Run get_homologues using the OMCL algorithm
mkdir Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algBDBH_e1_reduced/ # Make directory to hold cleaned clusters
mkdir Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algCOG_e1_reduced/ # Make directory to hold cleaned clusters
mkdir Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algOMCL_e1_reduced/ # Make directory to hold cleaned clusters
perl Scripts/extractClusters_2.pl Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algBDBH_e1_ /workingdisk1/George/1_Rhizobiales/1_Rhizobiales/Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algBDBH_e1_reduced/ 132 # Extract clusters without reduced genomes
perl Scripts/extractClusters_2.pl Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algCOG_e1_ /workingdisk1/George/1_Rhizobiales/1_Rhizobiales/Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algCOG_e1_reduced/ 132 # Extract clusters without reduced genomes
perl Scripts/extractClusters_2.pl Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algOMCL_e1_ /workingdisk1/George/1_Rhizobiales/1_Rhizobiales/Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algOMCL_e1_reduced/ 132 # Extract clusters without reduced genomes
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algBDBH_e1_ Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algBDBH_e1_full # Rename original clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algCOG_e1_ Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algCOG_e1_full # Rename original clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algOMCL_e1_ Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algOMCL_e1_full # Rename original clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algBDBH_e1_reduced Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algBDBH_e1_ # Rename folders containing the clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algCOG_e1_reduced Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algCOG_e1_ # Rename folders containing the clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algOMCL_e1_reduced Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algOMCL_e1_ # Rename folders containing the clusters
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algBDBH_e1_.cluster_list Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algBDBH_e1_full.cluster_list # Rename the now outdated cluster lists
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algCOG_e1_.cluster_list Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algCOG_e1_full.cluster_list # Rename the now outdated cluster lists
mv Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algOMCL_e1_.cluster_list Genome_files_homologues/BartonellabacilliformisKC583T_f0_132taxa_algOMCL_e1_full.cluster_list # Rename the now outdated cluster lists
cd Genome_files_homologues/ # Change directory
find . -type d # List the directories and modify the following code accordingly
compare_clusters.pl -d BartonellabacilliformisKC583T_f0_132taxa_algBDBH_e1_,BartonellabacilliformisKC583T_f0_132taxa_algCOG_e1_,BartonellabacilliformisKC583T_f0_132taxa_algOMCL_e1_ -o core_132 -n # Identify the core genome and get gene sequences
compare_clusters.pl -d BartonellabacilliformisKC583T_f0_132taxa_algBDBH_e1_,BartonellabacilliformisKC583T_f0_132taxa_algCOG_e1_,BartonellabacilliformisKC583T_f0_132taxa_algOMCL_e1_ -o core_132 # Identify the core genome and get the protein sequences
cd core_132/ # Change directory
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





# Recreate the core_143 phylogeny with an independent IQ-TREE run with jackkniving
mkdir Phylogeny/ # Make directory for the phylogeny output
mkdir Phylogeny/core_143/ # Make directory for the phylogeny with all 105 strains
tar -xvzf Genome_files_homologues/core_143/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/PhiPack/non_recomb_FAA_alns/top_*_markers_ge70perc/concatenated_alignment_files.tgz -C Genome_files_homologues/core_143/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/PhiPack/non_recomb_FAA_alns/top_*_markers_ge70perc/ # Uncompress alignment file
cp Genome_files_homologues/core_143/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/PhiPack/non_recomb_FAA_alns/top_*_markers_ge70perc/concat_protAlns.faainf Phylogeny/core_143/concat_protAlns.faainf # Get the trimmed alignment from get_phylomarkers
cd Phylogeny/core_143/ # Change directory
ls -1 ../../Genome_files/ | sed 's/.gbff//' > strain_names.txt # Get the strain names and fix the naming of one strain
paste ../../Genome_files_homologues/core_143/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/tree_labels.list strain_names.txt > numbered_strain_list.txt # Pair the numbers with the strain names
perl ../../Scripts/fix_alignment_headers.pl numbered_strain_list.txt concat_protAlns.faainf > concat_protAlns.species.faainf # Replace the numbers with the species name
iqtree2 -s concat_protAlns.species.faainf -m MF --mset LG -T 8 --prefix Rhizobiales_model # Determine the best fit model and use it for the next step
best_model=$(grep 'Best-fit' Rhizobiales_model.log | cut -f3 -d' ')
echo $best_model #LG+F+R8
iqtree2 -s concat_protAlns.species.faainf -m $best_model --alrt 1000 -J 1000 --jack-prop 0.4 -T 8 --prefix Rhizobiales_phylogeny # Create the final phylogeny
cd ../../ # Change directory
cp Phylogeny/core_143/Rhizobiales_phylogeny.treefile Output/Rhizobiales_phylogeny_143.treefile # Copy file to final output folder





# Create a core_136 phylogeny
mkdir Phylogeny/core_136/ # Make directory for the 95% phylogeny
cp Genome_files_homologues/core_136/concatenated_alignment.fasta Phylogeny/core_136/ # Get the alignment
cd Phylogeny/core_136/ # Change directory
iqtree2 -s concatenated_alignment.fasta -m MF --mset LG -T 8 --prefix Rhizobiales_expanded_model # Determine the best fit model and use it for the next step
best_model=$(grep 'Best-fit' Rhizobiales_expanded_model.log | cut -f3 -d' ')
echo $best_model #LG+F+I+R10
iqtree2 -s concatenated_alignment.fasta -m $best_model --alrt 1000 -J 1000 --jack-prop 0.4 -T 8 --prefix Rhizobiales_expanded_phylogeny # Create the final phylogeny
cd ../.. # Change directory
cp Phylogeny/core_136/Rhizobiales_expanded_phylogeny.treefile Output/Rhizobiales_phylogeny_136.treefile # Copy file to final output folder





# Recreate the core_138 phylogeny with an independent IQ-TREE run with jackkniving
mkdir Phylogeny/core_138/ # Make directory for the phylogeny with just the 103 strains
tar -xvzf Genome_files_homologues/core_138/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/PhiPack/non_recomb_FAA_alns/top_*_markers_ge70perc/concatenated_alignment_files.tgz -C Genome_files_homologues/core_138/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/PhiPack/non_recomb_FAA_alns/top_*_markers_ge70perc/ # Uncompress alignment file
cp Genome_files_homologues/core_138/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/PhiPack/non_recomb_FAA_alns/top_*_markers_ge70perc/concat_protAlns.faainf Phylogeny/core_138/concat_protAlns.faainf # Get the trimmed alignment from get_phylomarkers
cd Phylogeny/core_138/ # Change directory
ls -1 ../../Genome_files/ | sed 's/.gbff//' | grep -v 'Chenggangzhangella' | grep -v 'Liberibacter' | grep -v 'Methylobrevis' | grep -v 'Methyloligella' | grep -v 'Nitratireductor' > strain_names.txt # Get the strain names and fix the naming of one strain
paste ../../Genome_files_homologues/core_138/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/tree_labels.list strain_names.txt > numbered_strain_list.txt # Pair the numbers with the strain names
perl ../../Scripts/fix_alignment_headers.pl numbered_strain_list.txt concat_protAlns.faainf > concat_protAlns.species.faainf # Replace the numbers with the species name
iqtree2 -s concat_protAlns.species.faainf -m MF --mset LG -T 8 --prefix Rhizobiales_reduced_model # Determine the best fit model and use it for the next step
best_model=$(grep 'Best-fit' Rhizobiales_reduced_model.log | cut -f3 -d' ')
echo $best_model #LG+F+R9
iqtree2 -s concat_protAlns.species.faainf -m $best_model --alrt 1000 -J 1000 --jack-prop 0.4 -T 8 --prefix Rhizobiales_reduced_phylogeny # Create the final phylogeny
cd ../../ # Change directory
cp Phylogeny/core_138/Rhizobiales_reduced_phylogeny.treefile Output/Rhizobiales_phylogeny_138.treefile # Copy file to final output folder





# Create a core_132 phylogeny
mkdir Phylogeny/core_132/ # Make directory for the 95% phylogeny
cp Genome_files_homologues/core_132/concatenated_alignment.fasta Phylogeny/core_132/ # Get the alignment
cd Phylogeny/core_132/ # Change directory
iqtree2 -s concatenated_alignment.fasta -m MF --mset LG -T 8 --prefix Rhizobiales_expanded_model # Determine the best fit model and use it for the next step
best_model=$(grep 'Best-fit' Rhizobiales_expanded_model.log | cut -f3 -d' ')
echo $best_model #LG+F+I+R10
iqtree2 -s concatenated_alignment.fasta -m $best_model --alrt 1000 -J 1000 --jack-prop 0.4 -T 8 --prefix Rhizobiales_expanded_phylogeny # Create the final phylogeny
cd ../.. # Change directory
cp Phylogeny/core_132/Rhizobiales_expanded_phylogeny.treefile Output/Rhizobiales_phylogeny_132.treefile # Copy file to final output folder





# Perform wpAAI calculations with EzAAI
mkdir EzAAI_output/ # Make directory to hold the output data
perl Scripts/downloadGenomes_fna.pl Input_files/genomeList.txt # Download the genomes of interest
find Genome_files/*.fna > Input_files/file_paths.txt # Get a list of paths for input to EzAAI
perl Scripts/run_EzAAI.pl Input_files/file_paths.txt EzAAI_output/ 16 # Calculate pairwise wpAAI values
sed -i 's/.fna//g' EzAAI_output/aai.tsv # Fix strain names in output file
sed -i 's/.fna//g' EzAAI_output/aai.nwk # Fix strain names in output file
perl Scripts/prepareAAImatrix.pl EzAAI_output/aai.tsv Input_files/genomeList.txt > EzAAI_output/aai.matrix.tsv # Convert the EzAAI output to a matrix
cp EzAAI_output/aai.matrix.tsv Output/wpAAI_matrix.txt # Copy file to final output folder
sed -i 's/Strains//' Output/wpAAI_matrix.txt # Update file format for R
Rscript Scripts/wpAAI_figures_143.r # Make heatmaps
Rscript Scripts/wpAAI_figures_138.r # Make heatmaps
Rscript Scripts/wpAAI_figures_136.r # Make heatmaps
Rscript Scripts/wpAAI_figures_132.r # Make heatmaps
perl Scripts/extractAAI.pl Output/wpAAI_matrix.txt > Output/wpAAI_list.txt




# Calculate cpAAI from the core_143 marker proteins
cp Genome_files_homologues/core_143/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/PhiPack/non_recomb_FAA_alns/top_*_markers_ge70perc/concat_protAlns.faa Output/Rhizobiales_alignment_143.faa # Get untrimmed alignment
perl Scripts/fix_alignment_headers.pl Phylogeny/core_143/numbered_strain_list.txt Output/Rhizobiales_alignment_143.faa > temp.faa # Fix headers
mv temp.faa Output/Rhizobiales_alignment_143.faa # Rename file
Rscript Scripts/cpAAI_figures_143.r # Make heatmaps
Rscript Scripts/cpAAI_figures_143_mixed.r # Make heatmaps
sed -i 's/\"//g' Output/rooted_cpAAI_143_matrix.txt
sed -i 's/ /\t/g' Output/rooted_cpAAI_143_matrix.txt
cat <(echo -ne '\t') Output/rooted_cpAAI_143_matrix.txt > temp.txt
mv temp.txt Output/rooted_cpAAI_143_matrix.txt
sed -i 's/\"//g' Output/rooted_cpAAI_143_mixed_matrix.txt
sed -i 's/ /\t/g' Output/rooted_cpAAI_143_mixed_matrix.txt
cat <(echo -ne '\t') Output/rooted_cpAAI_143_mixed_matrix.txt > temp.txt
mv temp.txt Output/rooted_cpAAI_143_mixed_matrix.txt
perl Scripts/extractAAI.pl Output/rooted_cpAAI_143_matrix.txt > Output/cpAAI_143_list.txt





# Calculate cpAAI from the core_138 marker proteins
cp Genome_files_homologues/core_138/get_phylomarkers_run_AIR1tPROT_k1.5_m0.7_Tmedium_*/PhiPack/non_recomb_FAA_alns/top_*_markers_ge70perc/concat_protAlns.faa Output/Rhizobiales_alignment_138.faa # Get untrimmed alignment
perl Scripts/fix_alignment_headers.pl Phylogeny/core_138/numbered_strain_list.txt Output/Rhizobiales_alignment_138.faa > temp.faa # Fix headers
mv temp.faa Output/Rhizobiales_alignment_138.faa # Rename file
Rscript Scripts/cpAAI_figures_138.r # Make heatmaps
Rscript Scripts/cpAAI_figures_138_mixed.r # Make heatmaps
sed -i 's/\"//g' Output/rooted_cpAAI_138_matrix.txt
sed -i 's/ /\t/g' Output/rooted_cpAAI_138_matrix.txt
cat <(echo -ne '\t') Output/rooted_cpAAI_138_matrix.txt > temp.txt
mv temp.txt Output/rooted_cpAAI_138_matrix.txt
sed -i 's/\"//g' Output/rooted_cpAAI_138_mixed_matrix.txt
sed -i 's/ /\t/g' Output/rooted_cpAAI_138_mixed_matrix.txt
cat <(echo -ne '\t') Output/rooted_cpAAI_138_mixed_matrix.txt > temp.txt
mv temp.txt Output/rooted_cpAAI_13_mixed_matrix.txt
perl Scripts/extractAAI.pl Output/rooted_cpAAI_138_matrix.txt > Output/cpAAI_138_list.txt





# Calculate cpAAI from the core_136 marker proteins
cp Genome_files_homologues/core_136/concatenated_alignment.untrimmed.fasta Output/Rhizobiales_alignment_136.faa # Get untrimmed alignment
Rscript Scripts/cpAAI_figures_136.r # Make heatmaps
sed -i 's/\"//g' Output/rooted_cpAAI_136_matrix.txt
sed -i 's/ /\t/g' Output/rooted_cpAAI_136_matrix.txt
cat <(echo -ne '\t') Output/rooted_cpAAI_136_matrix.txt > temp.txt
mv temp.txt Output/rooted_cpAAI_136_matrix.txt
perl Scripts/extractAAI.pl Output/rooted_cpAAI_136_matrix.txt > Output/cpAAI_136_list.txt





# Calculate cpAAI from the core_132 marker proteins
cp Genome_files_homologues/core_132/concatenated_alignment.untrimmed.fasta Output/Rhizobiales_alignment_132.faa # Get untrimmed alignment
Rscript Scripts/cpAAI_figures_132.r # Make heatmaps
sed -i 's/\"//g' Output/rooted_cpAAI_132_matrix.txt
sed -i 's/ /\t/g' Output/rooted_cpAAI_132_matrix.txt
cat <(echo -ne '\t') Output/rooted_cpAAI_132_matrix.txt > temp.txt
mv temp.txt Output/rooted_cpAAI_132_matrix.txt
perl Scripts/extractAAI.pl Output/rooted_cpAAI_132_matrix.txt > Output/cpAAI_132_list.txt





# Prepare a 16S rRNA gene phylogeny
mkdir rRNA_phylogeny/ # Make directory for the RNA analysis
perl Scripts/downloadGenomes_RNA.pl Input_files/genomeList.txt # Download the RNA files of interest
perl Scripts/extractRNA.pl Input_files/genomeList.txt | sed 's/\t/\n/' > rRNA_phylogeny/genome_extracted_16S_rRNA_final.fna # Extract the 16S rRNA gene sequences from the genomes and remove redundancies per genome
rm rRNA_phylogeny/genome_extracted_16S_rRNA.fna # Remove intermediate file
rm rRNA_phylogeny/genome_extracted_16S_rRNA_uniq.fna # Remove intermediate file
mv rRNA_phylogeny/genome_extracted_16S_rRNA_final.fna rRNA_phylogeny/genome_extracted_16S_rRNA.fna # Rename file
sed -i 's/_T_T/_T/g' rRNA_phylogeny/genome_extracted_16S_rRNA.fna # Fix formatting
cut -f1 Input_files/genomeList.txt > temp.txt # Get list of genomes lacking a full length 16S rRNA gene
grep -oFf temp.txt rRNA_phylogeny/genome_extracted_16S_rRNA.fna | sort -u > temp2.txt # Get list of genomes lacking a full length 16S rRNA gene
diff temp2.txt temp.txt | grep '>' | sed 's/> //' > rRNA_phylogeny/genomes_lacking_16S_rRNA.txt # Get list of genomes lacking a full length 16S rRNA gene
rm temp.txt # Get list of genomes lacking a full length 16S rRNA gene
rm temp2.txt # Get list of genomes lacking a full length 16S rRNA gene
# Manually downloaded 16S rRNA genes for genomes that lack a full sequence, and added it to a file containing manually downloaded 16S rRNA genes for species that lack a genome sequence. File is Input_files/LPSN_16S_rRNA.fna. Sequences downloaded from LPSN.
cat rRNA_phylogeny/genome_extracted_16S_rRNA.fna Input_files/LPSN_16S_rRNA.fna > rRNA_phylogeny/total_16S_rRNA_sequences.fasta # Combine the 16S rRNA sequences
clustalo -i rRNA_phylogeny/total_16S_rRNA_sequences.fasta -o rRNA_phylogeny/total_16S_rRNA_sequences.clustalo.fasta --threads=16 --auto --full --full-iter # Align 16S rRNA sequences with Clustal Omega
mafft --maxiterate 1000 --localpair --thread 8 rRNA_phylogeny/total_16S_rRNA_sequences.fasta > rRNA_phylogeny/total_16S_rRNA_sequences.mafft.fasta # Align 16S rRNA sequences with MAFFT 
trimal -in rRNA_phylogeny/total_16S_rRNA_sequences.clustalo.fasta -out rRNA_phylogeny/total_16S_rRNA_sequences.clustalo.trimal.fasta -fasta -automated1 # Trim the alignment
trimal -in rRNA_phylogeny/total_16S_rRNA_sequences.mafft.fasta -out rRNA_phylogeny/total_16S_rRNA_sequences.mafft.trimal.fasta -fasta -automated1 # Trim the alignment
cd rRNA_phylogeny/ # Change directory
iqtree2 -s total_16S_rRNA_sequences.clustalo.trimal.fasta -m MF -T 4 --prefix 16S_rRNA_clustalo_model # Determine the best fit model and use it for the next step
best_model=$(grep 'Best-fit' 16S_rRNA_clustalo_model.log | cut -f3 -d' ')
echo $best_model #GTR+F+I+R6
iqtree2 -s total_16S_rRNA_sequences.clustalo.trimal.fasta -m $best_model --alrt 1000 -B 1000 -T 4 --prefix 16S_rRNA_gene_phylogeny.clustalo # Create the final phylogeny
iqtree2 -s total_16S_rRNA_sequences.mafft.trimal.fasta -m MF -T 4 --prefix 16S_rRNA_mafft_model # Determine the best fit model and use it for the next step
best_model=$(grep 'Best-fit' 16S_rRNA_mafft_model.log | cut -f3 -d' ')
echo $best_model #GTR+F+I+R6
iqtree2 -s total_16S_rRNA_sequences.mafft.trimal.fasta -m $best_model --alrt 1000 -B 1000 -T 4 --prefix 16S_rRNA_gene_phylogeny.mafft # Create the final phylogeny
cd ../ # Change directory
cp rRNA_phylogeny/16S_rRNA_gene_phylogeny.clustalo.treefile Output/Rhizobiales_rRNA_phylogeny_clustalo.treefile # Get untrimmed alignment
cp rRNA_phylogeny/16S_rRNA_gene_phylogeny.mafft.treefile Output/Rhizobiales_rRNA_phylogeny_mafft.treefile # Get untrimmed alignment
