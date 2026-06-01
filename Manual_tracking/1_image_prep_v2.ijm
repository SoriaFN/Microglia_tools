// ============================================================
// Check for required plugins before running
// ============================================================

// Check for TurboReg (dependency of HyperStackReg)
turboreg_found = false;
plugins_dir = getDirectory("plugins");
turboreg_path = plugins_dir + "TurboReg_.jar";
if (File.exists(turboreg_path)) {
	turboreg_found = true;
} else {
	// Also check common subdirectories where update sites install jars
	sub_path = plugins_dir + "BIG-EPFL" + File.separator + "TurboReg_.jar";
	if (File.exists(sub_path)) {
		turboreg_found = true;
	} else {
		// Last resort: check if the command is registered
		List.setCommands;
		if (List.get("TurboReg ") != "") {
			turboreg_found = true;
		}
	}
}

if (!turboreg_found) {
	showMessage("Missing plugin: TurboReg",
		"TurboReg is required but was not found.\n\n" +
		"To install it:\n" +
		"1. Open FIJI > Help > Update...\n" +
		"2. Click 'Manage update sites'\n" +
		"3. Enable the 'BIG-EPFL' update site\n" +
		"4. Click 'Apply and Close', then 'Apply Changes'\n" +
		"5. Restart FIJI\n\n" +
		"The macro will now exit.");
	exit();
}

// Check for HyperStackReg
hsr_found = false;
hsr_path = plugins_dir + "HyperStackReg_.class";
if (File.exists(hsr_path)) {
	hsr_found = true;
} else {
	List.setCommands;
	if (List.get("HyperStackReg ") != "") {
		hsr_found = true;
	}
}

if (!hsr_found) {
	showMessage("Missing plugin: HyperStackReg",
		"HyperStackReg is required but was not found.\n\n" +
		"To install it:\n" +
		"1. Download HyperStackReg_.class from:\n" +
		"   github.com/ved-sharma/HyperStackReg\n" +
		"2. Copy the file into your FIJI plugins folder:\n" +
		"   " + plugins_dir + "\n" +
		"3. Restart FIJI\n\n" +
		"The macro will now exit.");
	exit();
}

// ============================================================
// PREPROCESSING
// ============================================================

name = getTitle();
print("\\Clear");
print("Registration in process. Please wait...");
run("HyperStackReg ", "transformation=[Rigid Body] channel"); //uses NcanGFP channel to register
print("Registration DONE");
doCommand("Start Animation [\\]");
waitForUser("Is the registered image OK?. \n \nIf incorrect, CANCEL and restart");

Stack.setChannel(1); //NcanGFP channel
run("Green");
run("Brightness/Contrast...");
waitForUser("Adjust brightness and contrast manually in both channels");

save_file = getBoolean("Save image?");
if (save_file == true) {
	dir = getDirectory("Choose a folder to save the files"); //use one folder for each image
	saveAs("Tiff", dir + File.separator + "REG_" + name);
}
