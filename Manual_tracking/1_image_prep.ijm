//Open the tif image you want to register
//(requires "HyperStackReg" plugin from ved-sharma, https://github.com/ved-sharma/HyperStackReg)

//PREPROCESSING
name=getTitle();
print("\\Clear");
print("Registration in process. Please wait...");
run("HyperStackReg ", "transformation=[Rigid Body] channel"); //uses NcanGFP channel to register
print("Registration DONE");
doCommand("Start Animation [\\]");
waitForUser("Is the registered image OK?. \n \nIf incorrect, CANCEL and restart");

Stack.setChannel(1); //NcanGFP channel
run("Magenta");
run("Brightness/Contrast...");
waitForUser("Adjust brightness and contrast manually in both channels");

save_file=getBoolean("Save image?");
if (save_file==true) {
	dir=getDirectory("Choose a folder to save the files"); //use one folder for each image
	saveAs("Tiff", dir+File.separator+"REG_"+name);
}

  
