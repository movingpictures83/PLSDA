# PLSDA
# Language: R
# Input: TXT (key, value pairs)
# Output: Prefix
# Tested with: PluMA 1.0, R 3.2.5

PluMA plugin to run Partial Least Squares Discriminant Analysis (PLS-DA, Stahle and Wold 1987)
to determine the degree of separation between dataset(s), given values of observables in each set.

The plugin accepts input in the form of a text file, with (key, value) pairs.  The user provides in this file:

KEY         MEANING
---         -------
samples     CSV file containing a table where rows are samples and columns are observables
categories  TXT file containing sample categories (one per sample)
observables TXT file containing the name of each observable (one per observables)
targets     Categories of observables on which PLS-DA should be run

For output, the plugin accepts a "prefix" and will generate four output files:
1. (prefix).VIP.csv -> Most significant observables in the differentiation
2. (prefix).functions.csv -> Discriminant functions, in tabular format
3. (prefix).scores.csv -> Discriminant scores, for each sample
4. Rplots.pdf -> PLSDA analysis, in visual form

