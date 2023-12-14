setBatchMode(true); // Enable batch mode to prevent display updates

//folder="E:/Immunohisto/Nuno6 - y;;Chat-3xGal80"; //change for each batch of images
projection = "Max Intensity"; //possible: projection=[Max Intensity], projection=[Standard Deviation]
//define subfolder to save tif files into	
subfolder = "flattened-"+"projection"+"/";

folder = getDirectory("Choose a Folder"); // Prompt the user to choose a folder


list = getFileList(folder);
//
for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".czi")) { // process only .czi files
        file_name = list[i];
        //open(folder+file_name);
        file_to_open = folder+file_name;
        run("Bio-Formats Importer", "open=file_to_open color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
        run("Z Project...", "projection=["+projection+"]"); //possible: projection=[Max Intensity], projection=[Standard Deviation]
        run("Stack to RGB"); 
		
		file_name_substr = substring(file_name, 0, lengthOf(file_name) - 4); //exclude the .czi extension
		
		
		//change name of file depending on projection type (in Z Project...)
		if (projection == "Max Intensity") {
			name_append = "MAX"; //"MAX is coherent with imageJ-s internal nomenclature
		}
		if (projection == "Standard Deviation") {
			name_append = "StDev";
		}
		
		
		//save file	
        saving_file_name = folder+file_name_substr+name_append+".tif";

        saveAs("Tiff", saving_file_name);
        //open(saving_file_name);
    
	}
}

setBatchMode(false); // Disable batch mode at the end of the script

//waitForUser;
//run("Close All");
