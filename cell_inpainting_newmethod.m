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

TiffFiles=dir(['*c0003.tif']);

%TiffFiles=dir(['*C3-C1-3--z1-75(leftedgeROI),CAcorr,z5-73,BChm--Cell003*.tif']);
%TiffFiles=dir(['*z0074_c0002.tif']);
numberofFiles = length(TiffFiles);
nonemptyslicecount=0;
for z=1:numberofFiles;
z
FileName=TiffFiles(z).name

%Renormalize Image for Dsiplay
image=imread(FileName);

maxim=double(max(max(image)));

normimage=double(image)/double(maxim);



TiffFiles2=dir(['*c0001.tif']);

%TiffFiles=dir(['*z0074_c0002.tif']);
numberofFiles = length(TiffFiles2);
FileName=TiffFiles2(z).name


%Renormalize Image for Dsiplay
image=imread(FileName);

maxim=double(max(max(image)));

normimage2=double(image)/double(maxim);

%%normimage2 = normimage;


%normimage = normimage-normimage2;


 sizes = size(normimage);
 newimage = zeros(sizes);

for i = 1:sizes(1)
    for j = 1:sizes(2)
        if(normimage(i,j)-normimage2(i,j)>0);
       newimage(i,j) =  normimage(i,j)-normimage2(i,j);
        else
            newimage(i,j) = 0;
    end;
    end;
end;


    normimage = newimage;
        

%Apply Thresholding and Connectivity Parameters
CellThresholdParameter = 1.5*mean(mean(normimage));
%binimage.temp = im2bw(normimage, 0.04);
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

imshow(f);


figure(5);

clf;
set(gcf,'Color',[1,1,1],'NumberTitle','off','Name','TV Inpainting');
compareimages(f,'Input',f,'Inpainted');
shg;

% Inpaint
u = tvinpaint(f,lambda,D,[],[],[],@tvregsimpleplot);
title('Inpainted');


figure(6);
imshow(u);
figure(7);
blackandwhitefigure=figure;
threshu=im2bw(u,0.7);
imshow(threshu);
close all;
figure(1);
hold on;
inpaintedfigure = figure;
hold on;
IM2 = imcomplement(threshu);
imshow(IM2);
namenumber = num2str(z);
nameinpaintedfigure = 'inpaintedfiguregraychannel';
nameblackandwhitefigure = 'blackandwhitefigurechannel';
nameinpainted = cat(2,namenumber,nameinpaintedfigure);
nameblackandwhitefigure = cat(2,namenumber,nameblackandwhitefigure);
saveas(inpaintedfigure,nameinpainted, 'jpg');
saveas(blackandwhitefigure,nameblackandwhitefigure, 'jpg');
[rLgray, rN] = bwlabel(IM2);






%TiffFiles2=dir(['*C1-C1-3--z1-75(leftedgeROI),CAcorr,z5-73,BChm--Cell003*.tif']);
TiffFiles2=dir(['*c0001.tif']);

%TiffFiles=dir(['*z0074_c0002.tif']);
numberofFiles = length(TiffFiles2);
FileName=TiffFiles2(z).name

%Renormalize Image for Dsiplay
image=imread(FileName);

maxim=double(max(max(image)));

normimage=double(image)/double(maxim);

normimage2 = normimage;

%Apply Thresholding and Connectivity Parameters

%binimage.temp = im2bw(normimage, 0.28);
%CellThresholdParameterRed = .08;
CellThresholdParameterRed = .235;
binimage.temp = im2bw(normimage, CellThresholdParameterRed);

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

imshow(f);


figure(5);

clf;
set(gcf,'Color',[1,1,1],'NumberTitle','off','Name','TV Inpainting');
compareimages(f,'Input',f,'Inpainted');
shg;

% Inpaint
u = tvinpaint(f,lambda,D,[],[],[],@tvregsimpleplot);
title('Inpainted');
figure(6);
imshow(u);
figure(7);
blackandwhitefigure=figure;
threshu=im2bw(u,0.7);
imshow(threshu);
close all;
figure(1);
hold on;
inpaintedfigure = figure;
hold on;
IM3 = imcomplement(threshu);
imshow(IM3);
namenumber = num2str(z);
nameinpaintedfigure = 'inpaintedfigure';
nameblackandwhitefigure = 'blackandwhitefigure';
nameinpainted = cat(2,namenumber,nameinpaintedfigure);
nameblackandwhitefigure = cat(2,namenumber,nameblackandwhitefigure);
saveas(inpaintedfigure,nameinpainted, 'jpg');
saveas(blackandwhitefigure,nameblackandwhitefigure, 'jpg');
[rLred, rN] = bwlabel(IM3);




%get rid of overlapping red channels;
intersectionimage = IM2-IM3;



%intersectionimage=rLred&rLgray;

%intersectionimage=rLgray;


[rL, rN] = bwlabel(intersectionimage);
close all;
figure(1);
inpaintedfigure=figure;
imshow(rL);
nameinpaintedfigure2 ='inpaintedfigure2';
nameblackandwhitefigure2 = 'blackandwhitefigure2';
nameinpainted2 = cat(2,namenumber,nameinpaintedfigure2);
nameblackandwhitefigure2 = cat(2,namenumber,nameblackandwhitefigure2);
saveas(inpaintedfigure,nameinpainted2, 'jpg');
%saveas(blackandwhitefigure,nameblackandwhitefigure2, 'jpg');


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

[cellinfomaskunique, uniquemaskarrays, threshu] = uniquecellinfo(cellinfomask, threshu);
