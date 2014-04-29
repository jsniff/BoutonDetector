%%assign all boutons to unique identification label

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


bouton = cellinfomask;
sizes=size(bouton);
ylength=sizes(2);
count = 0;
originalcount = 0;
xcoordsarray = zeros(length(bouton),ylength);
     for i = 1:length(bouton);    
     for j = 1:ylength;
         %add first row of cells
     if(i==1)
       %check if array entry is non empty
        if(bouton(i,j).imageslice ~=0) 
        count = count + 1;             
        currentslice = bouton(i,j).imageslice;
        boutonrevised(count).imageslice = currentslice;
        boutonrevised(count).centroidposx = bouton(i,j).centroidposx;
        boutonrevised(count).centroidposy = bouton(i,j).centroidposy;  
        boutonrevised(count).originalimageslice =  bouton(i,j).imageslice;
        boutonrevised(count).imagecellmask =  bouton(i,j).imagecellmask;
        %in separate arrays, add cell mask
        coords_arrays(count, currentslice).xcoords_array= bouton(i,j).xcoordinatesmask;
        coords_arrays(count, currentslice).ycoords_array= bouton(i,j).ycoordinatesmask;
        coords_arrays(count, currentslice).cellmask=  bouton(i,j).imagecellmask;
        end;
        end;
                                 
       if(i>1)
                     %take of double counting
       if(bouton(i,j).imageslice ~=0)  %check if array entry is non empty
       newbouton=1;
       %compare against all boutons revised
       if(exist('boutonrevised')>0)
       for k = 1:length(boutonrevised) 
                          %make sure bouton row comparison is previous
                          %image (so 2d doesn't mess up 3d)
       if(boutonrevised(k).imageslice == bouton(i,j).imageslice-1)
       distance = sqrt((bouton(i,j).centroidposx-boutonrevised(k).centroidposx)^2+(bouton(i,j).centroidposy-boutonrevised(k).centroidposy)^2)
        count
       if(distance<=CellSizeDistance) 
        %consider them same cell
        currentslice = bouton(i,j).imageslice;
        boutonrevised(k).imageslice = bouton(i,j).imageslice;
        boutonrevised(k).centroidposx = bouton(i,j).centroidposx;
        boutonrevised(k).centroidposy = bouton(i,j).centroidposy; 
        boutonrevised(k).imagecellmask =  bouton(i,j).imagecellmask;
        coords_arrays(k, currentslice).xcoords_array= bouton(i,j).xcoordinatesmask;
        coords_arrays(k, currentslice).ycoords_array= bouton(i,j).ycoordinatesmask;
        coords_arrays(k, currentslice).cellmask=  bouton(i,j).imagecellmask;

        newbouton=0; %not a new bouton--do not add
        break;
        end;
        end;
        end;
        end;
        %add new boutons
        if (newbouton==1)        
        count = count + 1;
        currentslice = bouton(i,j).imageslice;
        boutonrevised(count).imageslice = bouton(i,j).imageslice;
        boutonrevised(count).centroidposx = bouton(i,j).centroidposx;
        boutonrevised(count).centroidposy = bouton(i,j).centroidposy; 
        boutonrevised(count).originalimageslice =  bouton(i,j).imageslice;
        boutonrevised(count).imagecellmask =  bouton(i,j).imagecellmask;
        coords_arrays(count, currentslice).xcoords_array= bouton(i,j).xcoordinatesmask;
        coords_arrays(count, currentslice).ycoords_array= bouton(i,j).ycoordinatesmask;
        coords_arrays(count, currentslice).cellmask=  bouton(i,j).imagecellmask;

        end;
        end;
        end;
        end;
        end;
        %remove cells that stay less than a certain number of images
        count = 0;
        for i =1: length(boutonrevised)
        numberofimages = boutonrevised(i).imageslice-boutonrevised(i).originalimageslice;
        cellisbigenough = 0;
        for slice = 1:numberofimages
          cellsize = length(coords_arrays(i,slice).xcoords_array);
          if(cellsize>CellSizeLengthParameter)
            cellisbigenough =1;
          end;
        end;
       % if(numberofimages>CellNumberofImages && cellisbigenough==1) 
        if(numberofimages>CellNumberofImages)
        count = count + 1
        cellfinallist(count).imageslice =  boutonrevised(i).imageslice;
        cellfinallist(count).centroidposx =  boutonrevised(i).centroidposx;
        cellfinallist(count).centroidposy =  boutonrevised(i).centroidposy;
        cellfinallist(count).originalimageslice =  boutonrevised(i).originalimageslice;
        cellfinallist(count).imagecellmask =  boutonrevised(i).imagecellmask;
        firstslice= cellfinallist(count).originalimageslice;
         lastslice = cellfinallist(count).imageslice;  
        for j= firstslice:lastslice
        finalcoords_arrays(count, j).xcoords_array= coords_arrays(i,j).xcoords_array;
        finalcoords_arrays(count, j).ycoords_array= coords_arrays(i,j).ycoords_array;
        finalcoords_arrays(count, j).imagecellmask = coords_arrays(i,j).cellmask;
        end;
        end;
        end;
        cellinfomaskunique = cellfinallist;
        uniquemaskarrays = finalcoords_arrays;
        threshu = threshu;

