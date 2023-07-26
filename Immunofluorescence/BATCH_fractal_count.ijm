/*
 * BATCH_FRACTAL_COUNT
 * -------------------
 * 
 * -Calculates fractal dimension on ALL binary images from a given folder 
 * -Must have FractalCount plugin (from Per Christian Henden) installed (https://github.com/perchrh)
 * 
 * Federico N. Soria
 * ACHUCARRO BASQUE CENTER FOR NEUROSCIENCE
 * 2023
 * 
 * Please acknowledge this script (and the plugin by Per Christian Henden) if you use it in your publication
 */

dir = getDirectory("Choose the folder with binary images");
list = getFileList(dir); 
min_box = getNumber("Min box size for Fractal Count", 2);

run("Options...", "iterations=1 count=1 black do=Nothing");
setForegroundColor(255, 255, 255);
setBackgroundColor(0, 0, 0);
setBatchMode(true);
if (isOpen("Log")) { 
	selectWindow("Log"); 
    run("Close"); 
}

//FRACTAL ANALYSIS
for(i=0;i<list.length;i++){
	filename = dir + list[i];
	if (endsWith(filename, "tif")) { 
		open(dir+list[i]);
		run("Outline");
		run("FractalCount ", "plot automatic threshold=70 start=24 min="+min_box+" box=1.2 number=3");
	}
}

selectWindow("Log");
saveAs("Text", dir + "fractal_count.xls");
print("DONE!");
print("Results saved in "+dir+"fractal_count.xls");