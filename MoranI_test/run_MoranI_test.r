library("ape")

# Xy.csv contains feature values of all 453 patterns associated with HR and HR phenotype itself
Xy <- read.csv("data/Xy.csv", row.names = 1)

tree<-read.tree("data/cohort.filtered.snp.tree_1.fa.varsites.phy.treefile")
w <- 1/cophenetic(tree)
w <- w[rownames(Xy), rownames(Xy)]
diag(w) <- 0

results<-c()
for (i in 1:length(Xy)) {
  res <- Moran.I(Xy[,i], w)
  results<-cbind(results, c(res$observed, res$expected, res$sd, res$p.value))
}
rownames(results) <- c("Observed", "Expected", "SD", "Pvalue")
colnames(results) <- colnames(Xy)
write.csv(results, "output/MoranI_test_results.csv")
