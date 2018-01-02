#!/bin/bash
#SBATCH --nodes 1 --ntasks 1 --mem 2G -p short

Rscript Rscripts/pca.R
