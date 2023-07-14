///////////////////////////////////////////////////////////////////////////////////////////////
/* Author: Ale Campoy
 * Microscopy Unit (CABD)
 * Date: 21.09.2020
 * User: Ana Brokate 
 * 	
 * Description: Measure the amount, size and expresion of the clusters on red channel on a 3D manner
 * 
 * Input:  .tiff
 * Output: Result table & ROI
 * 
 *///////////////////////////////////////////////////////////////////////////////////////////////

//Borramos todo lo que pueda haber
run("Clear Results");
counts = roiManager("count");
if(counts !=0) {roiManager("delete");}

original = getImageID();
dir = getInfo("image.directory");
title = getTitle();
rename("original");
getDimensions(width, height, channels, slices, frames);
Stack.setXUnit("nm");
run("Properties...", "channels="+channels+" slices="+slices+" frames="+frames+" pixel_width=208.7667 pixel_height=208.7667 voxel_depth=1000.0000");

run("Set Measurements...", "area mean standard modal min perimeter shape integrated median display redirect=None decimal=0");
waitForUser("Dibuja un area que contenga el ROI y pulsa OK. Manten pulsada la tecla Shift para varias zonas");
setBackgroundColor(0, 0, 0);
run("Clear Outside", "stack");
run("Select None");

if(channels !=1) {
run("Split Channels");
selectWindow("C2-original");
close();
selectWindow("C1-original");
rename("original");}

run("Duplicate...", "title=filtered duplicate channels=1");
duplicado = getImageID();

run("Unsharp Mask...", "radius=2 mask=0.55"); // deberia de tener stack
run("Gaussian Blur...", "sigma=1");

//hay que ajustar el volumen minimo, preguntar a Ana Maria
run("3D OC Options", "volume surface nb_of_obj._voxels nb_of_surf._voxels integrated_density mean_gray_value std_dev_gray_value median_gray_value minimum_gray_value maximum_gray_value centroid bounding_box show_masked_image_(redirection_requiered) dots_size=5 font_size=10 redirect_to=original");
run("3D Objects Counter", "threshold=1500 slice=1 min.=3 max.=18874368 statistics"); //cambiar aqui threshold si necesario y poner filtro de voxel size
wait(50);

selectWindow("Masked image for filtered redirect to original");
saveAs("Tiff", dir+"Mascara de"+title+".tif");
getDimensions(width, height, channels, slices, frames);
setThreshold(5, 65535);
run("Convert to Mask", "background=Dark");
for (i=1; i<slices+1; i++) {
	Stack.setSlice(i);
	run("Create Selection");
	if (selectionType !=-1) {
	roiManager("Add"); //se añade el roi del disco, se renombra y mide para tener el area
	};
};
roiManager("save", dir+"Rois_to_check_"+title+".zip"); //salvamos el ROI 
	
selectWindow("Results");
saveAs("Results", dir+"results_of_"+title+".xls");
run("Close");
close("*");




