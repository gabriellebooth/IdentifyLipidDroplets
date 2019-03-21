

// Split .lif to .tiff, returns a list of the generated files
// Manually open a lif file in Fiji and run this code


function lifToTiff() {
waitForUser("Choose a Directory to Store the Images");
input = getDirectory("Choose a Directory");

while (nImages > 0){
	selectImage(nImages);
	name = getTitle();
	arg = input + name + ".tif"; 
	saveAs("tiff", arg);
	close();
}
return getFileList(input);
}



// run tiffs through function

// for now just add the filename to the csv result file

// in the future I want to export the data in sections ie control, male, female