# Pipeline to assign organsisms to the correct family within the order *Hyphomicrobiales*
A pipeline and reference protein sequence data for generating core-proteome alignment, inferring a maximum-likelihood phylogeny, and computing core-proteome amino-acid identity (cpAAI) values from bacterial genomes of the order *Hyphomicrobiales*, to assess their membership to an existing or a new family.

## Citation
These software and data are adapted from the software/data reported in the following two papers. If you find this pipeline useful, please cite these studies as well as the papers reporting the various dependencies described in the next section.

diCenzo GC, Yuqi Y, Young JPW, Kuzmanović N. 2023. **Refining the taxonomy of the order *Hyphomicrobiales* (*Rhizobiales*) based on whole genome comparisons of over 130 genus type strains** *bioRxiv*. [https://doi.org/10.1101/2023.11.15.567303]

Kuzmanović N, Fagorzi C, Mengoni A, Lassalle F, diCenzo GC. 2021. **Taxonomy of Rhizobiaceae revisited: proposal of a new framework for genus delimitation.** *Int J Syst Evol Microbiol* 72(3):005243.
[https://doi.org/10.1099/ijsem.0.005243]

## Dependencies
- cpAAI_Rhizobiaceae [https://github.com/flass/cpAAI_Rhizobiaceae]
- Python 3 (recommended version >= 3.8.5), with package:
	- Bio (BioPython) (recommended version >= 1.78)
- NCBI Blast+ (recommended version >= 2.6.0+)
- MAFFT (recommended version >= v7.487) (preferred)
- IQ-TREE2 (recommended version >= 2.2.2.4)
- R (recommended version >= 4.0.2), with package:
	- phangorn

## Description
The `data` folder contains reference marker protein sequence sets and their corresponding alignments for four sets of marker proteins used in our recent study of the order *Hyphomicrobiales*. These include:
- `core_143`: a set of 19 non-recombining core protein markers present in 100% of a set of 143 genomes (138 *Hyphomicrobiales* genomes and 5 *Caulobacterales* genomes)
- `core_138`: a set of 59 non-recombining core protein markers present in 100% of a set of 138 genomes (133 *Hyphomicrobiales* genomes and 5 *Caulobacterales* genomes)
- `perc95_143`: a set of 256 protein markers present in ≥95% of a set of 143 genomes (138 *Hyphomicrobiales* genomes and 5 *Caulobacterales* genomes)
- `perc95_138`: a set of 267 protein markers present in ≥95% of a set of 138 genomes (133 *Hyphomicrobiales* genomes and 5 *Caulobacterales* genomes)

The script `hyphomicrobiales_family_assignment.sh` uses the `core_138` protein set to calculate cpAAI between user provided genomes and the 138 genomes included in our original dataset as desribed at [https://github.com/flass/cpAAI_Rhizobiaceae]. It additionally uses the `perc95_138` protein set to infer a maximum likelihood phylogeny that includes user provided genomes and the 138 genomes included in our original dataset, using the LG+F+I+R10 model.

## Pipeline usage





The script `genome2cpAAI.py` takes as input a list of complete genomic nucleotide sequence (contig) files from the query organisms (argument `-q`), a list of files containing the reference marker protein sequence sets (argument `-p`) and a path for the folder where the output will be written (argument `-o`). Optionally, a list of files containing the alignments of the reference marker protein sequence sets can be provided (argument `-A`). All sequence and alignment files should be in Fasta format.  
This script will locate in the input genome the loci coding for the protein homologs of the reference marker proteins using `tblastn`. It will then extract these sequences, translate them, and align them with the reference sequence set using `mafft` (the aligner `clustalo` can be used alternatively if specified through the argument `--aligner`); if the reference alignments were provided, these are used as a alignment guide using `mafft -add` algorithm, allowing faster processing.  
Finally, the resulting core protein alignments are concatenated into a single file.

### 1. Generating the concatenated protein alignment

#### Generic use
Here is an example of how to use the script `genome2cpAAI.py` on generic data (i.e. with any reference core protein set, pre-aligned or not):

```sh
# generate list of query genome sequences (use of .fna extension is just indicative here, any nucleotde fasta file will do)
ls my_query_genomes/*.fna > testgenomelist
# generate list of reference marker protein sequences (use of .faa extension is just indicative here, any protein fasta file will do)
ls my_ref_protein_sequences/*.faa > my_ref_protein_sequences_list
mkdir genome2cpAAI_out/ tmp/
# run the pipeline (assuming you have 8 cores to support multi-threaded computation)
genome2cpAAI.py -q testgenomelist -p my_ref_protein_sequences_list \
-o genome2cpAAI_out --threads 8 --tmp_dir tmp
```

and if you have already aligned your reference protein set:
```sh
# also generate list of reference marker protein sequences (use of .aln extension is just indicative here, any aligned protein fasta file will do)
ls my_ref_protein_alignments/*.aln > my_ref_protein_alignments_list
# run the pipeline (assuming you have 8 cores to support multi-threaded computation)
genome2cpAAI.py -q testgenomelist -p my_ref_protein_sequences_list \
 -A my_ref_protein_alignments_list \
 -o genome2cpAAI_out --threads 8 --tmp_dir tmp
```

#### Use with 170 Rhizobiaceae marker set
If you wish to estimate the cpAAI of a query Rhizobiaceae genome against our reference set of 170 marker proteins from 97 reference strains as described in [Kuzmanovic et al. (2021)](https://doi.org/10.1101/2021.08.02.454807), please use the following commands.  
We strongly recommend using the pre-aligned reference protein files as we cannot guarantee that the cpAAI values derived from a third-party alignment will be consistent with those described in our manuscript.

```sh
# generate list of reference marker protein sequence and alignment files
# lists of files for the 170 Rhizobiaceae core protein markers are already available in data/
ls whereyouputyourrepo/cpAAI_Rhizobiaceae/data/protein_sequences/*.faa > protein_sequences_list
ls whereyouputyourrepo/cpAAI_Rhizobiaceae/data/protein_alignments/*.aln > protein_alignments_list
mkdir genome2cpAAI_Rhizob_out/ tmp/
# run the pipeline
genome2cpAAI.py -q testgenomelist -p protein_sequences_list \
 -A protein_alignments_list -o genome2cpAAI_Rhizob_out \
 --threads 8 --tmp_dir tmp
```
### 2. Compute cpAAI values

Then, the output concatenated alignment `concatenated_marker_proteins.aln` (located in the specified result folder, here `genome2cpAAI_out/`) can be used to compute a core-proteome tree using the phylogenetic program of your choice (task not included in this package) and to compute the **cpAAI values** between query and reference strains.  
This can be done with the following `R` script:
```R
library(phangorn)
nfconcatprotaln = "genome2cpAAI_out/concatenated_marker_proteins.aln"
concatprotaln = as.matrix(read.FASTA(nfconcatprotaln, type='AA'))
cpaai = 100 * (1 - as.matrix(dist.aa(concatprotaln, scaled=TRUE)))
write.table(cpaai, "cpAAI_matrix.txt", sep='\t', col.names=NA, row.names=T)
# the tree obtained based on the concatenate can be used to order the matrix
nfrootedtree = "yourNewicktreefile"
rootedconcattree = read.tree(nfrootedtree)
rcpaai = cpaai[rootedconcattree$tip.label,rootedconcattree$tip.label]
write.table(rcpaai, "orderred_cpAAI_matrix.txt", sep='\t', col.names=NA, row.names=T)
```
### 3. Visualisation

Plotting can be done thanks to the `phylo.heatmap` function from the R package `phytools`:
```R
library(phytools)
library(RColorBrewer)
pdf(paste(nfrootedtree, "heatmap_cgANI.pdf", sep='.'), width=20, height=14)
phylo.heatmap(rootedconcattree, rcpaai, fsize=.5, colors=c(rev(brewer.pal(8, 'YlGnBu')), brewer.pal(9, 'YlOrRd')))
dev.off()
```
![cpaaiplot]

[cpaaiplot]:fig/cpAAI_heatmap-vs-coregenometree.svg