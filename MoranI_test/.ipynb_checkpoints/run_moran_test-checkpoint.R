library("ape")

Xy <- read.csv("Xy.csv", row.names = 1)

tree<-read.tree("../files_from_yy/cohort.filtered.hf.gt.snp_1.fa.varsites.phy.treefile")
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
write.csv(results, "Moran_test_results_20230429.csv")

