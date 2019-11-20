#!/bin/sh

# Author: Jingxiao Zhang
# Description: RNA sequencing pipeline to align and extract, count, and sort features.

filename=$1
dest='/home/jiz225/Zid-Lab/Sequence_analysis/'
#read -p 'Input directory is: ' input
input='/home/jiz225/Zid-Lab/Sequence_analysis/unaligned/'

# Trim polyAs from user specified input file
python /home/jiz225/Zid-Lab/Sequence_analysis/Inputs/trimPolyA.py $input$filename

# Set file names and paths for use in bowtie and data extraction
mapDir='Maps/'
# Set index basenames
rdnaDir='Indexes/rDNA'
geneDir='Indexes/genome'
ecoliDir='Indexes/e_coli'
# Set bowtie output filenames
rDNA='rDNA-'
coding='coding-'
map='aligned-'
alignSortDir='AlignedSorted/'
mochiDir='MochiView/'
featDir='Feature/'
dchrom='Chrom/'
trimf='trim/'
sortedGeneDir='SortedFiles/'

# Create bowtie argument filepaths
arg1=$dest$rdnaDir
arg2=$dest$rDNA$filename
arg3=$dest$coding$filename
arg4=$dest$geneDir
arg5=$dest$mapDir$filename

echo $arg1
echo $arg2
echo $arg3
echo $arg4
echo $arg5

#run bowtie
cd /opt/biotools/bowtie/bin/
bowtie -a --best --strata $arg1 $dest$trimf$filename $arg2 --un $arg3
bowtie -m 1 --best --strata $arg4 $arg3 $arg5
cd /home/jiz225/Zid-Lab/Sequence_analysis/Inputs/

#align and sort
echo $dest$alignSortDir
python /home/jiz225/Zid-Lab/Sequence_analysis/Inputs/AlignSortCount.py $input$filename $dest$alignSortDir $arg5

#extraxt feature: find genes
echo $dest$featDir
python /home/jiz225/Zid-Lab/Sequence_analysis/Inputs/features.py $dest$featDir $dest$alignSortDir$filename $dest$dchrom

# Sort gene features
echo $dest$sortedGeneDir
python /home/jiz225/Zid-Lab/Sequence_analysis/Inputs/sortFiles.py $dest$sortedGeneDir $dest$featDir$filename


