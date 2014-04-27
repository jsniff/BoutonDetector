function [boutonrevised, bouton] = mainwithtiffboutonthresholding(varargin);
%Set All Global Parameters
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

    
[returnredcell, uniquemaskarrays, threshu] = cell_inpainting();

cd('InputImages');


numvarargs = length(varargin);
if(numvarargs >=1)
    fullpath = varargin{1};
    UniqueCodeString=varargin{2};
    imagedir = strcat(fullpath, '/InputImages')
    cd(imagedir);
end;

%directory =cd(cd('..'));
%directory = pwd;
%imagedir = strcat(directory, 'InputImages')
%cd(imagedir);


TiffFiles=dir(['*c0002.tif']);

numberofFiles = length(TiffFiles);
  count=0;
 uniquemaskarraysize = size(uniquemaskarrays);
 loopsize = uniquemaskarraysize(2);
 for q=1:numberofFiles
     FileName = TiffFiles(q).name
originalfile =imread(FileName);
maxim=double(max(max(originalfile)));
normimage=double(originalfile)/double(maxim);

 %save a version of normalized image
  figure;
  imshow(normimage);
  h = gcf; 
 name = num2str(q);
 name2 = 'normalizedimage';
 namefinal = cat(2,name,name2);
 %saveas(h,namefinal, 'jpg');  


%apply gaussian filter to normalized images
%gaussianfilter=fspecial('gauss',GaussianFilterRadius,GaussianSigma);
%gaussianfilterfile = imfilter(normimage,gaussianfilter);

 %save a version of normalized image with gaussian file
  
 
 gaussianfilterfile = normimage;

  figure;
  imshow(gaussianfilterfile);
  h = gcf; 
 name = num2str(q);
 name2 = 'gaussianfilterfile';
 namefinal = cat(2,name,name2);
 %saveas(h,namefinal, 'jpg');  


 sizelengths=size(gaussianfilterfile(:,:,1));
 xlength = sizelengths(1);                                                                                            
 ylength = sizelengths(2); 
     
 clear boutonthreshold;
  for i = 1:xlength
     for j = 1:ylength
 if(gaussianfilterfile(i,j)>BoutonThresholdParameter)
    boutonthreshold(i,j) = 1;
end;
     end;
  end;
  
 %save a version of bouton thresholdedimage 
 figure;
 imshow(boutonthreshold);
 h = gcf; 
 name = num2str(q);
 name2 = 'thresholdedimage';
 namefinal = cat(2,name,name2);
 %saveas(h,namefinal, 'jpg');  


 sizelengths=size(gaussianfilterfile(:,:,1));
 xlength = sizelengths(1);                                                                                            
 ylength = sizelengths(2); 
  
 
  
 %Label the individual boutons
 
 clear binary;
 clear rfinal;
 clear centroidpoints;
 clear rRGB;
 clear overlay;
 clear binary;
 
 
 
 %binary = im2bw(boutonthreshold,.2);
  
 %save a version of applied binary image thresholding
%  figure;
%  imshow(binary);
%  h = gcf; 
%  name = num2str(q);
%  name2 = 'appliedbinaryimagethresholding';
%  namefinal = cat(2,name,name2);
%  saveas(h,namefinal, 'jpg');  


 sizelengths=size(gaussianfilterfile(:,:,1));
 xlength = sizelengths(1);                                                                                            
 ylength = sizelengths(2); 
 
 
 rfinal = bwareaopen(boutonthreshold,ConnectivitySize);
 [rLareaopen, areaopen] = bwlabel(rfinal);
 extremapoints=regionprops(rLareaopen,'Extrema');
 centroidpoints=regionprops(rLareaopen,'Centroid');     
 pixellist=regionprops(rLareaopen,'PixelList');    

 rRGB = label2rgb(rLareaopen);
 overlay = rRGB;
 binary = im2bw(rRGB,.2);

 
 


 %Make plots and save them
 close all; 
 clear h;


 %Save  Version of Normalized Image verse All Identified Boutons
 figure;
 subplot(2,1,1), imshow(normimage);
 subplot(2,1,2), imshow(overlay);
   
  h = gcf; 
 name = num2str(q);
 name2 = num2str(100);
 namefinal = cat(2,name,name2);
 %saveas(h,namefinal, 'jpg');  
 %Accept Boutons Only Within a Certain Distance
 kprevious=0;
for k = 1: length(centroidpoints)
 centroidpositionx = centroidpoints(k).Centroid(1)
centroidpositiony = centroidpoints(k).Centroid(2)
 sizes = size(uniquemaskarrays);
 distance_min = 20000;
 min_cell = 0;
for j = 1:sizes(1)
  if (q >= returnredcell(j).originalimageslice && q <= returnredcell(j).imageslice)
   xcomparison = uniquemaskarrays(j,q).xcoords_array;
   ycomparison = uniquemaskarrays(j,q).ycoords_array;

  for b = 1:length(xcomparison)
      
   distance = sqrt((xcomparison(b)-centroidpositionx)^2 + (ycomparison(b)-centroidpositiony)^2);
 
   if (rand(1,1)>0.5)
     if (distance <= distance_min)
      distance_min = distance;
      min_cell = j;
            if(distance_min <20)
                distance_min;
            end;
     end;  
   else 
    if (distance < distance_min)
    distance_min = distance;
    min_cell = j;
     if(distance_min <20)
                distance_min;
            end;
   end;
  end;
 
 end;
 
 end;
end; 

 if(distance_min < AcceptanceCellDistance)
      boutonpixels =  pixellist(k);
      sizes = size(boutonpixels.PixelList);
      numberofpixels = sizes(1);
     count=count+1
     bouton(q,count).imageslice = q;
     distance_min
     bouton(q,count).centroidposx = centroidpoints(k).Centroid(1);
     bouton(q,count).centroidposy = centroidpoints(k).Centroid(2);
     bouton(q,count).cellnumber = min_cell;   
     bouton(q,count).pixelsize =  numberofpixels;
     
 end;
 
end;

 close all;
 end;
 
 cd ../
 
boutonrevised = placeholderarray(bouton);  
%keyboard;
visualization(boutonrevised, threshu, uniquemaskarrays,varargin);  

% if(numvarargs=0)
% visualization(boutonrevised, threshu, uniquemaskarray,);  
% end;
% 
% if(numvarargs>=1)
% visualization(boutonrevised, threshu, uniquemaskarray,);  
% end;



