function [] = visualization(boutonrevised, threshu,uniquemaskarrays);

% global CellThresholdParameter;
% global CellconnectivitySize;
% global CellSizeLengthParameter;
% global CellSizeDistance;
% global CellNumberofImages;
% 
% 
% global GaussianFilterRadius;
% global ConnectivitySize;
% global AcceptanceCellDistance;
% global DoubleCountDistance;
% global BoutonThresholdParameter;
% global GaussianSigma;

% Create visualization output folder
mkdir('BoutonsDetected_images')

Colors = {'r','y','b', 'r', 'y', 'k', 'r', 'y', 'k', 'r', 'y', 'k', 'r', 'y', 'k'};
% Cell array of colros.

cd('InputImages');

TiffFiles=dir(['*c0001.tif']);
TiffFiles2=dir(['*c0002.tif']);
TiffFiles3=dir(['*c0003.tif']);

numberofFiles = length(TiffFiles);
sizes =  size(uniquemaskarrays);
numberofcells = sizes(1);
labels = cellstr( num2str([1:length(boutonrevised)]') ); 
nonemptyslicecount=0;


for z=1:sizes(2)
    close all;
FileName=TiffFiles(z).name;
FileName2=TiffFiles2(z).name;
FileName3=TiffFiles3(z).name;
originalfile =imread(FileName);
maxim=double(max(max(originalfile)));
normimage=double(originalfile)/double(maxim);

originalfile =imread(FileName2);
maxim = double(max(max(originalfile)));
normimage2 = double(originalfile)/double(maxim);


originalfile =imread(FileName3);
maxim=double(max(max(originalfile)));
normimage3=double(originalfile)/double(maxim);

                          
                          
%remove blue channel as it's not needed
sizeimage = size(normimage2);
sizexaxis = sizeimage(1);
sizeyaxis = sizeimage(2);
normimageremoveblue = zeros(sizexaxis, sizeyaxis);
%figure;
rgb_image = cat(3, normimage, normimage2,normimage3);
imshow(rgb_image);
%figure;
rgb_image = cat(3, normimage, normimage2,normimageremoveblue);
imshow(rgb_image);
                          
%enhance green channel
%figure;
normimageenhanced = normimage2*1.3;
rgb_image = cat(3, normimage, normimageenhanced,  normimageremoveblue);
imshow(rgb_image);
                          


%for plotting borders around cells

TestMatrix = zeros(351,992);


for a = 1:numberofcells 
    x=uniquemaskarrays(a,z).xcoords_array;
    y=uniquemaskarrays(a,z).ycoords_array;
for j = 1:length(x)
TestMatrix(y(j),x(j))=1;
end;
end;
BW=TestMatrix;

[B,L,N] = bwboundaries(BW); 
for i = 1:length(boutonrevised)
if (boutonrevised(i).originalimageslice <=z) && (boutonrevised(i).imageslice >=z)
hold on;
%plot(boutonrevised(i).centroidposx,boutonrevised(i).centroidposy,'g*', 'MarkerSize',5)
plot(boutonrevised(i).centroidposx,boutonrevised(i).centroidposy,'color',Colors{boutonrevised(i).cellnumber},'marker','o', 'MarkerSize', 10),
text(boutonrevised(i).centroidposx, boutonrevised(i).centroidposy, labels(i), 'VerticalAlignment','bottom','HorizontalAlignment','right', 'Color','y', 'FontSize',15),
hold on;

  for k=1:length(B),
    boundary = B{k};
    if(k > N)
        hold on;
        plot(boundary(:,2),...
            boundary(:,1),'g','LineWidth',1);
        hold on;
    else
        hold on;
        plot(boundary(:,2),...
            boundary(:,1),'r','LineWidth',1);
        hold on;
    end
end
 end;
end;

%pad visualization frame names with zeros

 name = num2str(z);
 
 if(numel(num2str(z)))==1;
     numberaddon = '000';
 end;
 if(numel(num2str(z)))==2;
     numberaddon = '00';
 end;
 if(numel(num2str(z)))==3;
     numberaddon = '0';
 end;
 
 nameofimage = cat(2,numberaddon,name);
 hfig = imgcf;
 
 
saveas(hfig,strcat('../BoutonsDetected_images/', nameofimage), 'jpeg');


%saveas(hfig,nameofimage, 'png'); 
 
end;
  
cd ../
