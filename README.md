BoutonDetector
==============
release0.0
INSTALLATION:

-Copy the code into installation directory of choice, with:

git clone https://github.com/jsniff/BoutonDetector.git

-Make sure code folder is in MATLAB's path

-Download tvreg from here: http://www.mathworks.com/matlabcentral/fileexchange/29743-tvreg-variational-image-restoration-and-segmentation and put in same directory as working directory

-Make sure tvreg folder is in same path as all .m files.

-set MATLAB path to include tvreg folder and tvreg/tvreg subfolder by manually setting path in MATLAB.


USAGE:

-In working directory, create folder "InputImages", with input *.tif files, all 3 channels.

-Open MATLAB, set path to working directory

-On MATLAB command-line, execute command:

AllGlobalParameters();

OUTPUT:

-BoutonsDetected_list.txt: text file with list of predicted boutons from algorithm

-BoutonsDetected_images: folder with visualization of results (cell masks and bouton positions)







