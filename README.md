# "Design and validation of a Peptide Nucleic Acid clamp of barley and wheat ITS2 for fungal microbiome surveys"
### Whitaker, B.K.

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.16928483.svg)](https://doi.org/10.5281/zenodo.16928483)

This repository includes the R code, data files, and small scripts to supplement the manuscript by Whitaker "Design and validation of a Peptide Nucleic Acid clamp of barley and wheat ITS2 for fungal microbiome surveys".

The Rmd file ("designPNA_ITS2.Rmd") details the workflow for designing the PNA using alignment of plant reads from previous sequencing runs and BLASTn counter-search of potential kmers against the UNITe fungal database. The Rmd files ("cropPNAtest_Dec2022.Rmd" and "cropPNAtest_Dec2022-analyze.Rmd") performs the 1) bioinformatic analysis using DADA2 and taxonomic classification of fungal ASVs and 2) test of plant read proportions and diversity analyses, respectively.

The /code folder contains the bash scripts for BLASTn and MAFFT, as well as the small R scripts necessary to run small codes inside the main Rmd files. Data necessary to run the analyses can be found in /data folder or in the NCBI SRA associated with the manuscript.

The TapeStation results for confirmation of PNA annealing temperature are in 2022.11.17 Whitaker PNA.NoPNA PCR Test.pdf & 2022.11.18 Whitaker Reg.PCR No PNA Test.pdf (raw data), and summarized in the excel TapeStationResults_Summary.xlsx .

Please see the manuscript for details and full reference information.
