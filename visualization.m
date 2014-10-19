function [] = visualization(boutonrevised, threshu,uniquemaskarrays, varargin);

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


sizes=size(varargin{1,1});
numvarargs =sizes(2);
if(numvarargs>=1)
if(isempty(varargin{1})~=1)
fullpath = varargin{1,1}{1,1};
imagedir = strcat(fullpath, '/InputImages');
end;
end;

if(numvarargs>1)
if(isempty(varargin{1,1}{1,2})~=1)
UniqueCodeString=varargin{1,1}{1,2};
end;
end;
%cd(imagedir);

if(numvarargs<1)
mkdir('BoutonsDetected_images');
end;
if(numvarargs>1)
pathtoboutonimages = strcat(fullpath,'/BoutonsDetected_images/', UniqueCodeString);
mkdir(strcat(pathtoboutonimages));
end;


Colors = {'k','m','b', 'r', 'm', 'k', 'r', 'm', 'k', 'r', 'm', 'k', 'r', 'm', 'k'};
% Cell array of colors.

%import line by line data, used for image by image visualization
FinalName = 'boutonrevised_full_list.txt'
boutonrevisedallimages= importdata(FinalName)
boutonrevisedallimagesdata = boutonrevisedallimages.data;


cd('InputImages');

TiffFiles=dir(['stack*c001.tif*']);
TiffFiles2=dir(['stack*c002.tif*']);
TiffFiles3=dir(['stack*c003.tif*']);


numberofFiles = length(TiffFiles);
sizes =  size(uniquemaskarrays);
numberofcells = sizes(1);
%used to store bouton id for image by image visualization
labels = cellstr( num2str([1:max(boutonrevisedallimagesdata(:,1))]') );

nonemptyslicecount=0;                    
boundarycounter=0;

                      
for z=1:numberofFiles
                       z
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
                          keyboard;
                          normimageremoveblue = zeros(sizexaxis, sizeyaxis);
                          figure;
                          rgb_image = cat(3, normimage, normimage2,normimage3);
                         imshow(rgb_image);
                          %figure;
                          %rgb_image = cat(3, normimage, normimage2,normimageremoveblue);
                          %imshow(rgb_image);
                          
                          %enhance green channel
                          %figure;
                          %normimageenhanced = normimage2*1.3;
                          %rgb_image = cat(3, normimage, normimageenhanced,  normimageremoveblue);
                          %imshow(rgb_image);
                          
                          
                          %Access Text File with All Image Data, To Visualize for Every Image Slice
                          
                          
                          %for plotting borders around cells
                          
                          TestMatrix = zeros(351,992);
                     
                     sizecellmaskboundary=0;
                     CentroidMaskx=0;
                      CentroidMasky =0;
                      for a = 1:numberofcells
                        x=uniquemaskarrays(a,z).xcoords_array;
                        y=uniquemaskarrays(a,z).ycoords_array;
                        clear B; clear L; clear N;
                        [B,L,N] = bwboundaries(uniquemaskarrays(a,z).imagecellmask);
                          
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
                           sizecellmaskboundary = length(boundary(:,2));
                          %boundarymasterone = boundary(:,2); % remove if not used
                          %boundarymastertwo = boundary(:,1); % remove if not used
                         end;
                       end;
                       
                       CentroidMaskx = mean(uniquemaskarrays(a,z).xcoords_array);
                       CentroidMasky = mean(uniquemaskarrays(a,z).ycoords_array);              
                       sizecellmask = nnz(uniquemaskarrays(a,z).imagecellmask);
                       
%                           for j = 1:length(x)
%                            TestMatrix(y(j),x(j))=1;
%                           end;
                      end;
                      %BW=TestMatrix;
                                                 
   
                      for i = 1:length(boutonrevisedallimagesdata)
                          labelexample = cellstr(num2str(boutonrevisedallimagesdata(i,1)));
                        if (boutonrevisedallimagesdata(i,2)==z)
                          hold on;
                          %Visualization for line by line data, used for image by image visualization
                          plot(boutonrevisedallimagesdata(i,3),boutonrevisedallimagesdata(i,4),'color',Colors{boutonrevisedallimagesdata(i,5)},'marker','o', 'MarkerSize', 5),
                          text(boutonrevisedallimagesdata(i,3), boutonrevisedallimagesdata(i,4),  labelexample, 'VerticalAlignment','bottom','HorizontalAlignment','right', 'Color','y', 'FontSize',5),
                          hold on;
                         
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
                          
                          if(numvarargs<=1)
                          saveas(hfig,strcat('../BoutonsDetected_images/', nameofimage), 'jpeg');
                          end;
                          if(numvarargs>1)
                          if(isempty(varargin{1,1}{1,2})~=1)
                          specificdirectorynameofimage = strcat(pathtoboutonimages, '/',nameofimage);
                          saveas(hfig,specificdirectorynameofimage, 'png'); 
                          end;
                          end;
                          
                          %saveas(hfig,nameofimage, 'png'); 
                          
end;
                 
                          cd ../
                          
                          
                          
                          
                          

                          
  
