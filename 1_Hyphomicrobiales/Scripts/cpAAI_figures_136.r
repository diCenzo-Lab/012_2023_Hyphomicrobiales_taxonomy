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
concatprotaln = as.matrix(read.FASTA("Rhizobiales_alignment_136.faa", type='AA'))
AAI = 100 * (1 - as.matrix(dist.aa(concatprotaln, scaled=TRUE)))
colnames(AAI) = rownames(AAI)
rAAI = AAI[rootedconcattree$tip.label, rootedconcattree$tip.label]
rAAI <- type.convert(rAAI, as.is = TRUE)
min(rAAI)
#[1] 49.02646
which(rAAI==min(rAAI), arr.ind=T)
#                                          row col
#Asticcacaulis_excentricus_CB_48_T         139 125
#Chenggangzhangella_methanolivorans_CHL1_T 125 139
rAAI[rAAI==min(rAAI)] = 49 # Update this based on output of min(rcpaai), rounding down to a full integer

# Make figure 1
svg('cpAAI_136_colourful.svg')
phylo.heatmap(rootedconcattree, rAAI, fsize=.25, colors=c(rev(brewer.pal(9, 'YlGnBu')), brewer.pal(9, 'YlOrRd')))
dev.off()
pdf('cpAAI_136_colourful.pdf')
phylo.heatmap(rootedconcattree, rAAI, fsize=.25, colors=c(rev(brewer.pal(9, 'YlGnBu')), brewer.pal(9, 'YlOrRd')))
dev.off()

# Make figure 2
my_palette = colorRampPalette(c("white", "light blue", "dark blue"))(n = 3)
svg('cpAAI_136_basic.svg')
phylo.heatmap(rootedconcattree, rAAI, fsize=c(.25,.25,1), breaks=c(55,76,80,100), colors=my_palette)
dev.off()
pdf('cpAAI_136_basic.pdf')
phylo.heatmap(rootedconcattree, rAAI, fsize=c(.25,.25,1), breaks=c(55,76,80,100), colors=my_palette)
dev.off()

# Save the matrix
write.table(rAAI, file="rooted_cpAAI_136_matrix.txt")

# Quit
q()

