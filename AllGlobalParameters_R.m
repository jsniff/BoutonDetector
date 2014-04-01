function [] = AllGlobalParameters();

%Set All Global Parameters


%Set Cell Parameters

global CellThresholdParameter;
global CellconnectivitySize;
global CellSizeLengthParameter;
global CellSizeDistance;
global CellNumberofImages;

    CellThresholdParameter = .24;
    CellconnectivitySize = 1150;
    CellSizeLengthParameter = 0;
    CellSizeDistance = 100;
    CellNumberofImages=12;
    
    
%Set Bouton Parameters

global GaussianFilterRadius;
global ConnectivitySize;
global AcceptanceCellDistance;
global DoubleCountDistance;
global BoutonThresholdParameter;
global GaussianSigma;

    ConnectivitySize = 10;
    AcceptanceCellDistance = 21;
    DoubleCountDistance = 12;
    GaussianFilterRadius = 0;
    GaussianSigma=1;
    BoutonThresholdParameter = .16;
    

    [boutonrevised, bouton] = mainwithtiffboutonthresholding();

    %create text file here instead of maintiffbouton

    tablestructure = struct2table(boutonrevised);
    cellstructure = table2cell(tablestructure);
  
    centroidposxcolumn = cell2mat(cellstructure(:,2));
    centroidposycolumn = cell2mat(cellstructure(:,3));
    originalimageslicecolumn = cell2mat(cellstructure(:,4));
    cellnumbercolumn = cell2mat(cellstructure(:,5));
    imageslicecolumn = cell2mat(cellstructure(:,1));


    clear indexedloop;
    for k =1:length(imageslicecolumn)
       indexedloop(k) = k;
    end;
            
    
    
    FinalName = 'BoutonsDetected_list.txt';
    
    fid=fopen(FinalName,'wt');
    fprintf(fid, 'j%i\t%i\t%i\t%.2f\t%.2f\t%i\n', [indexedloop', originalimageslicecolumn,  imageslicecolumn, centroidposxcolumn,centroidposycolumn, cellnumbercolumn].')
    fclose(fid);

    






 