BoutonDetector
==============
release0.0
INSTALLATION:

-Copy the code into installation directory of choice, with:

git clone https://github.com/jsniff/BoutonDetector.git

-Make sure code folder is in MATLAB's path

-Make sure tvreg folder is in same path as all .m files.


USAGE:

-In working directory, create folder "InputImages", with input *.tif files, all 3 channels.

-Open MATLAB, navigate to working directory

-On MATLAB command-line, execute command:

-Make sure TVREG folder and the TVREG folder within the outer TVREG folder is in the set path.

AllGlobalParameters();

OUTPUT:

-BoutonsDetected_list.txt: text file with list of predicted boutons from algorithm

-BoutonsDetected_images: folder with visualization of results (cell masks and bouton positions)







