//Open the "REG_" image

//INITIALIZATION
dir=getDirectory("image");
name=getInfo("image.filename");
print("\\Clear");
roiManager("reset");
getPixelSize(unit, pixelWidth, pixelHeight);
print("Tracking on "+name+"...");
print("Pixel size= "+pixelWidth);
Stack.getUnits(X, Y, Z, Time, Value);
interval=Stack.getFrameInterval();
real_interval=round(interval);
print("frame interval= "+real_interval+" "+Time);
print("");

//NCAN-GFP MAP
run("Duplicate...", "duplicate channels=1");
rename("ECM");
run("Z Project...", "projection=[Average Intensity]");
saveAs("Tiff", dir+"AVG_"+name);
run("Close");
selectWindow("ECM");
run("Close");
print("ECM topology map saved in "+dir);
print("");

//TRACKING
selectWindow(name);
Stack.setChannel(2); //Microglia channel
run("Manual Tracking");
waitForUser("Adjust parameters and track cells one by one \nat a zoom of 150-200%. \n \n(Check log for calibration values) \n \nA prompt with the track # will appear. \nPress OK after each track to save track to ROI manager");
counter=1;
do{
	waitForUser("Press 'OK' when Track "+counter+" is finished.");
	roiManager("add");
	roiManager("select", (counter-1));
	roiManager("rename", "Track "+counter);
	print("Track "+counter+" stored in ROI manager");
	counter=counter+1;
	roiManager("save", dir+"TRACKS_"+name+".zip");
	saveAs("Results", dir+"Tracks_"+name+".xls");
	cont=getBoolean("Do you want to track another cell?");
}while(cont==true);

//EXIT

print("Tracking complete");