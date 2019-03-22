// Trying to Identify Lipid Dropplets


run("Set Measurements...", "area mean centroid shape redirect=None decimal=3");

run("Split Channels");
selectWindow("C1-example 1.tif");
close();
selectWindow("C3-example 1.tif");
close();
selectWindow("C2-example 1.tif");
//run("Brightness/Contrast...");

run("Z Project...", "projection=[Sum Slices]");
run("Enhance Contrast", "saturated=0.35");

// Gaussian blur -- smooth jagged edges
run("Size...", "width=3000 height=3000 constrain average interpolation=Bicubic");
run("Median...");

// Copy before thresholding
run("Duplicate...");

// Threshold based on fluorescence
selectWindow("SUM_C2-example 1.tif");
setAutoThreshold("Li dark");
run("Convert to Mask");

// Watershed to separate connected dropplets
run("Watershed");

// Threshold based primarily on circularity
run("Analyze Particles...", "  circularity=0.80-1.00 show=Outlines add");
roiManager("Deselect");
selectWindow("SUM_C2-example 1-1.tif");
roiManager("Measure");

roiManager("Delete");

waitForUser("Closing all images");
while(nImages > 0) {
	selectImage(nImages);
	close();
}







