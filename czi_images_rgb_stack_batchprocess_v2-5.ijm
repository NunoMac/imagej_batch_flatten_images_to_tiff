//this version sets a limit of 3 images to be processed because of memory contraints

setBatchMode(true); // Enable batch mode to prevent display updates

//USER defines type of interaction in dialog box
////////////////////////// Ask the user to choose a projection method///////////////////////

Dialog.create("Type of Projection");
//input 1
Dialog.addChoice("Type:", newArray("Max Intensity", "Standard Deviation"));

// Help button that opens a webpage
Dialog.addHelp("https://imagej.net/ij/macros/DialogDemo.txt");

// show the GUI
Dialog.show();

//output 1
projection  = Dialog.getChoice();

print("Projection is: "+ projection)
////////////////////////////////////////////////////////////////////////////////////////////



//projection = "Standard Deviation"; //possible: projection=[Max Intensity], projection=[Standard Deviation]
//define subfolder to save tif files into	
subfolder = "flattened-"+projection;




////////////////////////// Ask the user to choose a folder to process ///////////////////////
//USER chooses the folder the images are in
folder = getDirectory("Choose a Folder"); // Prompt the user to choose a folder

/////////////////////////////////////////////////////////////////////////////////////////////



//new subfolder variable
new_subfolder = folder+subfolder+"\\";


File.makeDirectory(new_subfolder);

print("Files will be saved in: "+new_subfolder)



list = getFileList(folder);

count=0


//
for (i = 0; i < list.length; i++) {
	print("cycle: "+i);
	
	//allow user to interrupt macro if needed
	interruptMacro = isKeyDown("space");
    if (interruptMacro == true) {
        print("interrupted");
        setKeyDown("none");
        setBatchMode(false);
        break;
    }
    
    //limits 3 images at a time
    //if (count == 4) {
    //	print("3 images analyzed");
    //	setBatchMode(false);
    //	break;
    //}
   
	
    if (endsWith(list[i], ".czi")) { // process only .czi files
    	count += 1;
    	print("count: "+count);
    	print("working on file: "+i+1+" of "+list.length);
        file_name = list[i];
        //open(folder+file_name);
        file_to_open = folder+file_name;
        run("Bio-Formats Importer", "open=file_to_open color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
        run("Z Project...", "projection=[" + projection + "]"); //possible: projection=[Max Intensity], projection=[Standard Deviation]
        run("Stack to RGB"); 
		
		file_name_substr = substring(file_name, 0, lengthOf(file_name) - 4); //exclude the .czi extension
		
		
		//change name of file depending on projection type (in Z Project...)
		if (projection == "Max Intensity") {
			name_append = "-MAX"; //"MAX is coherent with imageJ-s internal nomenclature
		}
		if (projection == "Standard Deviation") {
			name_append = "-StDev";
		}
		
		//save file	
        saving_file_name = new_subfolder+file_name_substr+name_append+".tif";

        saveAs("Tiff", saving_file_name);
        //open(saving_file_name);
        
        print(IJ.currentMemory());
        print(IJ.freeMemory());
        
        run("Close All");
    
	}
}

setBatchMode(false); // Disable batch mode at the end of the script
print("You got the end of misery with the lightness of Alice in Wonderland.")
print("Congratulations!")
print("I mean... All your files have been processed and saved.")

waitForUser;
run("Close All");

