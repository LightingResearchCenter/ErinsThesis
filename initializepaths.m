function Paths = initializepaths
%INITIALIZEPATHS Prepare Erin's Thesis folder and file paths
%   Detailed explanation goes here

% Preallocate output structure
Condition = struct(...
    'all'       ,'',...
    'dim'       ,'',...
    'highCct'   ,'',...
    'daylight'  ,'');
Paths = struct(...
    'project'       ,'',...
    'originalData'  ,Condition,...
    'editedData'    ,Condition,...
    'results'       ,'',...
    'plots'         ,'');

% Set project directory
Paths.project = fullfile([filesep,filesep],'root','projects',...
    'L&H-PerformanceTestFiles','Erin''s Thesis','Daysimeter Files',...
    'geoffReanalysis');
% Check that it exists
if exist(Paths.project,'dir') ~= 7 % 7 = folder
    error(['Cannot locate the folder: ',Paths.project]);
end

Paths.results      = fullfile(Paths.project,'results');
Paths.plots        = fullfile(Paths.project,'plots');

Paths.originalData.all = fullfile(Paths.project,'originalData');
Paths.editedData.all   = fullfile(Paths.project,'editedData');

Paths.originalData.dim      = fullfile(Paths.originalData.all,'dim');
Paths.originalData.highCct  = fullfile(Paths.originalData.all,'highCct');
Paths.originalData.daylight = fullfile(Paths.originalData.all,'daylight');

Paths.editedData.dim        = fullfile(Paths.editedData.all,'dim');
Paths.editedData.highCct    = fullfile(Paths.editedData.all,'highCct');
Paths.editedData.daylight   = fullfile(Paths.editedData.all,'daylight');

end

