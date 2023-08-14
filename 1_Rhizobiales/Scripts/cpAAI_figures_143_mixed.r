#!/usr/bin/env/Rscript
library(phangorn)
library(phytools)
library(RColorBrewer)
library(data.table)

## Set working directory
setwd('/workingdisk1/George/1_Rhizobiales/Output')

## Root the phylogeny
concattree = read.tree('Rhizobiales_phylogeny_136.treefile')
nfrootedtree = paste('Rhizobiales_phylogeny_136.treefile', 'rooted.names', sep='.')
toMatch <- c("Caulobacter", "Asticcacaulis", "Maricaulis", "Hyphomonas", "Henriciella")
write.tree(root(concattree, outgroup=grep(paste(toMatch,collapse="|"), concattree$tip.label), value=T), nfrootedtree)
rootedconcattree = read.tree(nfrootedtree)

## Calculate cpAAI
concatprotaln = as.matrix(read.FASTA("Rhizobiales_alignment_143.faa", type='AA'))
AAI = 100 * (1 - as.matrix(dist.aa(concatprotaln, scaled=TRUE)))
colnames(AAI) = rownames(AAI)
rAAI = AAI[rootedconcattree$tip.label, rootedconcattree$tip.label]
rAAI <- type.convert(rAAI, as.is = TRUE)
min(rAAI)
#[1] 60.91109
which(rAAI==min(rAAI), arr.ind=T)
#                                  row col
#Caulobacter_vibrioides_DSM_9893_T 140  40
#Liberibacter_crescens_BT-1_T       40 140
rAAI[rAAI==min(rAAI)] = 61 # Update this based on output of min(rcpaai), rounding down to a full integer

# Make figure 1
svg('cpAAI_143_mixed_colourful.svg')
phylo.heatmap(rootedconcattree, rAAI, fsize=.25, colors=c(rev(brewer.pal(9, 'YlGnBu')), brewer.pal(9, 'YlOrRd')))
dev.off()
pdf('cpAAI_143_mixed_colourful.pdf')
phylo.heatmap(rootedconcattree, rAAI, fsize=.25, colors=c(rev(brewer.pal(9, 'YlGnBu')), brewer.pal(9, 'YlOrRd')))
dev.off()

# Make figure 2
my_palette = colorRampPalette(c("white", "light blue", "dark blue"))(n = 3)
svg('cpAAI_143_mixed_basic.svg')
phylo.heatmap(rootedconcattree, rAAI, fsize=c(.25,.25,1), breaks=c(55,78,80,100), colors=my_palette)
dev.off()
pdf('cpAAI_143_mixed_basic.pdf')
phylo.heatmap(rootedconcattree, rAAI, fsize=c(.25,.25,1), breaks=c(55,78,80,100), colors=my_palette)
dev.off()

# Save the matrix
write.table(rAAI, file="rooted_cpAAI_143_mixed_matrix.txt")

# Quit
q()

