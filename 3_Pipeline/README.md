# Pipeline to assign organisms to the correct family within the order *Hyphomicrobiales*
A pipeline and reference protein sequence data for generating core-proteome alignment, inferring a maximum-likelihood phylogeny, and computing core-proteome amino-acid identity (cpAAI) values from bacterial genomes of the order *Hyphomicrobiales*, to assess their membership to an existing or a new family.

## Citation
These software and data are adapted from the software and data reported in the following two papers. If you find this pipeline useful, please cite these studies as well as the papers reporting the various dependencies described in the next section.

diCenzo GC, Yuqi Y, Young JPW, Kuzmanović N. 2023. **Refining the taxonomy of the order *Hyphomicrobiales* (*Rhizobiales*) based on whole genome comparisons of over 130 genus type strains** *bioRxiv*. [https://doi.org/10.1101/2023.11.15.567303]

Kuzmanović N, Fagorzi C, Mengoni A, Lassalle F, diCenzo GC. 2022. **Taxonomy of Rhizobiaceae revisited: proposal of a new framework for genus delimitation.** *Int J Syst Evol Microbiol* 72(3):005243.
[https://doi.org/10.1099/ijsem.0.005243]

## Dependencies
- cpAAI_Rhizobiaceae [https://github.com/flass/cpAAI_Rhizobiaceae]
	- the script `genome2cpAAI.py` must be on your path
- Python 3 (recommended version >= 3.8.5), with package:
	- Bio (BioPython) (recommended version >= 1.78)
- NCBI Blast+ (recommended version >= 2.6.0+)
- MAFFT (recommended version >= v7.487)
- trimAl (recommended version >= v1.4.rev22)
- IQ-TREE2 (recommended version >= 2.2.2.4)
- R (recommended version >= 4.0.2), with packages:
	- phangorn
	- ape

## Description
The `data` folder contains reference marker protein sequence sets and their corresponding alignments for four sets of marker proteins used in our recent study of the order *Hyphomicrobiales*. These include:
- `core_143` a set of 19 non-recombining core protein markers present in 100% of a set of 143 genomes (138 *Hyphomicrobiales* genomes and 5 *Caulobacterales* genomes)
- `core_138` a set of 59 non-recombining core protein markers present in 100% of a set of 138 genomes (133 *Hyphomicrobiales* genomes and 5 *Caulobacterales* genomes)
- `perc95_143` a set of 256 protein markers present in ≥95% of a set of 143 genomes (138 *Hyphomicrobiales* genomes and 5 *Caulobacterales* genomes)
- `perc95_138` a set of 267 protein markers present in ≥95% of a set of 138 genomes (133 *Hyphomicrobiales* genomes and 5 *Caulobacterales* genomes)

The script `hyphomicrobiales_family_assignment.sh` uses the `core_138` protein set to calculate cpAAI between user provided genomes and the 138 genomes included in our original dataset as desribed at [https://github.com/flass/cpAAI_Rhizobiaceae]. It additionally uses the `perc95_138` protein set to infer a maximum likelihood phylogeny that includes user provided genomes and the 138 genomes included in our original dataset, using the LG+F+I+R10 model.

## Pipeline usage
The script `hyphomicrobiales_family_assignment.sh` requires the following four inputs:
- `-g` the full path to the directory containing the genome(s) to be classified. Genomes must be provided as whole genome nucleotide fasta files.
- `-x` the extension (e.g., fna, fasta) of the file containing the genome sequence.
- `-d` the full path to the data folder provided within this repository.
- `-t` the maximum number of threads to use. We recommend not exceeding 8. 

Prior to running the pipeline, ensure that the pipeline script `hyphomicrobiales_family_assignment.sh` and all the scripts in the folder `scripts` are on your path.

The pipeline will produce two primary output files, while will be in the directory `Output_files`. The file `cpAAI_matrix.txt` contains pairwise cpAAI values between all genomes included in the dataset. The file `ML_phylogeny.treefile` will contain the maximum likelihood phylogeny. Two numbers will be given at each node. The first set of numbers are the SH-aLRT support values (%). The second set of numbers are the ultrafast jackknife support values (%).

## Data interpretation
The cpAAI and phylogeny returned by the script can be used to assign organisms to the correct families within the order *Hyphomicrobiales* according to the framework described in our [manuscript](https://doi.org/10.1101/2023.11.15.567303). Briefly, we proposed a taxonomic framework in which *Hyphomicrobiales* families are defined as monophyletic groups what share pairwise average amino acid identity values above ~75% when calculated from core_138. Therefore, if your strain displays greater than approximately 75% cpAAI with an organism included in this dataset, and the strains are monophyletic, they likely belong to the same family. On the other hand, if your strain has less than 75% cpAAI with any other organism included in this dataset, it potentially belongs to a novel family.
