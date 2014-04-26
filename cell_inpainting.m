function [cellinfomaskunique, uniquemaskarrays, threshu] = cell_inpainting()
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

TiffFiles=dir(['*c0001.tif']);
%TiffFiles=dir(['*z0074_c0002.tif']);
numberofFiles = length(TiffFiles);
nonemptyslicecount=0;
for z=1:numberofFiles
FileName=TiffFiles(z).name

 %Renormalize Image for Dsiplay 
image=imread(FileName);

maxim=double(max(max(image)));

normimage=double(image)/double(maxim);

%Apply Thresholding and Connectivity Parameters

%binimage.temp = im2bw(normimage, 0.28);
binimage.temp = im2bw(normimage, CellThresholdParameter);

%save image right before;
figure(1);
imshow(binimage.temp);
inpaintedfigure =figure(1);
namenumber = num2str(z);


namenumber = num2str(z);
nameinpaintedfigure = 'rightafterthreshold';
nameinpainted = cat(2,namenumber,nameinpaintedfigure);
%saveas(inpaintedfigure,nameinpainted, 'jpg');

close all;

binimage = bwareaopen(binimage.temp, CellconnectivitySize);
figure(2);
imshow(binimage);
inpaintedfigure =figure(2);




namenumber = num2str(z);
nameinpaintedfigure = 'rightaftersize';
nameinpainted = cat(2,namenumber,nameinpaintedfigure);
%saveas(inpaintedfigure,nameinpainted, 'jpg');


bwimage=double(imcomplement(binimage));

bwimage(:,:,2) = bwimage(:,:,1);
bwimage(:,:,3) = bwimage(:,:,1);


% Construct inpainting region

lambda = 1e4;

[x,y] = meshgrid(1:size(bwimage,2),1:size(bwimage,1));

D = (sqrt(x.^2+y.^2) >= 0);

f = bwimage;

f(D) = rand(nnz(D),1);

%figure(4);

%imshow(f);


figure(5);

clf;
set(gcf,'Color',[1,1,1],'NumberTitle','off','Name','TV Inpainting');
compareimages(f,'Input',f,'Inpainted');
shg;

% Inpaint

u = tvinpaint(f,lambda,D,[],[],[],@tvregsimpleplot);
title('Inpainted');
figure(6);
inpaintedfigure =figure;
imshow(u);
figure(7);
blackandwhitefigure=figure;
threshu=im2bw(u,0.7);
imshow(threshu);
namenumber = num2str(z);
nameinpaintedfigure = 'inpaintedfigure';
nameblackandwhitefigure = 'blackandwhitefigure';
nameinpainted = cat(2,namenumber,nameinpaintedfigure);
nameblackandwhitefigure = cat(2,namenumber,nameblackandwhitefigure);
%saveas(inpaintedfigure,nameinpainted, 'jpg');  
%saveas(blackandwhitefigure,nameblackandwhitefigure, 'jpg');
close all;
IM2 = imcomplement(threshu);
[rL, rN] = bwlabel(IM2);


%return only slices with cells
  if(rN>0)
%nonemptyslicecount slice index chosen to avoid gaps in cellinfomask array index
   nonemptyslicecount = nonemptyslicecount+1;
       end;
   for i =1:rN
        [ycoordinatesmask, xcoordinatesmask] = find(rL==i);
        maskcentroidx = mean(xcoordinatesmask);
        maskcentroidy = mean(ycoordinatesmask);
        cellinfomask(nonemptyslicecount,i).imageslice = z;
        cellinfomask(nonemptyslicecount,i).centroidposx = maskcentroidx;
        cellinfomask(nonemptyslicecount,i).centroidposy = maskcentroidy;
        cellinfomask(nonemptyslicecount,i).ycoordinatesmask = ycoordinatesmask;
        cellinfomask(nonemptyslicecount,i).xcoordinatesmask = xcoordinatesmask;
        cellinfomask(nonemptyslicecount,i).imagecellmask = rL;
   end;%end;

 end;
 cd ../
 
 [cellinfomaskunique, uniquemaskarrays, threshu] = uniquecellinfo(cellinfomask, threshu);

 



