function [boutonisonorout] = boutoninsidecellcheck(boutoncheckx,boutonchecky,uniquemaskarrayclosest,z)
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
boundarymasterone=0;
boundarymastertwo=0;
sizes = size(uniquemaskarrayclosest.imagecellmask);
CellMask = zeros(sizes);
x=uniquemaskarrayclosest.xcoords_array;
y=uniquemaskarrayclosest.ycoords_array;
for j = 1:length(x)
 CellMask(y(j),x(j))=1;
end;
[B,L,N] = bwboundaries(CellMask); 
%figure;
%imshow(CellMask);

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
        boundarymasterone = boundary(:,2);
        boundarymastertwo = boundary(:,1);
    end
end



if(exist('boundarymasterone')==0)
     boundarymasterone=0;
      boundarymastertwo = 0;
end;


%find minimum distance from boundary
 distance_min = 20000;
for i =1:length(boundarymasterone)
   distance = sqrt((boundarymasterone(i)-boutoncheckx)^2 + (boundarymastertwo(i)-boutonchecky)^2);
        if(distance<distance_min)
            distance_min=distance;
        end;
end;
        




[IN ON] = inpolygon(boutoncheckx, boutonchecky,  boundarymasterone,  boundarymastertwo);
    if(IN==0 | ON==1)
        %signal to keep bouton
        boutonisonorout = 1;
    else if (IN==1 && distance_min < AcceptanceCellDistance/2)
            %signal to keep bouton
                    boutonisonorout = 1;
        else
        boutonisonorout = 0;
            end;
    end;
cd('InputImages');


    

