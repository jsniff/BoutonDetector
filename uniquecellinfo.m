%%assign all cellinfomasks to unique identification label

function [cellinfomaskunique, uniquemaskarrays, threshu] = uniquecellinfo(cellinfomask, threshu)
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


%Create Cell Mask List

FinalName = 'cell_full_list.txt';
fid=fopen(FinalName,'a');
fprintf(fid, '%s\t%s\t%s\t%s\t%s\t%s\n', 'ImageSlice', 'CellNumber', 'SizeofCell', 'SizeofCellBoundary', 'CentroidPosX', 'CentroidPosY');



%rename forcell mask input
sizes=size(cellinfomask);
ylength=sizes(2);
count = 0;
originalcount = 0;
xcoordsarray = zeros(length(cellinfomask),ylength);
     for i = 1:length(cellinfomask);    
     for j = 1:ylength;
         %add first row of cells
     if(i==1)
       %check if array entry is non empty
        if(cellinfomask(i,j).imageslice ~=0) 
        count = count + 1;             
        currentslice = cellinfomask(i,j).imageslice;
        cellrevised(count).imageslice = currentslice;
        cellrevised(count).centroidposx = cellinfomask(i,j).centroidposx;
        cellrevised(count).centroidposy = cellinfomask(i,j).centroidposy;  
        cellrevised(count).originalimageslice =  cellinfomask(i,j).imageslice;
        cellrevised(count).imagecellmask =  cellinfomask(i,j).imagecellmask;
        %in separate arrays, add cell mask
        coords_arrays(count, currentslice).xcoords_array= cellinfomask(i,j).xcoordinatesmask;
        coords_arrays(count, currentslice).ycoords_array= cellinfomask(i,j).ycoordinatesmask;
        coords_arrays(count, currentslice).cellmask=  cellinfomask(i,j).imagecellmask
        
        
        end;
        end;
                                 
       if(i>1)
                     %take of double counting
       if(cellinfomask(i,j).imageslice ~=0)  %check if array entry is non empty
       newcellinfomask=1;
       %compare against all cellinfomasks revised
       if(exist('cellrevised')>0)
       for k = 1:length(cellrevised) 
                          %make sure cellinfomask row comparison is previous
                          %image (so 2d doesn't mess up 3d)
       if(cellrevised(k).imageslice == cellinfomask(i,j).imageslice-1)
       distance = sqrt((cellinfomask(i,j).centroidposx-cellrevised(k).centroidposx)^2+(cellinfomask(i,j).centroidposy-cellrevised(k).centroidposy)^2);
        count;
       if(distance<=CellSizeDistance) 
        %consider them same cell
        currentslice = cellinfomask(i,j).imageslice;
        cellrevised(k).imageslice = cellinfomask(i,j).imageslice;
        cellrevised(k).centroidposx = cellinfomask(i,j).centroidposx;
        cellrevised(k).centroidposy = cellinfomask(i,j).centroidposy; 
        cellrevised(k).imagecellmask =  cellinfomask(i,j).imagecellmask;
        coords_arrays(k, currentslice).xcoords_array= cellinfomask(i,j).xcoordinatesmask;
        coords_arrays(k, currentslice).ycoords_array= cellinfomask(i,j).ycoordinatesmask;
        coords_arrays(k, currentslice).cellmask=  cellinfomask(i,j).imagecellmask
        

        newcellinfomask=0; %not a new cellinfomask--do not add
        break;
        end;
        end;
        end;
        end;
        %add new cellinfomasks
        if (newcellinfomask==1)        
        count = count + 1;
        currentslice = cellinfomask(i,j).imageslice;
        cellrevised(count).imageslice = cellinfomask(i,j).imageslice;
        cellrevised(count).centroidposx = cellinfomask(i,j).centroidposx;
        cellrevised(count).centroidposy = cellinfomask(i,j).centroidposy; 
        cellrevised(count).originalimageslice =  cellinfomask(i,j).imageslice;
        cellrevised(count).imagecellmask =  cellinfomask(i,j).imagecellmask;
        coords_arrays(count, currentslice).xcoords_array= cellinfomask(i,j).xcoordinatesmask;
        coords_arrays(count, currentslice).ycoords_array= cellinfomask(i,j).ycoordinatesmask;
        coords_arrays(count, currentslice).cellmask=  cellinfomask(i,j).imagecellmask;

        end;
        end;
        end;
        end;
        end;
        %remove cells that stay less than a certain number of images
        count = 0;
        for i =1: length(cellrevised)
        numberofimages = cellrevised(i).imageslice-cellrevised(i).originalimageslice;
        cellisbigenough = 0;
        for slice = 1:numberofimages
          cellsize = length(coords_arrays(i,slice).xcoords_array);
          if(cellsize>CellSizeLengthParameter)
            cellisbigenough =1;
          end;
        end;
       % if(numberofimages>CellNumberofImages && cellisbigenough==1) 
        if(numberofimages>CellNumberofImages)
        count = count + 1;
        cellfinallist(count).imageslice =  cellrevised(i).imageslice;
        cellfinallist(count).centroidposx =  cellrevised(i).centroidposx;
        cellfinallist(count).centroidposy =  cellrevised(i).centroidposy;
        cellfinallist(count).originalimageslice =  cellrevised(i).originalimageslice; 
        cellfinallist(count).imagecellmask =  cellrevised(i).imagecellmask;
        firstslice= cellfinallist(count).originalimageslice;
         lastslice = cellfinallist(count).imageslice;  


   for j= firstslice:lastslice
        finalcoords_arrays(count, j).xcoords_array= coords_arrays(i,j).xcoords_array;
        finalcoords_arrays(count, j).ycoords_array= coords_arrays(i,j).ycoords_array;
        finalcoords_arrays(count, j).imagecellmask = coords_arrays(i,j).cellmask;
                  
  %add code to update cell information in list

 BW= finalcoords_arrays(count, j).imagecellmask;
 [B,L,N] = bwboundaries(BW);      
 for k=1:length(B),
    boundary = B{k};
    if(k > N)
        hold on;
%         plot(boundary(:,2),...
%             boundary(:,1),'g','LineWidth',1);
        hold on;
    else
        hold on;
%         plot(boundary(:,2),...
%             boundary(:,1),'r','LineWidth',1);
%         hold on;
        sizecellmaskboundary = length(boundary(:,2));
        boundarymasterone = boundary(:,2);
        boundarymastertwo = boundary(:,1);
    end
 end
                                  
   %Add input to Cell Mask Files
 
 CentroidMaskx = mean(finalcoords_arrays(count, j).xcoords_array);
 CentroidMasky = mean(finalcoords_arrays(count, j).ycoords_array);              
 sizecellmask = nnz(finalcoords_arrays(count, j).imagecellmask);
 fprintf(fid, '%i\t%i\t%i\t%i\t%.2f\t%.2f\n', [j, count, sizecellmask, sizecellmaskboundary,  CentroidMaskx, CentroidMasky]);  
   end;
        
        end;
        end;
        cellinfomaskunique = cellfinallist;
        uniquemaskarrays = finalcoords_arrays;
        threshu = threshu;

