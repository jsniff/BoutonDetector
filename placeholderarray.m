%%assign all boutons to unique identification label
function [boutonrevised] = placeholderarray(bouton)
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


sizes=size(bouton);
xlength=sizes(1);
ylength=sizes(2);
count = 0;
originalcount = 0;

for i = 1:xlength;
    
    for j = 1:ylength;
 
     
        if(i==1)
           %add first row of boutons
        if(bouton(i,j).imageslice ~=0)
                      originalcount = originalcount+1;
                    count = count + 1;
                    originalbouton(originalcount).imageslice = bouton(i,j).imageslice;
                      originalbouton(originalcount).centroidposx = bouton(i,j).centroidposx;
       originalbouton(originalcount).centroidposy = bouton(i,j).centroidposy;

        boutonrevised(count).imageslice = bouton(i,j).imageslice;
     boutonrevised(count).centroidposx = bouton(i,j).centroidposx;
       boutonrevised(count).centroidposy = bouton(i,j).centroidposy;  
                    boutonrevised(count).originalimageslice =  bouton(i,j).imageslice;
                        boutonrevised(count).cellnumber =  bouton(i,j).cellnumber;

        end;
       end;
      
       
       if(i>1)
                     %take of double counting
                 if(bouton(i,j).imageslice ~=0)
                     originalcount = originalcount+1;
                         originalbouton(originalcount).imageslice = bouton(i,j).imageslice;
                      originalbouton(originalcount).centroidposx = bouton(i,j).centroidposx;
       originalbouton(originalcount).centroidposy = bouton(i,j).centroidposy;

                      newbouton=1;
                      %compare against all boutons revised
                      if(exist('boutonrevised')>0)
                      for k = 1:length(boutonrevised) 
                          %make sure bouton row comparison is previous
                          %image (so 2d doesn't mess up 3d)
                          
                         if(boutonrevised(k).imageslice == bouton(i,j).imageslice-1)
                         
                distance = sqrt((bouton(i,j).centroidposx-boutonrevised(k).centroidposx)^2+(bouton(i,j).centroidposy-boutonrevised(k).centroidposy)^2);
                
                if(distance<=DoubleCountDistance)
         boutonrevised(k).imageslice = bouton(i,j).imageslice;
     boutonrevised(k).centroidposx = bouton(i,j).centroidposx;
       boutonrevised(k).centroidposy = bouton(i,j).centroidposy;  
             boutonrevised(k).cellnumber =  bouton(i,j).cellnumber;

              %boutonrevised(k).originalimageslice = bouton(i,j).originalimageslice;  
              newbouton=0;
              break;
                                end;
              end;
                  end;
                      end;
               % else   
                 %   newbouton='yes';
                          %add new boutons
            if (newbouton==1)        
                    count = count + 1;
                   
                   
            boutonrevised(count).imageslice = bouton(i,j).imageslice;
            boutonrevised(count).centroidposx = bouton(i,j).centroidposx;
            boutonrevised(count).centroidposy = bouton(i,j).centroidposy; 
            boutonrevised(count).originalimageslice =  bouton(i,j).imageslice;
                   boutonrevised(count).cellnumber =  bouton(i,j).cellnumber;

               

       end;
    end;
    end;
end;
end;

 
 
 
 



            
                  
                 