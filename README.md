# Microglia ImageJ Tools
ImageJ macros to analyse microglial cells in live or fixed tissue. Used in papers from GlioMatrixLab


## How to use
1. Click on the ImageJ/FIJI script (".ijm" file) you want to download.
2. Click on "Raw"
3. Save page as .ijm file
4. Drag and drop the ijm file onto FIJI (or install macro in ImageJ)

## How to cite
Please cite these scripts if you use them in your paper:

**Soria FN. *Microglia ImageJ Tools v0.9.0.*. Zenodo, 2023. DOI:10.5281/zenodo.8268201.**

[![DOI](https://zenodo.org/badge/341842086.svg)](https://zenodo.org/badge/latestdoi/341842086)

## Current macros (Jul 2023)
### Immunofluorescence
- **Microglia_Morphology**  A script to calculate Form factor, Density and Fractal Dimension from binary images of individual cells.
- **Microglia_Segmentation**  A script to segment individual cells from fluorescence images.
- **BATCH_fractal_count**  A script to calculate Fractal Dimension (Db) from all binary images in a folder.
### 2-photon timelapse
- **MIP_timelapse**  A script to generate drift-corrected Maximal Intensity Projections from tridimensional time-lapse images (hyperstack with xyzt).
- **Pixels_surveyed**  A script to calculate instantaneous and cumulative area surveyed by microglia in two-photon time-lapse images. Can be used in combination with "MIP_timelapse".
- ### Manual tracking (beta)
- **Image_prep**  A script to register 2-channel timelapse using HyperStackReg, using only 1 of the channels to compute transformation.
- **Tracking**  A script to store in ROImanager the tracks generated using Manual Tracking plugin.
- **Measure_ECM**  A script to generate circular ROIs in each frame of a timelapse, using a previously generated track as reference.
