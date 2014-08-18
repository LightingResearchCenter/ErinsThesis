function fixCdf
%FIXCDF Summary of this function goes here
%   Detailed explanation goes here

% Add dependecies to path
[githubDir,~,~] = fileparts(pwd);
repairToolPath  = fullfile(githubDir,'CdfCsvRepairTool');
addpath(repairToolPath);

% Specify the project folder
projectDir = fullfile([filesep,filesep],'root','projects','L&H-PerformanceTestFiles','Erin''s Thesis','Daysimeter Files');

cdfPathArray = crawldir(projectDir,'.cdf');
nCdf = numel(cdfPathArray);
if nCdf > 0
    hWaitCdf = waitbar(0, 'Reprocessing CDFs. Please wait...');
    for i1 = 1:nCdf
        try
            reprocesscdf(cdfPathArray{i1},false);
        catch err
            warning(err.message);
        end
        waitbar(i1/nCdf);
    end
    close(hWaitCdf);
end


end
