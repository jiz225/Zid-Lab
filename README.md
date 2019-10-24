## Sequence Analysis Pipeline

Authors: Raghav Chanchani, Jingxiao Zhang

This analysis pipeline allows members of our lab to quickly and effectively analyze large amounts of RNASeq data and extract useful features and graphs from the reads. The highly modular shell script allows users to customize the pipeline for specific uses by easily adding in their own analysis modules as well. The script runs the bowtie alignment software, generates map files, counts and sorts the aligned reads, and extracts features into Excel compatible files that allow the user to generate insightful graphs of their experimental data.

## Polarity Pipeline

Author: Jingxiao Zhang

A Polarity pipeline allows members of our lab to measure the gene specific polarity from the Sequence Analysis Pipeline. It takes in the xls file which contains ribosome counts per position with start and end position for each gene. We use the definition of polarity described in article "eIF5A Functions Globally in Translation Elongation and Termination" by Schuller et al.. The polarity for a gene with length l is calculated as the sum of polarity at each position in the gene. The first and last 15 nuceotides of each gene are excluded in our analysis. The output polarity per gene is loaded to a csv file. Also, for each input sequence, we generate 3 plot to visualize how the polarity changes within the sequence. The first one shows the polarity at each position. The second one shows the cumulative distribution of polarity per gene. The third one is a normalized distribution of the gene specific polarities in the sequence.
