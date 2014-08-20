function batchaverage
%BATCHAVERAGE Summary of this function goes here
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

startTimeArray = [datenum(0,0,0, 7,30,0),...
                  datenum(0,0,0, 9, 0,0),...
                  datenum(0,0,0, 9,45,0),...
                  datenum(0,0,0,12, 0,0),...
                  datenum(0,0,0,12,45,0),...
                  datenum(0,0,0,15, 0,0)];

stopTimeArray  = [datenum(0,0,0, 9, 0,0),...
                  datenum(0,0,0, 9,45,0),...
                  datenum(0,0,0,12, 0,0),...
                  datenum(0,0,0,12,45,0),...
                  datenum(0,0,0,15, 0,0),...
                  datenum(0,0,0,15,45,0)];

sessionNameArray = {'Break 1 7:30-9:00',...
                    'Testing 1 9:00-9:45',...
                    'Break 2 9:45-12:00',...
                    'Testing 2 12:00-12:45',...
                    'Break 3 12:45-15:00',...
                    'Testing 3'};

for iCondition = 1:3
    thatCondition = conditionArray{iCondition};
    
    conditionFilePathArray = filePathArray{iCondition};
    nFile = numel(conditionFilePathArray);
    for iFile = 1:nFile
        Data = ProcessCDF(conditionFilePathArray{iFile});
        logicalArray = logical(Data.Variables.logicalArray);
        activityArray = Data.Variables.activity;
        
        idxError = activityArray > 1;
        logicalArray = logicalArray & ~idxError;
        
        timeArray = Data.Variables.time(logicalArray);
        illuminanceArray = Data.Variables.illuminance(logicalArray);
        claArray = Data.Variables.CLA(logicalArray);
        csArray = Data.Variables.CS(logicalArray);
        activityArray = Data.Variables.activity(logicalArray);

        subject = Data.GlobalAttributes.subjectID{1};
        daysimeter = Data.GlobalAttributes.deviceSN{1};
        
        [TempAverageLux,TempAverageCla,TempAverageCs] = ...
            averagesessions(subject,daysimeter,startTimeArray,stopTimeArray,...
            timeArray,illuminanceArray,claArray,csArray);
        
        if iFile == 1
            AverageLux = TempAverageLux;
            AverageCla = TempAverageCla;
            AverageCs  = TempAverageCs;
        else
            AverageLux = mergecells(AverageLux,TempAverageLux);
            AverageCla = mergecells(AverageCla,TempAverageCla);
            AverageCs = mergecells(AverageCs,TempAverageCs);
        end
    end
    
    xlswrite('lux.xlsx',AverageLux,thatCondition);
    xlswrite('cla.xlsx',AverageCla,thatCondition);
    xlswrite('cs.xlsx',AverageCs,thatCondition);
end

end


function [AverageLux,AverageCla,AverageCs] = averagesessions(subject,daysimeter,startTimeArray,stopTimeArray,timeArray,illuminanceArray,claArray,csArray)


timeOfDayArray = mod(timeArray,1);
dateArray = floor(timeArray);

% Find time during the experiment
idxExperiment = (timeOfDayArray >= startTimeArray(1)) & ...
                (timeOfDayArray <  stopTimeArray(end));
expDateArray = unique(dateArray(idxExperiment));
nDay = numel(expDateArray);

% Preallocate output.
nSession = numel(startTimeArray);
averageLuxArray = cell(nDay+1,nSession+1);
averageClaArray = cell(nDay+1,nSession+1);
averageCsArray  = cell(nDay+1,nSession+1);

keyArray = cell(nDay+1,nSession+1);

for iDay = 1:nDay
    idxDay = dateArray == expDateArray(iDay);
    for iSession = 1:nSession
        idxSession = (timeOfDayArray >= startTimeArray(iSession)) & ...
                     (timeOfDayArray <  stopTimeArray(iSession));
        idx = idxDay & idxSession;
        
        if iDay == nDay
            idx = idxSession;
            averageLuxArray{nDay+1,iSession} = logmean(illuminanceArray(idx));
            averageClaArray{nDay+1,iSession} = logmean(claArray(idx));
            averageCsArray{nDay+1 ,iSession} = mean(csArray(idx));
            keyArray{nDay+1,iSession} = ['dAll_s',num2str(iSession)];
        end
        
        if ~any(idx)
            continue;
        end
        
        averageLuxArray{iDay,iSession} = logmean(illuminanceArray(idx));
        averageClaArray{iDay,iSession} = logmean(claArray(idx));
        averageCsArray{iDay ,iSession} = mean(csArray(idx));
        keyArray{iDay,iSession} = ['d',num2str(iDay),'_s',num2str(iSession)];
        
    end
    
    idx = idxDay & idxExperiment;
    averageLuxArray{iDay,nSession+1} = logmean(illuminanceArray(idx));
    averageClaArray{iDay,nSession+1} = logmean(claArray(idx));
    averageCsArray{iDay ,nSession+1} = mean(csArray(idx));
    keyArray{iDay,nSession+1} = ['d',num2str(iDay),'_sAll'];
end

idx = idxExperiment;
averageLuxArray{nDay+1,nSession+1} = logmean(illuminanceArray(idx));
averageClaArray{nDay+1,nSession+1} = logmean(claArray(idx));
averageCsArray{nDay+1 ,nSession+1} = mean(csArray(idx));
keyArray{nDay+1,nSession+1} = 'dAll_sAll';

averageLuxArray = reshape(averageLuxArray',1,numel(averageLuxArray));
averageClaArray = reshape(averageClaArray',1,numel(averageClaArray));
averageCsArray  = reshape(averageCsArray' ,1,numel(averageCsArray ));

keyArray = reshape(keyArray' ,1,numel(keyArray));

AverageLux = [{'00subject','01daysimeter'},keyArray;...
              { subject , daysimeter },averageLuxArray];
AverageCla = [{'00subject','01daysimeter'},keyArray;...
              { subject , daysimeter },averageClaArray];
AverageCs  = [{'00subject','01daysimeter'},keyArray;...
              { subject , daysimeter },averageCsArray];
end


function cellC = mergecells(cellA,cellB)
% get the list of all keys
keys = unique([cellA(1,:) cellB(1,:)]);

lena = size(cellA,1)-1;  lenb = size(cellB,1)-1;

% allocate space for the joined array
cellC = cell(lena+lenb+1, length(keys));

cellC(1,:) = keys;

% add a
tf = ismember(keys, cellA(1,:));
cellC(2:(2+lena-1),tf) = cellA(2:end,:);

% add b
tf = ismember(keys, cellB(1,:));
cellC((lena+2):(lena+lenb+1),tf) = cellB(2:end,:);
end