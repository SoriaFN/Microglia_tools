//Open the "AVG_" image and the corresponding Tracks.zip file

name=getInfo("image.filename");
dir=getDirectory("image");
print("\\Clear");

//SEGMENTED LINE TO CIRCULAR ROIs
indiv_ROI=getNumber("Circular ROI size in microns", 8);
getPixelSize(unit, pixelWidth, pixelHeight);
size_cell_ROI=(indiv_ROI/pixelWidth);

run("Set Measurements...", "area mean display redirect=None decimal=2");
n_tracks=roiManager("count");
for (i=0; i<n_tracks; i++) {
	print("Analyzing Track "+(i+1)+"...");
	roiManager("select", i);
	getSelectionCoordinates(xpoints, ypoints);
	for (p=0; p<xpoints.length; p++) {
		run("Specify...", "width="+size_cell_ROI+" height="+size_cell_ROI+" x="+xpoints[p]+" y="+ypoints[p]+" oval centered");
		roiManager("add");
		c=roiManager("count");
		roiManager("select", c-1);
		roiManager("rename", "Tr"+(i+1)+"-"+(p+1));
		run("Measure");
	}
}	
roiManager("Show All");
roiManager("save", dir+"ROIs_"+name+".zip");
saveAs("Results", dir+"Values_"+name+".xls");
print("DONE!");





  