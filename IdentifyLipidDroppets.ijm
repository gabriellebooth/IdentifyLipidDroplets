// Identify Lipid Dropplets

// Takes a lif file and generates 2 excel files-- one with GFP data and the other with
// the LD information.

run("Set Measurements...", "area mean centroid shape redirect=None decimal=3");
waitForUser("Choose output directory");
output = getDirectory("Choose a Directory");

//open the image and get its name
//open(input + image);
name = getTitle(); 
dotIndex = indexOf(name, "."); 
title = substring(name, 0, dotIndex); 

// Assuming 
// C1: Nucleus
// C2: Lipid Droplets
// C3: GFP

run("Split Channels");
selectWindow("C1-" + name);
close();

// Make sure the images are the proper size (pre-threshold)
selectWindow("C3-" + name);
setUpChannel(); // for C3

selectWindow("C2-" + name);
setUpChannel(); // for C2

// Copy before thresholding
run("Duplicate...");

// Threshold based on fluorescence
selectWindow("SUM_C2-" + name);
setAutoThreshold("Li dark");
run("Convert to Mask");

// Watershed to separate connected dropplets
run("Watershed");

// Threshold based primarily on circularity
run("Analyze Particles...", "  circularity=0.80-1.00 show=Outlines add");
roiManager("Deselect");
selectWindow("SUM_C2-" + title + "-1.tif"); // Using the pre-thresholded version

roiManager("Measure");
	// Save results file
	arg = output + title + "LD" +".csv"; // will need to change name
	saveAs("resultsLD", arg);
	selectWindow("Results");
	run("Close");
	


// Run analysis on GFP image
selectWindow("SUM_C3-" + name);
roiManager("Deselect");
roiManager("Measure");

	arg = output + title + "GFP" + ".csv";
	saveAs("resultsGFP", arg);
	selectWindow("Results");
	run("Close");

roiManager("Delete");

waitForUser("Closing all images");
while(nImages > 0) {
	selectImage(nImages);
	close();
}

waitForUser("Find Results in your Output Directory");



// Functions

function setUpChannel() {
run("Z Project...", "projection=[Sum Slices]");
run("Enhance Contrast", "saturated=0.35");

// Gaussian blur -- smooth jagged edges
run("Size...", "width=3000 height=3000 constrain average interpolation=Bicubic");
run("Median...");
}



