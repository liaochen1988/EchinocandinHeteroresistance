import pandas as pd
import numpy as np
import os

res = []
for f in os.listdir('./'):
    if f.startswith('CDCF'):
        library = pd.read_csv("%s/%s.marked_dup_metrics.txt"%(f,f), skiprows=np.arange(0,7), header=None).iloc[0,0].split('\t')[0]
        res.append([f,library])
df_res = pd.DataFrame(res, columns=['Strain','Library'])
df_res.to_csv("sample_name_dict.txt", index=False, header=None, sep="\t")
