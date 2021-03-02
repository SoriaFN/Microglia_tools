# Microglia_tools
ImageJ macros to analyse microglial cells in live or fixed tissue.
(Please cite this repo if you use these scripts in your paper).

*This is work in progress. Some scripts need to be merged, and some need further testing.*

## How to use
1. Click on the ImageJ/FIJI script (".ijm" file) you want to download.
2. Click on "Raw"
3. Save page as .ijm file
4. Drag and drop the ijm file onto FIJI (or install macro in ImageJ)

## Current macros (Feb 2021)
### Immunofluorescence
- **Microglia_Morphology**  A script to calculate Form factor, Density and Fractal Dimension from binary images of individual cells.
- **Microglia_Segmentation**  A script to segment individual cells from fluorescence images.
### 2-photon timelapse
- **MIP_timelapse**  A script to generate drift-corrected Maximal Intensity Projections from tridimensional time-lapse images (hyperstack with xyzt).
- **Pixels_surveyed**  A script to calculate instantaneous and cumulative area surveyed by microglia in two-photon time-lapse images. Can be used in combination with "MIP_timelapse".
