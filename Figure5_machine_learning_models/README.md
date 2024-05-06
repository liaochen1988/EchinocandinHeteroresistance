The main.ipynb notebook implemented nested cross-validation for model training and evaluation.
The inner loop utilizes 5-fold cross-validation for feature selection and hyperparameter tuning, 
while the outer loop consists of repeated subsampling validation for model evaluation.

Multiple variants of machine learning models were implemented:

Model type 1: Feature selectors (Logistic regression, Lasso, ENNS), Classifiers (Random forest, XGBoost), Features (all SNV, InDel, CNV cat, CNV quant)
Model type 2: Feature selector (Logistic regression), Classifier (XGBoost), Features (only SNV)
Model type 3: Feature selector (Logistic regression), Classifier (XGBoost), Features (all SNV, InDel, CNV cat, CNV quant), training data labels (i.e., heteroresistance phenotype) shuffled
Model type 4: Feature selector (Logistic regression), Classifier (XGBoost), Features (all SNV, InDel, CNV cat, CNV quant), training data undersampling and oversampling

In the manuscript, the outer loop was repeated 50 times (the 50 data splits used in our manuscript are available in data/train_test_splits.csv.). 
However, to expedite the execution, only 2 iterations were implemented in main.ipynb as a demonstration.
