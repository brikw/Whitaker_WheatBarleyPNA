#!/bin/bash
#SBATCH --job-name="mafft"
#SBATCH --time=2:00:00   # walltime 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32   # 16 processor core(s) per node X 2 threads per core
#SBATCH --partition=short    # partition type
#SBATCH --mail-user=briana.whitaker@usda.gov
#SBATCH --mail-type=BEGIN,END,FAIL

cd /project/mpm_fhb_genomics/whitaker
date
pwd
module load mafft/7.429

mafft --localpair --maxiterate 1000 --reorder fITS7_100bp_allCrops.fasta > fITS7_100bp_allCrops_aln.fasta
#mafft --localpair --maxiterate 1000 --reorder --treeout Zm_ASVs_ITS2.fasta > Zm_ASVs_ITS2_aln.fasta

date
