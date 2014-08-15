function fixCdfAndCsv
%FIXCDFANDCSV Summary of this function goes here
%   Detailed explanation goes here

% Add dependecies to path
[githubDir,~,~] = fileparts(pwd);
repairToolPath  = fullfile(githubDir,'CdfCsvRepairTool');
addpath(repairToolPath);

% Specify the project folder
projectDir = fullfile([filesep,filesep],'root','projects','L&H-PerformanceTestFiles','Erin''s Thesis');

% status = true;
% working
cdfPathArray = crawldir(projectDir,'*.cdf');
csvPathArray = crawldir(projectDir,'*.csv');
% status = false;

nCdf = numel(cdfPathArray);
nCsv = numel(csvPathArray);

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

if nCsv > 0
    hWaitCsv = waitbar(0, 'Reprocessing CSVs. Please wait...');
    for j1 = 1:nCsv
        try
            reprocesscsv(csvPathArray{j1},false);
        catch err
            warning(err.message);
        end
        waitbar(j1/nCsv)
    end
    close(hWaitCsv);
end

% function working
% %WORKING Summary of this function goes here
% %   Detailed explanation goes here
% 
% clc
% fprintf('Searching...')
% flash = 0;
% while status
%     switch flash
%         case 0
%             fprintf('\b');
%             flash = 1;
%             pause(.5)
%         case 1
%             fprintf('.')
%             flash = 0;
%             pause(.5)
%     end
% 
% end
% clc
% 
% end

end
