import os

train_msa = "data/split1_train.fna"
test_msa = "data/split1_test.fna"
train_tree = "data/split1_train.tree"

# build phylogenetic tree
os.system("./raxml-ng --evaluate --msa %s --msa-format fasta --tree %s --prefix %s --model GTR+G+F"%(train_msa, train_tree, 'output/split1_train/split1_train'))

# rename suffix: bestTree->tree and bestModel->model
os.system("cp data/split1_train.fna output/split1_train/split1_train.fna")
os.system("cp output/split1_train/split1_train.raxml.bestTree output/split1_train/split1_train.tre")
os.system("cp output/split1_train/split1_train.raxml.bestModel output/split1_train/split1_train.model")

# build hmm files
os.system("hmmbuild --cpu 36 output/split1_train/split1_train.hmm %s"% train_msa)

# place test sequences onto the phylogenetic tree
# os.system("micromamba activate picrust2")
os.system("place_seqs.py -s %s --ref_dir output/split1_train -o output/split1_train/placed_seqs.tre -p 4"% test_msa)

# hidden state prediction
os.system("hsp.py --observed_trait_table data/split1_train.hr_pheno.txt.gz -t output/split1_train/placed_seqs.tre -o output/split1_train/split1_test.hr_pheno.tsv.gz -p 36")
