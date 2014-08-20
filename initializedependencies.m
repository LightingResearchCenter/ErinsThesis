function initializedependencies
%INITIALIZEDEPENDENCIES Add necessary repos to working path
%   Detailed explanation goes here

% Find full path to github directory
[githubDir,~,~] = fileparts(pwd);

% Construct repo paths
cdfPath         = fullfile(githubDir,'LRC-CDFtoolkit');
daysigramPath   = fullfile(githubDir,'DaysigramReport');
lightHealthPath = fullfile(githubDir,'LHIReport');
croppingPath    = fullfile(githubDir,'DaysimeterCropToolkit');

% Enable repos
addpath(cdfPath,daysigramPath,lightHealthPath,croppingPath);

end

