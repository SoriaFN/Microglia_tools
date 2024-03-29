/*
 * MICROGLIA MORPHOLOGY v1.2.1
 * ---------------------------
 * 
 * Analyses cell morphology in binary images 
 * (1 cell per image).
 * 
 * 1. Open binary image
 * 2. Run the macro
 * 3. Results will appear in custom table
 * 
 * Changelog (v.1.2 - 17-11-2021)
 * -------------------------------
 * -Fixed border of binary image (5 additional px per side)
 * -Fixed Convex Hull Area calculation
 * -Fixed "Black background" option autoselection
 * 
 * Changelog (v.1.2.1 - 25-07-2023)
 * ------------------------------- 
 * -Replaced broken link (FractalCount now hosted in private GoogleDrive)
 *
 *
 * Federico N. Soria
 * ACHUCARRO BASQUE CENTER FOR NEUROSCIENCE
 * August 2020
 * 
 * Please acknowledge this script if you use it in your publication
 */

//REQUIREMENTS
requires("1.43f");
List.setCommands;
    if (List.get("FractalCount ")=="") {
       showMessage("Required Plugin", "<html><h3>Macro requires ImageJ-PlugIn \"FractalCount\"!</h3>"
     +"<a href=\"https://drive.google.com/file/d/1f19vFmRIJopuRpt5ODEk2UoYmc0ClvJ9/view?usp=drive_link\">Download</a>"); exit(););
    }

//INITIALIZATION
if (nImages==0) {
	exit("No image open.");
}
if (nImages>1) {
	exit("More than one image open.\nClose all non-relevant images");
}
if (is("binary")==false) {
	exit("Binary image required.");
}
min_box = getNumber("Min box size for Fractal Count", 2);
name = getTitle();
run("Options...", "iterations=1 count=1 black do=Nothing");
setForegroundColor(255, 255, 255);
setBackgroundColor(0, 0, 0);
run("Clear Results");
resetThreshold();
run("Select None");
print("\\Clear");

//FORM FACTOR
rename("Area and Perimeter");
run("Set Measurements...", "area perimeter limit redirect=None decimal=3");
getPixelSize(unit, pixelWidth, pixelHeight);
setAutoThreshold("Default dark");
run("Create Selection");
run("Measure");
area = getResult("Area", 0);
per = getResult("Perim.", 0);
ff = (4*PI*area)/(pow(per, 2));
run("Select None");

//DENSITY
selectWindow("Area and Perimeter");
run("Duplicate...", "title=Hull");
run("Create Selection");
run("Convex Hull");
selectWindow("Hull");
resetThreshold();
run("Measure");
hull = getResult("Area", 1);
density = (area/hull);

//FRACTAL DIMENSION
selectWindow("Area and Perimeter");
run("Duplicate...", "title=Outline");
run("Select None");
run("Outline");
run("FractalCount ", "plot automatic threshold=70 start=24 min="+min_box+" box=1.2 number=3");
logString = getInfo("log");
index = indexOf(logString, "Dimension estimate");
db = substring(logString, (index+20), (index+25));

//RESULTS
myTable(name,unit,area,per,hull,ff,density,db);

//END
selectWindow("Results");
run("Close");
run("Tile");
selectWindow("Quantification results");

function myTable(a,b,c,d,e,f,g,h){
	title1="Quantification results";
	title2="["+title1+"]";
	if (isOpen(title1)){
   		print(title2, a+"\t"+b+"\t"+c+"\t"+d+"\t"+e+"\t"+f+"\t"+g+"\t"+h);
	}
	else{
   		run("Table...", "name="+title2+" width=800 height=300");
   		print(title2, "\\Headings:File\tUnit\tArea\tPerimeter\tHull Area\tForm Factor\tDensity\tFractal (Db)");
   		print(title2, a+"\t"+b+"\t"+c+"\t"+d+"\t"+e+"\t"+f+"\t"+g+"\t"+h);
	}
}
