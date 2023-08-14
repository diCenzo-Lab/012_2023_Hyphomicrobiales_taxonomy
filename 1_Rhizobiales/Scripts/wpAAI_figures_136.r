# Load packages
library(phangorn)
library(phytools)
library(RColorBrewer)
library(data.table)

## Set working directory
setwd('/workingdisk1/George/5_Rhizobiales/1_Rhizobiales/Output')

## Root the phylogeny
concattree = read.tree('Rhizobiales_phylogeny_136.treefile')
nfrootedtree = paste('Rhizobiales_phylogeny_136.treefile', 'rooted.names', sep='.')
toMatch <- c("Caulobacter", "Asticcacaulis", "Maricaulis", "Hyphomonas", "Henriciella")
write.tree(root(concattree, outgroup=grep(paste(toMatch,collapse="|"), concattree$tip.label), value=T), nfrootedtree)
rootedconcattree = read.tree(nfrootedtree)

# Load wpAAI data
AAI = read.table('wpAAI_matrix.txt')
colnames(AAI) = rownames(AAI)
rAAI = AAI[rootedconcattree$tip.label, rootedconcattree$tip.label]
rAAI <- type.convert(rAAI, as.is = TRUE)
min(rAAI)
#[1] 52.72393
which(rAAI==min(rAAI), arr.ind=T)
#                               row col
#Henriciella_marina_DSM_19595_T 141  40
#Liberibacter_crescens_BT-1_T    40 141
rAAI[rAAI==min(rAAI)] = 52 # Update this based on output of min(rcpaai), rounding down to a full integer

# Make figure 1
svg('wpAAI_136_colourful.svg')
phylo.heatmap(rootedconcattree, rAAI, fsize=.25, colors=c(rev(brewer.pal(9, 'YlGnBu')), brewer.pal(9, 'YlOrRd')))
dev.off()
pdf('wpAAI_136_colourful.pdf')
phylo.heatmap(rootedconcattree, rAAI, fsize=.25, colors=c(rev(brewer.pal(9, 'YlGnBu')), brewer.pal(9, 'YlOrRd')))
dev.off()

# Make figure 2
my_palette = colorRampPalette(c("white", "light blue", "dark blue"))(n = 3)
svg('wpAAI_136_basic.svg')
phylo.heatmap(rootedconcattree, rAAI, fsize=c(.25,.25,1), breaks=c(52,63.5,66,100), colors=my_palette)
dev.off()
pdf('wpAAI_136_basic.pdf')
phylo.heatmap(rootedconcattree, rAAI, fsize=c(.25,.25,1), breaks=c(52,63.5,66,100), colors=my_palette)
dev.off()

# Save the matrix
write.table(rAAI, file="rooted_wpAAI_136_matrix.txt")

# Quit
q()



