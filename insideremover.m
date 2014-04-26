
function [boutonrevisedboundary] = insideremover(boutonrevised,boundaryarray);



%
boundarycounter=0;
for z = 1:length(boutonrevised)  
[IN ON] = inpolygon(boutonrevised(z).centroidposx, boutonrevised(z).centroidposy, boundaryarray(boutonrevised(z).imageslice).xcoordinates, boundaryarray(boutonrevised(z).imageslice).ycoordinates);
    if(IN==0)
  boundarycounter=boundarycounter+1
     boutonrevisedboundary(boundarycounter).imageslice= boutonrevised(boundarycounter).imageslice;
     boutonrevisedboundary(boundarycounter).centroidposx= boutonrevised(boundarycounter).centroidposx;
     boutonrevisedboundary(boundarycounter).centroidposy= boutonrevised(boundarycounter).centroidposy;
     boutonrevisedboundary(boundarycounter).originalimageslice= boutonrevised(boundarycounter).originalimageslice;
     boutonrevisedboundary(boundarycounter).cellnumber= boutonrevised(boundarycounter).cellnumber;
    end;
end;