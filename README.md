BoutonDetector
==============
INSTALLATION:

-Copy the code into installation directory of choice, with:

git clone https://github.com/jsniff/BoutonDetector.git

-Make sure code folder is in MATLAB's path

-Download tvreg from here: http://www.mathworks.com/matlabcentral/fileexchange/29743-tvreg-variational-image-restoration-and-segmentation and put in MATLAB path, including the tvreg folder and tvreg/tvreg subfolder.




USAGE:

-In working directory, create folder "InputImages", with input *.tif files, all 3 channels.

-Open MATLAB, set path to working directory

-On MATLAB command-line, execute command:

AllGlobalParameters();

OUTPUT:

-BoutonsDetected_list.txt: text file with list of predicted boutons from algorithm

-BoutonsDetected_images: folder with visualization of results (cell masks and bouton positions)







