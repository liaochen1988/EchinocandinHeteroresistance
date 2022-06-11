Run the following command to quantify drug heteroresistance:

python3 main.py -f input_pap.csv -d 1e-4 -o output

where -f specifies input of PAP data (a 2D table with rows are drug concentrations and columns are strains), -d specifies the detection of limit for survival cell percentage (by default, 1e-4 %), and -o specifies output folder directory (no trailing /).

The following python packages are needed: pandas, numpy, argparse, warnings, matplotlib, sklearn, seaborn, scipy.
