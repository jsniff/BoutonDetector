function [] = RenameFiles(maindirectory)
image_dir = maindirectory;
processed_dir = strcat(image_dir, '/RenamedFiles');

cd(image_dir)

TiffFiles=dir(['*.tif']);
numberofFiles = length(TiffFiles);
for ii = 2:3:numberofFiles
    ii
    FileName = TiffFiles(ii).name
        originalfile =imread(FileName);
    [pathstr,name,ext] = fileparts(FileName);
    numberaddon = '_c002';
    newname = strcat(name, numberaddon)
    imwrite(originalfile,fullfile(processed_dir,sprintf('%s.tif',newname)));
end
