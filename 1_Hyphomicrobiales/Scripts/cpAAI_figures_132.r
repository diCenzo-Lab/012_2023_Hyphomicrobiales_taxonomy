#!/usr/bin/env/Rscript
library(phangorn)
library(phytools)
library(RColorBrewer)
library(data.table)

## Set working directory
setwd('/workingdisk1/George/1_Rhizobiales/Output')

## Root the phylogeny
concattree = read.tree('Rhizobiales_phylogeny_132.treefile')
nfrootedtree = paste('Rhizobiales_phylogeny_132.treefile', 'rooted.names', sep='.')
toMatch <- c("Caulobacter", "Asticcacaulis", "Maricaulis", "Hyphomonas", "Henriciella")
write.tree(root(concattree, outgroup=grep(paste(toMatch,collapse="|"), concattree$tip.label), value=T), nfrootedtree)
rootedconcattree = read.tree(nfrootedtree)

## Calculate cpAAI
concatprotaln = as.matrix(read.FASTA("Rhizobiales_alignment_132.faa", type='AA'))
AAI = 100 * (1 - as.matrix(dist.aa(concatprotaln, scaled=TRUE)))
colnames(AAI) = rownames(AAI)
rAAI = AAI[rootedconcattree$tip.label, rootedconcattree$tip.label]
rAAI <- type.convert(rAAI, as.is = TRUE)
min(rAAI)
#[1] 58.53403
which(rAAI==min(rAAI), arr.ind=T)
#                              row col
#Hyphomonas_polymorpha_PS728_T 137  45
#Ahrensia_kielensis_DSM_5890_T  45 137
rAAI[rAAI==min(rAAI)] = 58 # Update this based on output of min(rcpaai), rounding down to a full integer

# Make figure 1
svg('cpAAI_132_colourful.svg')
phylo.heatmap(rootedconcattree, rAAI, fsize=.25, colors=c(rev(brewer.pal(9, 'YlGnBu')), brewer.pal(9, 'YlOrRd')))
dev.off()
pdf('cpAAI_132_colourful.pdf')
phylo.heatmap(rootedconcattree, rAAI, fsize=.25, colors=c(rev(brewer.pal(9, 'YlGnBu')), brewer.pal(9, 'YlOrRd')))
dev.off()

# Make figure 2
my_palette = colorRampPalette(c("white", "light blue", "dark blue"))(n = 3)
svg('cpAAI_132_basic.svg')
phylo.heatmap(rootedconcattree, rAAI, fsize=c(.25,.25,1), breaks=c(55,76,80,100), colors=my_palette)
dev.off()
pdf('cpAAI_132_basic.pdf')
phylo.heatmap(rootedconcattree, rAAI, fsize=c(.25,.25,1), breaks=c(55,76,80,100), colors=my_palette)
dev.off()

# Save the matrix
write.table(rAAI, file="rooted_cpAAI_132_matrix.txt")

# Quit
q()

