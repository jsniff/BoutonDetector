function [] = AllGlobalParameters(varargin);

Development = 0;
numvarargs = length(varargin);
if(numvarargs >=1)
MainPath = varargin{1};
end;

 if(exist('MainPath'))
    Development = 1;
 end;    
 
 
%Set All Global Parameters


%Set Cell Parameters

global CellThresholdParameter;
global CellconnectivitySize;
global CellSizeLengthParameter;
global CellSizeDistance;
global CellNumberofImages;

    CellThresholdParameter = .235;
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

    ConnectivitySize = 7;
    AcceptanceCellDistance = 14;
    DoubleCountDistance = 12;
    GaussianFilterRadius = 0;
    GaussianSigma=1;
    BoutonThresholdParameter = .18;
    

ConnectivitySizeVector = [1100:50:1200];
CellThresholdParameterVector = [.23:.01:.28];


%for i = 1:length(ConnectivitySizeVector)
%for j = 1:length(CellThresholdParameterVector)
%CellconnectivitySize = ConnectivitySizeVector(i);
%CellThresholdParameter = CellThresholdParameterVector(j);



    if(Development==1)
    javaaddpath('/Applications/mysql-connector-java-5.1.29/mysql-connector-java-5.1.29-bin.jar')
    cd(MainPath);
    sqlqueryuniquecode = ['SELECT max(uniquecode) FROM AllTestParameters'];
    conn = database('basketneurons','root','','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/');  
    resultssqlqueryuniquecode = fetch(conn, sqlqueryuniquecode);
    UniqueCode=cell2mat(resultssqlqueryuniquecode)+1;
    UniqueCodeString = num2str(UniqueCode);
    [boutonrevised, bouton] = mainwithtiffboutonthresholding(MainPath, UniqueCodeString);   
    BoutonListDirectoryAddon = '/BoutonsDetected_lists_tests';
    mkdir('BoutonsDetected_lists_tests');
    BoutonListDirectory = strcat(MainPath,BoutonListDirectoryAddon);
    else
        [boutonrevised, bouton] = mainwithtiffboutonthresholding();  
    end;

    
    
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
    
    if(Development ==1)
    FinalName = strcat(BoutonListDirectory,strcat('/test_',num2str(UniqueCode)));
    FinalName = strcat(FinalName, '.txt');
            end;
    
    fid=fopen(FinalName,'wt');
    fprintf(fid, 'j%i\t%i\t%i\t%.2f\t%.2f\t%i\n', [indexedloop', originalimageslicecolumn,  imageslicecolumn, centroidposxcolumn,centroidposycolumn, cellnumbercolumn].')
    fclose(fid);

    
 
    
    if(Development ==1)

    e = exec(conn, ['DROP TABLE IF EXISTS basketneurons.jacob']);
    close(e);

    e = exec(conn,['create table IF NOT EXISTS basketneurons.jacob (boutonid varchar(20) NOT NULL DEFAULT '''' PRIMARY KEY, '...
   'topz smallint NOT NULL, botz smallint NOT NULL, '...
   'centx FLOAT NOT NULL, centy FLOAT NOT NULL, cellnumber smallint NOT NULL)']);
    close(e);


   sqlquery = ['load data local infile ' ...
   '''' FinalName '''' ' into table basketneurons.jacob '...
   'fields terminated by ''\t'' lines terminated '...
   'by ''\n'''];

   e = exec(conn,sqlquery);

   close(e);
   

 sqlquery1 = ['SELECT count(distinct jacob.boutonid) FROM jacob group by jacob.cellnumber order by jacob.cellnumber'];
 results1 = fetch(conn, sqlquery1);
 results1_mat=cell2mat(results1);
 
 bouton_num_jacob_cell_1 = results1_mat(1);
 bouton_num_jacob_cell_2 = results1_mat(2);
 bouton_num_jacob_cell_3 = results1_mat(3);

  sqlquery2 = ['SELECT count(distinct jacob.boutonid) FROM luke JOIN jacob '... 
      'ON ( sqrt(power(luke.centx - jacob.centx, 2) + power(luke.centy - jacob.centy, 2)) <= 13 AND jacob.topz - 2 <= luke.topz AND luke.botz <= jacob.botz + 2 '...
               'AND jacob.cellnumber = luke.cellnumber) GROUP BY jacob.cellnumber ORDER BY jacob.cellnumber '];
 results2 = fetch(conn, sqlquery2);
 results2_mat=cell2mat(results2);
 
 matched_boutons_jacob_cell_1 = results2_mat(1);
 matched_boutons_jacob_cell_2 = results2_mat(2);
       
      
   sqlquery3 = ['SELECT count(distinct luke.boutonid) FROM luke JOIN jacob '...
          'ON ( sqrt(power(luke.centx - jacob.centx, 2) + power(luke.centy - jacob.centy, 2)) <= 13 AND jacob.topz - 2 <= luke.topz AND luke.botz <= jacob.botz + 2 '... 
               'AND jacob.cellnumber = luke.cellnumber) GROUP BY luke.cellnumber ORDER BY luke.cellnumber'];
  results3 = fetch(conn, sqlquery3);
  results3_mat=cell2mat(results3);
 
 matched_boutons_luke_cell_1 = results3_mat(1);
 matched_boutons_luke_cell_2 = results3_mat(2);
        
 sqlquery4 = ['SELECT count(distinct luke.boutonid) FROM luke group by luke.cellnumber order by luke.cellnumber'];
 results4 = fetch(conn, sqlquery4);
 results4_mat=cell2mat(results4);

 bouton_num_luke_cell_1 = results4_mat(1);
 bouton_num_luke_cell_2 = results4_mat(2);

 precision_cell_1 = 100.0 * (matched_boutons_jacob_cell_1/bouton_num_jacob_cell_1);
 recall_cell_1 = 100.0 * (matched_boutons_luke_cell_1/bouton_num_luke_cell_1);
 
 precision_cell_2 = 100.0 * (matched_boutons_jacob_cell_2/bouton_num_jacob_cell_2);
 recall_cell_2 = 100.0 * (matched_boutons_luke_cell_2/bouton_num_luke_cell_2);
 
 
 nullcellsize = 3000000;
 TemporaryFile = 'TemporaryFile';
 temporary=fopen(TemporaryFile,'w');
 fprintf(temporary, '%i\t%s\t%i\t%i\t%i\t%.2f\t%i\t%i\t%.2f\t%i\t%i\t%i\t%s\t%.2f\t%.2f\t%.2f\t%.2f\n', UniqueCode, FinalName, GaussianFilterRadius,GaussianSigma,ConnectivitySize,CellThresholdParameter,DoubleCountDistance, AcceptanceCellDistance,BoutonThresholdParameter, ... 
     CellconnectivitySize, CellSizeDistance, CellNumberofImages, nullcellsize, precision_cell_1,recall_cell_1, precision_cell_2,recall_cell_2);
 fclose(temporary);
  

 sqlquery = ['load data local infile ' ...
   '''' TemporaryFile '''' ' into table basketneurons.AllTestParameters '...
   'fields terminated by ''\t'' lines terminated '...
   'by ''\n'''];

   e = exec(conn,sqlquery);
  
    close(e);
    close(conn);
end;
                                                   
%end;
%end;





 
