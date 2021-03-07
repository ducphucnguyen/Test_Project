clc, clear

T = readtable('sleep.csv','VariableNamingRule','preserve');

for i=1:size(T,1)
    
    % from column
    d = T.from(i);
    datepart = extractBefore(d,"T"); % extract date
    timepart = extractBetween(d,"T","+"); % extract time

    datestring = append(datepart," ", timepart); % combine string
    d2 = datetime(datestring,'InputFormat','yyyy-MM-dd HH:mm:ss'); % convert to datetime

    from(i,1) = d2;
    
    % to column
    d = T.to(i);
    datepart = extractBefore(d,"T"); % extract date
    timepart = extractBetween(d,"T","+"); % extract time

    datestring = append(datepart," ", timepart); % combine string
    d2 = datetime(datestring,'InputFormat','yyyy-MM-dd HH:mm:ss'); % convert to datetime

    to(i,1) = d2;
    
end


T(:,1:2) = [];
T.from = from;
T.to = to;

T = movevars(T, 13, 'Before', 1);
T = movevars(T, 14, 'Before', 2);


writetable(T,'sleep_1.csv');



