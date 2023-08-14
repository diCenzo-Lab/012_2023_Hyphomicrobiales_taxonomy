# Refining the taxonomy of the order *Hyphomicrobiales* (*Rhizobiales*) based on whole genome comparisons of over 130 genus type strains
 
This repository contains the scripts and input files required to repeat the analyses reported in the associated article. In addition, this repository contains the sets of marker proteins used for phylogenetic analyses and calculation of core-proteome average amino acid identity, which can be used with the [cpAAI_Rhizobiaceae](https://github.com/flass/cpAAI_Rhizobiaceae) pipeline to identify these marker proteins in other organisms.

## 1_Rhizobiales

This folder contains the overall workflow (workflow.sh), accessory scripts, and input files required to repeat the genome-based phylogenetic reconstructions, average amino acid identity calculations, and 16S rRNA gene phylogenetic analyses.

## 2_Phyllobacteriaceae

This folder contains the overall workflow (workflow.sh), accessory scripts, and input files required to repeat the genome-based phylogenetic reconstructions focused on the family *Bartonellaceae* and related families.

## 3_Marker_proteins

This folder contains the protein sequences and protein alignments of each of the marker proteins used in our study. For each marker protein, the sequences of all orthologs detected in the *Hyphomicrobiales* and *Caulobacterales* strains used in our study are included. This folder includes subfolders for each of the four gene sets we used: core_143 (19 marker proteins found in 100% of the 143 strains), perc95_143 (256 marker proteins found in at least 95% of the 143 strains), core_138 (59 marker proteins found in 100% of the reduced set of 138 strains), and perc95_138 (267 marker proteins found in at least 95% of the reduced set of 138 strains). Using these files with the the [cpAAI_Rhizobiaceae](https://github.com/flass/cpAAI_Rhizobiaceae) pipeline will allow for the identification of these proteins in other organisms, allowing a user to include additional species in the phylogenetic trees or core-proteome average amino acid identity calculations.