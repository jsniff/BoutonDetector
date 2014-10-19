function [cellinfomaskunique, uniquemaskarrays, threshu] = cell_inpainting_newmethod()
global CellThresholdParameter;
global CellconnectivitySize;
global CellSizeLengthParameter;
global CellSizeDistance;
global CellNumberofImages;


global GaussianFilterRadius;
global ConnectivitySize;
global AcceptanceCellDistance;
global DoubleCountDistance;
global BoutonThresholdParameter;
global GaussianSigma;



%function [cellinfomaskunique, uniquemaskarrays, cellinfomask] = cell_inpainting()
% directory =cd(cd('..'));
% imagedir = strcat(directory, '/InputImages')
% cd(imagedir);

cd('InputImages');

TiffFilesred=dir(['*c001.tif*']);
TiffFilesgray=dir(['*c003.tif*']);


%TiffFiles=dir(['*C3-C1-3--z1-75(leftedgeROI),CAcorr,z5-73,BChm--Cell003*.tif']);
%TiffFiles=dir(['*z0074_c0002.tif']);
numberofFiles = length(TiffFilesgray)
nonemptyslicecount=0;
for z=1:numberofFiles;
    z
redtiffimages = TiffFilesred(z).name;
graytiffimages = TiffFilesgray(z).name;
originalgrayfile =imread(redtiffimages);
originalredfile =imread(graytiffimages);
intersection = originalgrayfile & originalredfile;
[rL, rN] = bwlabel(intersection);
name = num2str(z);

if(numel(num2str(z)))==1;
numberaddon = 'intersection000';
end;
if(numel(num2str(z)))==2;
numberaddon = 'intersection00';
end;
if(numel(num2str(z)))==3;
numberaddon = 'intersection0';
end;

nameofimage = cat(2,numberaddon,name);
%pathtoboutonimages = strcat('../BoutonsDetected_images/', UniqueCodeString);
%specificdirectorynameofimage = strcat(pathtoboutonimages, '/',nameofimage);
figure;
imshow(intersection)
hfig = imgcf;

saveas(hfig,nameofimage, 'png');
close all;

%return only slices with cells
if(rN>0)
nonemptyslicecount = nonemptyslicecount+1
end;
for i =1:rN
[ycoordinatesmask, xcoordinatesmask] = find(rL==i);
%Code used to generate cell mask per cell
CellMask = zeros(size(rL));
for j = 1:length(xcoordinatesmask)
CellMask(ycoordinatesmask(j),xcoordinatesmask(j))=1;
end;
maskcentroidx = mean(xcoordinatesmask);
maskcentroidy = mean(ycoordinatesmask);
cellinfomask(nonemptyslicecount,i).imageslice = z;
cellinfomask(nonemptyslicecount,i).centroidposx = maskcentroidx;
cellinfomask(nonemptyslicecount,i).centroidposy = maskcentroidy;
cellinfomask(nonemptyslicecount,i).ycoordinatesmask = ycoordinatesmask;
cellinfomask(nonemptyslicecount,i).xcoordinatesmask = xcoordinatesmask;
cellinfomask(nonemptyslicecount,i).imagecellmask = CellMask;
end;%end;

end;
cd ../
threshu = intersection;
[cellinfomaskunique, uniquemaskarrays, threshu] = uniquecellinfo(cellinfomask, threshu);

%uniquemaskarrays = cellinfomask;
%cellinfomaskunique = cellinfomask;
%[cellinfomaskunique, uniquemaskarrays, threshu] = uniquecellinfo(cellinfomask, threshu);
