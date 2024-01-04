#!/usr/bin/env Rscript

library(phangorn)
nfconcatprotaln = "Intermediate_files/core_138_out/concatenated_marker_proteins.aln"
concatprotaln = as.matrix(read.FASTA(nfconcatprotaln, type='AA'))
cpaai = 100 * (1 - as.matrix(dist.aa(concatprotaln, scaled=TRUE)))
write.table(cpaai, "cpAAI_matrix.txt", sep='\t', col.names=NA, row.names=T)
q("no")
