function condition = findcondition(group,expWeek)
%FINDCONDITION Summary of this function goes here
%   Detailed explanation goes here

switch expWeek
    case 1
        switch group
            case 1
                condition = 'dim';
            case 2
                condition = 'highCct';
            case 3
                condition = 'daylight';
            otherwise
                condition = 'unknown';
        end
    case 2
        switch group
            case 1
                condition = 'highCct';
            case 2
                condition = 'daylight';
            case 3
                condition = 'dim';
            otherwise
                condition = 'unknown';
        end
    case 3
        switch group
            case 1
                condition = 'daylight';
            case 2
                condition = 'dim';
            case 3
                condition = 'highCct';
            otherwise
                condition = 'unknown';
        end
    otherwise
        condition = 'unknown';
end
end

