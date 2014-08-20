function [startTime,stopTime,expWeek] = experimentbounds(timeArray)

% Set start and stop dates and times of experiment sessions.
% Week 1
start1 = datenum(2013,7,15,  7,30,0);
stop1  = datenum(2013,7,19, 15,45,0);
% Week 2
start2 = datenum(2013,7,29,  7,30,0);
stop2  = datenum(2013,8, 2, 15,45,0);
% Week 3
start3 = datenum(2013,8,12,  7,30,0);
stop3  = datenum(2013,8,16, 15,45,0);

% Find times within specified bounds.
week1 = (timeArray >= start1) & (timeArray <= stop1);
week2 = (timeArray >= start2) & (timeArray <= stop2);
week3 = (timeArray >= start3) & (timeArray <= stop3);

% Determine experiment session and create logical array.
if any(week1)
    startTime = start1;
    stopTime = stop1;
    expWeek = 1;
elseif any(week2)
    startTime = start2;
    stopTime = stop2;
    expWeek = 2;
elseif any(week3)
    startTime = start3;
    stopTime = stop3;
    expWeek = 3;
else
    startTime = timeArray(1);
    stopTime = timeArray(end);
    expWeek = 0;
end

end
