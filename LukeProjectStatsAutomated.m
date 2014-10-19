
  entirecellsize = zeros(1,max(cell2mat(cellfulllist(:,2)))); 
for j = 1:max(cell2mat(cellfulllist(:,2)));
boutonsize=0;
for i = 1:length(cellfulllist)
    if(cellfulllist{i,2}==j)
        entirecellsize(j) = cellfulllist{i,3}+ entirecellsize(j);        
    end;
end;
end;



entireboundarycellsize = zeros(1,max(cell2mat(cellfulllist(:,2))));
for j = 1:max(cell2mat(cellfulllist(:,2)));
boutonsize=0;
for i = 1:length(cellfulllist)
    if(cellfulllist{i,2}==j)
        entireboundarycellsize(j) = cellfulllist{i,4}+ entireboundarycellsize(j);        
    end;
end;
end;

entireboutonsize = zeros(1,max(cell2mat(boutonlist(:,5))));

for j = 1:max(cell2mat(boutonlist(:,5)));
boutonsize=0;
for i = 1:length(boutonlist)
    if(boutonlist{i,5}==j)
       entireboutonsize(j) = boutonlist{i,6}+entireboutonsize(j);        
    end;
end;

end;



% 
% sorted_matrix = sortrows(boutonlist,5);
% boutonsize = zeros(1,max(cell2mat(sorted_matrix(:,5))));
% totalboutonsize = zeros(1,max(cell2mat(sorted_matrix(:,1))));
% for j = 1:max(cell2mat(sorted_matrix(:,1)));
%     j
%     for i =1:length(sorted_matrix)
%         if(cell2mat(sorted_matrix(i,1)) ==j)
% totalboutonsize(j) = sorted_matrix{i,6} + totalboutonsize(j);
%         end;
%     end;
% end;
% hist(totalboutonsize)




%mean bouton statistics 
sorted_matrix = sortrows(boutonlist,5);
sortedmatrixnoncell = cell2mat(sorted_matrix);
boutonids = sortedmatrixnoncell(:,1);
uniqueboutonids = unique(boutonids);
celllist = zeros(length(uniqueboutonids),1);
for i =1:length(celllist)
findcellindex = find(sortedmatrixnoncell(:,1)==uniqueboutonids(i));
%keep only non-redundant ones
findcellindex = min(findcellindex);
findcellvalue = sortedmatrixnoncell(findcellindex,5);
celllist(i) = findcellvalue;
end;
%retrieve number of boutons
[n rows] = hist(celllist,max(celllist));



%Spit Out All Statistics
entirecellsize
entireboundarycellsize
meanentirecellsize = mean(entirecellsize)
meanentireentireboundarycellsize = mean(entireboundarycellsize)

%meanbountonspercell
meanbountonspercell = mean(n)
 %boutons per volume
 
 %correct entire cellsize for when some bouton are not matched to cells
entirecellsize = entirecellsize(:,(1:length(n)));
 
boutonspervolumevector = n./entirecellsize
%mean boutons per volume
meanboutoboutonspervolumevector = mean(boutonspervolumevector)
%std boutons per volume
stdboutoboutonspervolumevector = std(boutonspervolumevector)

 %correct entire cellsize for when some bouton are not matched to cells
 entireboundarycellsize = entireboundarycellsize(:,(1:length(n)))

%mean boutons per surface
boutonspersurfacevector = n./entireboundarycellsize
meanboutonspersurfacevector = mean(boutonspersurfacevector)
%std boutons per volume
stdboutonspersurfacevector = std(boutonspersurfacevector)







% 
% cellnumbers = sortedmatrixnoncell(:,5);
% numberboutons = length(uniqueboutonids);
% boutonsize = zeros(1,max(cell2mat(sorted_matrix(:,5))));
% 
% 
% 
% sorted_matrix(uniqueboutonids,5)







% 
% entireboutonsizes = zeros(1,max(cell2mat(boutonlist(:,5))));
% for k = 1:length(totalboutonsize)
%   
% distributionofsizes(k).boutonsize = 
% end;
% 

    
%     for i = 1:length(boutonlist)
%     if(boutonlist{i,5}==j)
%         i
%         boutonsize(j) = boutonlist{i,6}+boutonsize(j);        
%     end;
% end;
% end;

