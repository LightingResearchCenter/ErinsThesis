function cropdata
%CROPDATA Summary of this function goes here
%   Detailed explanation goes here

% Enable dependecies
initializedependencies;

% Construct project paths
Paths = initializepaths;
originalDirArray = {Paths.originalData.dim,Paths.originalData.highCct,Paths.originalData.daylight};
editedDirArray = {Paths.editedData.dim,Paths.editedData.highCct,Paths.editedData.daylight};
nDir = numel(originalDirArray);

for iDir = 1:nDir
    originalDir = originalDirArray{iDir};
    newDir = editedDirArray{iDir};
    [~,filePathArray] = searchdir(originalDir,'.cdf');
    nFile = numel(filePathArray);
    
    for iFile = 1:nFile
        % New File set up
        cdfPath = filePathArray{iFile};
        [~,cdfName,cdfExt] = fileparts(cdfPath);
        newName = [cdfName,cdfExt];
        newPath = fullfile(newDir,newName);

        % Load the data
        DaysimeterData = ProcessCDF(cdfPath);
        subjectId = DaysimeterData.GlobalAttributes.subjectID{1};
        timeArray = DaysimeterData.Variables.time;

        group = findgroup(subjectId);
        [startTime,stopTime,expWeek] = experimentbounds(timeArray);
        condition = findcondition(group,expWeek);
        stopTime = specialcrop(condition,subjectId,stopTime);

        % Create logical arrays
        logicalArray = (timeArray >= startTime) & (timeArray <= stopTime);
        complianceArray = true(size(timeArray));
        bedArray = false(size(timeArray));

        % Assign the modified variables
        DaysimeterData.Variables.logicalArray = logicalArray;
        DaysimeterData.Variables.complianceArray = complianceArray;
        DaysimeterData.Variables.bedArray = bedArray;

        DaysimeterData = addcdfproperties(DaysimeterData);

        % Save new file  
        RewriteCDF(DaysimeterData, newPath);
    end
end


end


function stopTime = specialcrop(condition,subjectId,stopTime)

digitIdx = isstrprop(subjectId,'digit');

if ~any(digitIdx)
    return;
end

subjectId = str2double(subjectId(digitIdx));

switch condition
    case 'dim'
        switch subjectId
            case 9
                stopTime = datenum(2013,7,31,15,45,0);
            otherwise
                return;
        end
    case 'highCct'
        switch subjectId
            case 3
                stopTime = datenum(2013,7,31,15,45,0);
            case 10
                stopTime = datenum(2013,8,14,15,45,0);
            case 11
                stopTime = datenum(2013,8,14,15,45,0);
            otherwise
                return;
        end
    case 'daylight'
        switch subjectId
            case 6
                stopTime = datenum(2013,7,31,15,45,0);
            otherwise
                return;
        end
    otherwise
        return;
end

end


function DaysimeterData = addcdfproperties(DaysimeterData)

% Compliance array properties
DaysimeterData.VariableAttributes.description{11,1} = 'complianceArray';
DaysimeterData.VariableAttributes.description{11,2} = 'compliance array, true = subject appears to be using the device';
DaysimeterData.VariableAttributes.unitPrefix{11,1} = 'complianceArray';
DaysimeterData.VariableAttributes.unitPrefix{11,2} = '';
DaysimeterData.VariableAttributes.baseUnit{11,1} = 'complianceArray';
DaysimeterData.VariableAttributes.baseUnit{11,2} = '1';
DaysimeterData.VariableAttributes.unitType{11,1} = 'complianceArray';
DaysimeterData.VariableAttributes.unitType{11,2} = 'logical';
DaysimeterData.VariableAttributes.otherAttributes{11,1} = 'complianceArray';
DaysimeterData.VariableAttributes.otherAttributes{11,2} = '';

% Bed array properties
DaysimeterData.VariableAttributes.description{12,1} = 'bedArray';
DaysimeterData.VariableAttributes.description{12,2} = 'bed array, true = subject reported being in bed';
DaysimeterData.VariableAttributes.unitPrefix{12,1} = 'bedLog';
DaysimeterData.VariableAttributes.unitPrefix{12,2} = '';
DaysimeterData.VariableAttributes.baseUnit{12,1} = 'bedLog';
DaysimeterData.VariableAttributes.baseUnit{12,2} = '1';
DaysimeterData.VariableAttributes.unitType{12,1} = 'bedArray';
DaysimeterData.VariableAttributes.unitType{12,2} = 'logical';
DaysimeterData.VariableAttributes.otherAttributes{12,1} = 'bedArray';
DaysimeterData.VariableAttributes.otherAttributes{12,2} = '';

end

