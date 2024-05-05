library(ape)
tree <- read.tree("data/cohort.filtered.snp.tree_1.fa.varsites.phy.treefile")
covar <- vcv(tree)
write.table(covar, file = "output/variance_covariance_matrix.csv", sep = ",", col.names=NA)

