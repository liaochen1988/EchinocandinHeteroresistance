library("ggplot2")
library("ggtree")
library("ggnewscale")
library("wesanderson")
library(viridis)

tree <- read.tree("data/cohort.filtered.snp.tree_1.fa.varsites.phy.treefile")
df_info <- read.table("data/Pattern_2520.csv", sep=',', header=TRUE, row.names=1)
cls <-list(China=row.names(df_info)[grep("China", df_info$Location)],
           USA=row.names(df_info)[grep("USA", df_info$Location)],
           Europe=row.names(df_info)[grep("Europe", df_info$Location)])
tree <- groupOTU(tree, cls, group_name="Location")
my_colors <- c('China'='goldenrod','Europe'='forestgreen','USA'='black')

p<-ggtree(tree, branch.length='rate', layout='circular') + geom_tippoint(aes(color=Location)) + geom_tiplab(aes(color=Location), align=TRUE, linesize=.75, size=5) + theme(legend.position="right") + geom_nodepoint() + geom_treescale() + ggplot2::xlim(0, 0.45) + scale_color_manual(values = my_colors) + theme(legend.key.size = unit(2, 'cm'), legend.text = element_text(size=25), legend.title=element_text(size=25))

pal1 <- wes_palette("Zissou1", 100, type = "continuous")
h1 <- gheatmap(p, df_info['HR'], width=.05, offset=0.0075, colnames=F) + scale_x_ggtree() + scale_y_continuous(expand=c(0,0.3)) + scale_fill_viridis(discrete = TRUE, name="Heteroresistance", option="H", begin=0.1, end=0.9)
h2 <- h1 + new_scale_fill()
h3<- gheatmap(h2, df_info['Pattern_2520_cnv_quant'], width=.05, offset = 0.01, colnames=F) + scale_x_ggtree() + scale_y_continuous(expand=c(0,0.3)) + scale_fill_gradientn(colours = pal1, name='CPAR2_103140')
ggsave("output/tree_hr_pattern_2520.pdf", dpi=600, width = 24, height = 24, units = "in", limitsize = FALSE)

