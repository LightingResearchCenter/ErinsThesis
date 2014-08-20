function group = findgroup(subjectId)
%FINDGROUP Summary of this function goes here
%   Detailed explanation goes here

digitIdx = isstrprop(subjectId,'digit');

if ~any(digitIdx)
    group = 0;
    return;
end

subjectId = str2double(subjectId(digitIdx));

switch subjectId
    case {1,2,3,4}
        group = 1;
    case {5,6,7,8}
        group = 2;
    case {9,10,11,12}
        group = 3;
    otherwise
        group = 0;
end

end

