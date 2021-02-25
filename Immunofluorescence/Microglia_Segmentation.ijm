/*
 * MICROGLIA SEGMENTATION
 * ----------------------
 * Semi-automated segmentation for fluorescence images.
 * Works with z-stack and multichannel images.
 * 
 * 1. Open fluorescence image
 * 2. Choose channel for microglia staining
 * 3. Adjust threshold
 * 4. Fix unconnected branches or connected cells
 * 5. Cropped cells will be saved in a directory of your choosing
 * 
 * Federico N. Soria
 * ACHUCARRO BASQUE CENTER FOR NEUROSCIENCE
 * Sep 2020
 * 
 * Please acknowledge this script if you use it in your publication
 */

requires("1.43f");
run("Collect Garbage");

//INITIALIZATION
if (nImages==0) {
	exit("No image open.");
}
roiManager("reset");
roiManager("Show None");
print("\\Clear");
run("Options...", "iterations=1 count=1 black");
name=getTitle;
getDimensions(width, height, channels, slices, frames);

//GUI
ch_list=newArray(channels);
for (i=0; i<channels; i++){
		ch_list[i]=""+i+1+"";
}
Dialog.create("Choose your destiny...");
Dialog.addChoice("Microglia channel", ch_list, "1");
if (slices>1) {
	Dialog.addCheckbox("Create MIP?", true);
}
Dialog.addCheckbox("Apply Gaussian Filter", true);
Dialog.addNumber("Analyze Particles lower limit", 100);
Dialog.addNumber("Analyze Particles upper limit", 2000);
iba1_ch = Dialog.getChoice();
if (slices>1) {
	mip = Dialog.getCheckbox();
} else mip = false;
dogfilter = Dialog.getCheckbox();
AP_lower = Dialog.getNumber();
AP_upper = Dialog.getNumber();
Dialog.show();

//DIRECTORIES
print("Segmenting "+ name + " ...");
dir=getDirectory("Save Files to..."); //binary and ROI files will be saved here
dir_im=dir + name + File.separator;
	if (File.exists(dir_im)==false) {
		File.makeDirectory(dir_im);
	}
dir_bin=dir + "crop" + File.separator; //can replace "dir" by "dir_im" to save each bin folder inside its corresponding image folder
	if (File.exists(dir_bin)==false) {
		File.makeDirectory(dir_bin);
	}

//PROCESSING
setForegroundColor(255, 255, 255);
setBackgroundColor(0, 0, 0);
if (channels>1) {
	run("Split Channels");
	selectWindow("C"+iba1_ch+"-"+name);
	close("\\Others");
}
if (mip==true) {
	run("Z Project...", "projection=[Max Intensity]");
	print("MIP created.");
	saveAs("Tiff", dir_im+"MIP_"+name);
}
name_max=getTitle();
if (dogfilter==true) {
	DoG_filter ();
	saveAs("Tiff", dir_im+"DoG_"+name);
}
run("Duplicate...", "title=bin");

//THRESHOLDING AND BINARYZATION
selectWindow("bin");
run("Maximize");
setAutoThreshold("Huang dark"); //Less restrictive threshold, better for fine processes. You can adjust manually.
run("Threshold...");
waitForUser("Set Threshold", "Set Threshold level using the upper sliding bar \nThen click OK. \n \nDo not press Apply!");
getThreshold(lower, upper);
print("Threshold: "+lower); //Threshold values will be saved for tracing and reproducibility
run("Convert to Mask");

//SEGMENTATION
run("Analyze Particles...", "size="+AP_lower+"-"+AP_upper+" exclude add"); //This is scaled so it should work at different magnifications.
fix=getBoolean("Do you need to fix manually the binary image?", "YES, Fix it", "NO, continue");
selectWindow("bin");
run("Maximize");
if (fix==true) {
	do{
		roiManager("reset");
	    roiManager("Show None");
	    run("Invert LUT");
	    setTool("Paintbrush Tool");
	    run("Paintbrush Tool Options...", "brush=3");
	    waitForUser("Fix the processes with 3px brush.\nUse original image as guide.\n \nALT+CLICK to paint.\nCLICK to clear.");
	    run("Invert LUT");
	    run("Convert to Mask");
	    run("Analyze Particles...", "size="+AP_lower+"-"+AP_upper+" exclude add");
	    cont2=getBoolean("Do you want to continue fixing?");
	}while(cont2==true);
}
saveAs("Tiff", dir_im+"BIN_"+name);
name_bin=getTitle;

//CELL CROPPING
n=roiManager("Count");
print(n+" cells were detected.");
roiManager("save", dir_im+"ROIs_"+name_bin+".zip");
showMessageWithCancel("Cells will be cropped.\nProceed?");
counter=0;
print(counter+" cells saved.");
for (i=0; i<n; i++) {
	roiManager("select", i);
	run("Duplicate...", "title=TEMP");
	selectWindow("TEMP");
	run("Clear Outside");
	run("Select None");
	getDimensions(width, height, channels, slices, frames);
	run("Canvas Size...", "width="+(width+10)+" height="+(height+10)+" position=Center");
	save_crop=getBoolean("Image "+(i+1)+"/"+n+". Save?");
	if (save_crop==true) {
		saveAs("Tiff", dir_bin+i+"_"+name);
		run("Close");
		counter=counter+1;
		print("\\Update:"+counter+" cells saved.");
	}
	else close("TEMP");
	selectWindow(name_bin);
}
selectWindow("Log");
saveAs("Text", dir_im+File.separator+"LOG_"+name+".txt");

//END
waitForUser(counter+" cells saved.\n \nNext image please.");
run("Close All");

function DoG_filter (){
	Dialog.create("Difference of Gaussians Filter");
	Dialog.addNumber("Minimum sigma", 1);
	Dialog.addNumber("Maximum sigma", 500);
	Dialog.show();
	gmin=Dialog.getNumber();
	gmax=Dialog.getNumber();
			
	name2=getTitle();
	selectWindow(name2);
	run("Grays");
	run("Duplicate...", "title=min duplicate");
	run("Gaussian Blur...", "sigma="+gmin+" stack");
	selectWindow(name2);
	run("Duplicate...", "title=max duplicate");
	run("Gaussian Blur...", "sigma="+gmax+" stack");
	imageCalculator("Subtract stack", "min","max");
	selectWindow("max");
	close();
	selectWindow("min");
	run("Enhance Contrast", "saturated=0.35");
	rename("filtered");
	print("DoG filter applied with sigmas "+gmin+" and "+gmax);
}
