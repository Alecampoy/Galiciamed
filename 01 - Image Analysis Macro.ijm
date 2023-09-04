///////////////////////////////////////////////////////////////////////////////////////////////
/* Author: Ale Campoy
 * Microscopy Unit (CABD)
 * Date: 21.09.2020
 * User: Ana Brokate - Project Galiciamed
 * 	
 * Description: This macro quantifies the expresion of SMN1 in C.elegans confocal images
 * 
 * Exectution: Run the macro when an image of C.elegans SMN1 expresion is open
 * Output: Result table & ROI
 * 
 *///////////////////////////////////////////////////////////////////////////////////////////////

// Clean Fiji
run("Clear Results");
counts = roiManager("count");
if(counts !=0) {roiManager("delete");}

// Set metadata and set fiji
original = getImageID();
dir = getInfo("image.directory");
title = getTitle();
rename("original");
getDimensions(width, height, channels, slices, frames);
Stack.setXUnit("nm");
run("Properties...", "channels="+channels+" slices="+slices+" frames="+frames+" pixel_width=208.7667 pixel_height=208.7667 voxel_depth=1000.0000"); // Proper pixel width
run("Set Measurements...", "area mean standard modal min perimeter shape integrated median display redirect=None decimal=0");

// Draw the ROI where the measurement is performed
waitForUser("Draw an Area containing the ROI and press OK");
setBackgroundColor(0, 0, 0);
run("Clear Outside", "stack");
run("Select None");

// Choose the Red channel of interest
if(channels !=1) {
run("Split Channels");
selectWindow("C2-original");
close();
selectWindow("C1-original");
rename("original");}
run("Duplicate...", "title=filtered duplicate channels=1");
duplicado = getImageID();

// Process
run("Unsharp Mask...", "radius=2 mask=0.55"); // deberia de tener stack
run("Gaussian Blur...", "sigma=1");

// Threshold of the SNM1 expresion clusters
run("3D OC Options", "volume surface nb_of_obj._voxels nb_of_surf._voxels integrated_density mean_gray_value std_dev_gray_value median_gray_value minimum_gray_value maximum_gray_value centroid bounding_box show_masked_image_(redirection_requiered) dots_size=5 font_size=10 redirect_to=original");
run("3D Objects Counter", "threshold=1500 slice=1 min.=3 max.=18874368 statistics"); // Intensity Threshold and Size Filter
wait(50);

// Save the results
selectWindow("Masked image for filtered redirect to original");
saveAs("Tiff", dir+"Mascara de"+title+".tif");
getDimensions(width, height, channels, slices, frames);
setThreshold(5, 65535);
run("Convert to Mask", "background=Dark");
for (i=1; i<slices+1; i++) {
	Stack.setSlice(i);
	run("Create Selection");
	if (selectionType !=-1) {
	roiManager("Add"); 
	};
};
roiManager("save", dir+"Rois_to_check_"+title+".zip"); 
	
selectWindow("Results");
saveAs("Results", dir+"results_of_"+title+".xls");
run("Close");
close("*");




