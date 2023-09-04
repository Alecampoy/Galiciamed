# Description
In this repository I keep the code necessary to analyze confocal images of c.elegans expresing *smn-1*. This code belong to the paper 'Galiciamed'.

## 01 - Image Analysis

Confocal c.elegans images are analyzed with the ImageJ Macro `01 - Image Analysis Macro.ijm`. The output for each image is:
- A binary image with the segmented elements
- ROI.zip file to proyect the segmented ROIs over the original image
- Result.xls (.tsv) file with the measurement of each segmented element of the worm

## 02 - Data Analysis

Rmarkdown notebook including the analysis and plots generation
