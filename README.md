# imagej_batch_flatten_images_to_tiff
This is a ImageJ macro script to automate the processing of image files in a specified folder.
It enables batch mode to prevent display updates during processing. The script filters for .czi files (common in microscopy) and applies a specified Z-projection (either Max Intensity or Standard Deviation) to each file.
It then converts the images to RGB format, appends a specific name based on the projection type, and saves them in a new subfolder as .tif files.