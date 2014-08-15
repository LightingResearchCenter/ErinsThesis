function filePathArray = crawldir(directory,filePattern)
%CRAWLDIR Recursively crawls a directory and all sub directories
%   Will match files that follow the specified naming pattern
 
FileListing = dir(fullfile(directory,filePattern));
nFile = numel(FileListing);
filePathArray = cell(nFile,1);
for iFile = 1:nFile
    filePathArray = fullfile(directory,FileListing(iFile).name);
end
 
SubDirListing = dir(directory);
SubDirListing = SubDirListing([SubDirListing(:).isdir]);
 
for iSubFold = 1:numel(SubDirListing)
   if ~strcmp(SubDirListing(iSubFold).name,'.') && ~strcmp(SubDirListing(iSubFold).name,'..')
       subFilePathArray = crawldir(fullfile(directory,SubDirListing(iSubFold).name),filePattern);
       filePathArray = [filePathArray;subFilePathArray];
   end
end


end

