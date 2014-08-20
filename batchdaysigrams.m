function batchdaysigrams
%BATCHDAYSIGRAMS Summary of this function goes here
%   Detailed explanation goes here

% Enable dependecies
initializedependencies;

% Construct project paths
Paths = initializepaths;
extension = '.cdf';
[~,dimPathArray] = searchdir(Paths.editedData.dim,extension);
[~,fhighCctPathArray] = searchdir(Paths.editedData.highCct,extension);
[~,daylightPathArray] = searchdir(Paths.editedData.daylight,extension);

filePathArray = {dimPathArray,fhighCctPathArray,daylightPathArray};
conditionArray = {'dim','highCct','daylight'};

nDaysPerSheet = 5;
printDir = Paths.plots;
lightMeasure = 'cs';
lightRange = [0,1];

for iCondition = 1:3
    thatCondition = conditionArray{iCondition};
    
    conditionFilePathArray = filePathArray{iCondition};
    nFile = numel(conditionFilePathArray);
    for iFile = 1:nFile
        Data = ProcessCDF(conditionFilePathArray{iFile});
        logicalArray = logical(Data.Variables.logicalArray);
        timeArray = Data.Variables.time(logicalArray);
        lightArray = Data.Variables.CS(logicalArray);
        activityArray = Data.Variables.activity(logicalArray);

        subject = Data.GlobalAttributes.subjectID{1};
        daysimeter = Data.GlobalAttributes.deviceSN{1};
        
        sheetTitle = ['Sub ',subject,' Daysimeter ',daysimeter,' ',thatCondition];
        fileID = [thatCondition,'_sub',subject,'_daysimeter',daysimeter];
        
        generatedaysigram(sheetTitle,timeArray,activityArray,lightArray,...
            lightMeasure,lightRange,nDaysPerSheet,printDir,fileID)
    end
    
end

end

