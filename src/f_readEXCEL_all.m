clc, clear, close

% get all .*pti in a folder
cur = 'R:\CMPH-AISH-FCRE\APN-30D\4. Raw Data\Withings data'; % get this dir
file_ext = [cur '/**/*.csv']; % find all csv files
filelist=dir(file_ext);

%% filter you want to analysis are
s1name = 'raw_sleep-monitor_respiratory-rate.csv'; % read only file with this name

for i=1:length(filelist)
s2name = filelist(i).name;
tf(i,1) = strcmp(s1name,s2name);
end

filelist_new = filelist(tf,:); % this new filelist with the provided name

%% Read and analyse 
mytable_comb = table();

for i=1:length(filelist_new) % read all participants

% read data
filename_csv = [filelist_new(i).folder '\' filelist_new(i).name];
[mytable] = f_readEXCEL(filename_csv);

% read participant ID
ParticipantID = categorical({extractAfter(filelist_new(i).folder,[cur '\'])});
mytable.ParticipantID = repmat(ParticipantID,size(mytable,1),1);

mytable_comb = [mytable_comb;mytable];
end


mytable_comb_day = movevars(mytable_comb, 'ParticipantID', 'Before', 'Date');
%% Calculate weekly mean


% get unique participant ID (or number of participant)
uniqueID = unique(mytable_comb.ParticipantID);

mytable_comb_week = table();
count = 1;
for i=1:length(uniqueID)
ParticipantID = uniqueID(i);
id_group = find(mytable_comb.ParticipantID == ParticipantID);

mytable_comb_i = mytable_comb(id_group,:); % extract data for each pariticipant
mytable_comb_i = sortrows(mytable_comb_i,'Date'); % sort time stat-end

% working for each participant
date_start_i = mytable_comb_i.Date(1); % first day
WeekID = 1;

while true
    Mean = [];
    Ncount = [];
    date_end_i = date_start_i + days(6); % first day + next 6 days = a week
    %date_start_i = dateshift(date_start_i, 'start', 'day');

    id_week = find((mytable_comb_i.Date >= dateshift(date_start_i, 'start', 'day')) &...
        (mytable_comb_i.Date <= dateshift(date_end_i, 'end', 'day')) );
    

    if ~isempty(id_week)
    Mean = mean(mytable_comb_i.Mean(id_week,:));
    Ncount= size(mytable_comb_i.Mean(id_week,:),1);
    
    % save to big table
    mytable_comb_week.ParticipantID(count) = ParticipantID;
    mytable_comb_week.Startweek(count) = date_start_i;
    mytable_comb_week.Endweek(count) = date_end_i;
    mytable_comb_week.Week(count) = WeekID;
    mytable_comb_week.Ncount(count) = Ncount;
    mytable_comb_week.Mean(count) = Mean;
    
    
    
    WeekID = WeekID + 1;
    date_start_i = date_end_i + days(1);
    count = count+1;
    else
        break
    end
    
end % end each participant
end % end number of participant

mytable_comb_day
mytable_comb_week

%writetable(mytable_comb,'mytable_comb.csv');
