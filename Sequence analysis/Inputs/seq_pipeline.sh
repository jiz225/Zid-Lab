#!/bin/sh

# Author: Raghav Chanchani, Jingxiao Zhang
# Description: RNA sequencing pipeline to align, generate .map files, and extract, count, and sort features.
read -p 'default setting?(y/n)' default
if [ "$default" = "n" ]; then
	read -p 'Destination directory is: ' dest
	read -p 'Input directory is: ' input
	read -p 'Input file is: ' filename
else
	dest='/home/jiz225/Bowtie/bowtie/Zid-Lab-Projects-master'
        read -p 'Input directory is: ' input
        read -p 'Input file is: ' filename

fi
read -p 'Do you want to trim poly As(y/n)?' trim
if [ "$trim" = "y" ]; then
	# Trim polyAs from user specified input file
	python /home/jiz225/Bowtie/bowtie/Zid-Lab-Projects-master/Inputs/trimPolyA.py $input$filename
else
	echo 'continue'
fi
# Show pipeline options
echo 'To run the entire pipeline enter 1.'
echo 'To align and sort enter 2.'
echo 'To convert to gene feature enter 3'
echo 'To sort enter 4'
echo 'To exit enter 5'

# Set file names and paths for use in bowtie and data extraction
mapDir='/Maps/'
# Set index basenames
rdnaDir='/Indexes/rDNA'
geneDir='/Indexes/genome'
ecoliDir='/Indexes/e_coli'
# Set bowtie output filenames
aligned='/alignerdRNA.fq'
unaligned='/unrna.fq'
map='aligned.map'
alignSortDir='/AlignedSorted/'
mochiDir='/MochiView/'
featDir='/Feature/'
sortedGeneDir='/SortedFiles/'

# Create bowtie argument filepaths
arg1=$dest$rdnaDir
arg2=$dest$aligned
arg3=$dest$unaligned
arg4=$dest$geneDir
arg5=$dest$mapDir$map
arg6=$dest$alignSortDir

# Print filepaths to confirm identity
echo $arg1
echo $arg2
echo $arg3

# Make directories for align and sort files
if [ ! -d "$dest$mapDir" ]; then
	mkdir -p $dest$mapDir
fi

if [ ! -d "$dest$alignSortDir" ]; then
	mkdir -p $dest$alignSortDir
fi

if [ ! -d "$dest$featDir" ]; then
	mkdir -p $dest$featDir
fi

if [ ! -d "$dest$sortedGeneDir" ]; then
	mkdir -p $dest$sortedGeneDir
fi

PS3='Please enter an option: '
options=("run bowtie" "align and sort" "feature" "sort" "Quit")
select progIndex in "${options[@]}"
do
  case $progIndex in
    "run bowtie")
      echo "You chose to run the entire pipeline."
      read -p 'Input trimmed file is: ' trimmed
      # Create unaligned .fq by removing contaminants
      bowtie -a --best --strata $arg1 $input$trimmed $arg2 --un $arg3

      # Create align against specified DNA file and write to .map
      bowtie -m 1 --best --strata $arg4 $arg3 $arg5

      # Create directory to store aligned and sorted .txt file using aligned .map input
      echo $dest$alignSortDir
      python /home/jiz225/Bowtie/bowtie/Zid-Lab-Projects-master/Inputs/AlignSortCount.py $input$trimmed $arg6 $arg5

      # Create and store Feat.txt to see gene features
      echo $dest$featDir
      read -p 'Input aligned file is: ' aligned 
      read -p 'Chromosome directory is: ' chrom
      python /home/jiz225/Bowtie/bowtie/Zid-Lab-Projects-master/Inputs/features.py $dest$featDir $dest$alignSortDir$aligned $chrom

      # Sort gene features
      echo $dest$sortedGeneDir
      read -p 'Input featured file is: ' feature
      python /home/jiz225/Bowtie/bowtie/Zid-Lab-Projects-master/Inputs/sortFiles.py $dest$sortedGeneDir $dest$featDir$feature
      ;;

    "align and sort")
      read -p 'Is it a sam file?(y/n)' sam
      if ["$sam" = "n"]; then
        echo "You chose to align and sort reads in a .txt file from .map."
        # Create directory to store aligned and sorted .txt file using aligned .map input
        read -p 'Do you want to use default map file?(y/n)' defaultmap
        if [ "$defaultmap" = "n" ]; then
	  read -p 'Input map file is: ' newmap
	  read -p 'Input file is: ' file
	  echo $dest$alignSortDir
          python /home/jiz225/Bowtie/bowtie/Zid-Lab-Projects-master/Inputs/AlignSortCount.py $input$file $arg6 $dest$mapDir$newmap
        else
      	  echo $dest$alignSortDir
      	  python /home/jiz225/Bowtie/bowtie/Zid-Lab-Projects-master/Inputs/AlignSortCount.py $input$file $arg6 $arg5
        fi
      else
        echo "You chose to align and sort reads in a .txt file from .sam."
        python /home/jiz225/Bowtie/bowtie/Zid-Lab-Projects-master/Inputs/countRibo.py $arg6 $input$filename
      fi	
      # Create and store Feat.txt to see gene features
      echo $dest$featDir
      read -p 'Chromosome directory is: ' chrom
      read -p 'Input aligned file is: ' aligned 
      python /home/jiz225/Bowtie/bowtie/Zid-Lab-Projects-master/Inputs/features.py $dest$featDir $dest$alignSortDir$aligned $chrom

      # Sort gene features
      echo $dest$sortedGeneDir
      read -p 'Input featured file is: ' feature
      python /home/jiz225/Bowtie/bowtie/Zid-Lab-Projects-master/Inputs/sortFiles.py $dest$sortedGeneDir $dest$featDir$feature
      ;;
    
    "feature")
      echo "You chose to sort the file from aligned.txt"
      # Create and store Feat.txt to see gene features
      echo $dest$featDir
      read -p 'Chromosome directory is: ' chrom
      read -p 'Input aligned file is: ' aligned
      python /home/jiz225/Bowtie/bowtie/Zid-Lab-Projects-master/Inputs/features.py $dest$featDir $dest$alignSortDir$aligned $chrom

      # Sort gene features
      echo $dest$sortedGeneDir
      read -p 'Input featured file is: ' feature
      python /home/jiz225/Bowtie/bowtie/Zid-Lab-Projects-master/Inputs/sortFiles.py $dest$sortedGeneDir $dest$featDir$feature
      ;;

    "sort")
      # Sort gene features
      echo $dest$sortedGeneDir
      read -p 'Input featured file is: ' feature
      python /home/jiz225/Bowtie/bowtie/Zid-Lab-Projects-master/Inputs/sortFiles.py $dest$sortedGeneDir $dest$featDir$feature
      ;;

    "Quit")
      break
      ;;
    *) echo invalid option;;
  esac
done
