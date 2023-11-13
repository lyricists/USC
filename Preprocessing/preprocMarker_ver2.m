
% Check if the protocol exists
protocolID = bst_get('Protocol', protocolName);

if isempty(protocolID)
    gui_brainstorm('CreateProtocol', protocolName, 0, 0); % If no, creat a new protocol
else
    gui_brainstorm('SetCurrentProtocol', protocolID); % If yes, save on a current protocol
end

%% BrainStorm directory
bst_db_dir = '/Users/woojaejeong/Desktop/Data/Computing/MATLAB_Tool/brainstorm_db';    % BrainStorm db directory

%%
sFiles = [];

% Start a new report
bst_report('Start', sFiles);

% Process: Create link to raw file
sFiles = bst_process('CallProcess', 'process_import_data_raw', sFiles, [], ...
    'subjectname',    SubjectNames{1}, ...
    'datafile',       {RawFiles{1}, 'EEG-BRAINAMP'}, ...
    'channelreplace', 1, ...
    'channelalign',   1, ...
    'evtmode',        'value');

sFiles_raw = sFiles;

% Process: Import MEG/EEG: Time
sFiles = bst_process('CallProcess', 'process_import_data_time', sFiles, [], ...
    'subjectname',   SubjectNames{1}, ...
    'condition',     '', ...
    'timewindow',    [], ...
    'split',         0, ...
    'ignoreshort',   1, ...
    'usectfcomp',    1, ...
    'usessp',        1, ...
    'freq',          [], ...
    'baseline',      [], ...
    'blsensortypes', 'MEG, EEG');

file = [bst_db_dir, '/',protocolName,'/',sFiles.FileType,'/', sFiles.FileName];
load(file);

%% colors
color1 = [1,0,0];
color2 = [0,0,1];
color3 = [0,1,1];
color4 = [1,0,1];
color5 = [1,1,0];
color6 = [0.4,0.4,1];

%% Timing markers

for i = 1:size(Events,2)
    if strcmp(Events(i).label, 'S 52')
        events(1) = Events(i);
        events(1).label = 'S52';

    elseif strcmp(Events(i).label, 'S 54')
        events(2) = Events(i);
        events(2).label = 'S54';

    elseif strcmp(Events(i).label, 'S 55')
        events(3) = Events(i);
        events(3).label = 'S55';

    elseif strcmp(Events(i).label, 'S 56')
        events(4) = Events(i);
        events(4).label = 'S56';
    end
end

for i = 1:size(Orig.events,2)
    if strcmp(Orig.events(i).label, 'target word')
        events(5) = Orig.events(i);
        events(5).label = 'S76';
        events(5).color = color1;

    elseif strcmp(Orig.events(i).label, 'Wordn_1')
        events(6) = Orig.events(i);
        events(6).label = 'S241';
        events(6).color = color2;

    elseif strcmp(Orig.events(i).label, 'Wordn_2')
        events(7) = Orig.events(i);
        events(7).label = 'S242';
        events(7).color = color2;

    elseif strcmp(Orig.events(i).label, 'Wordn_3')
        events(8) = Orig.events(i);
        events(8).label = 'S243';
        events(8).color = color2;

    elseif strcmp(Orig.events(i).label, 'Wordn_4')
        events(9) = Orig.events(i);
        events(9).label = 'S244';
        events(9).color = color2;

    elseif strcmp(Orig.events(i).label, 'Wordn_5')
        events(10) = Orig.events(i);
        events(10).label = 'S245';
        events(10).color = color2;
    end  
end

%% Category markers

% Congruency
events(11).label = 'S68';
events(11).color = color3;
events(11).times = [];
events(11).reactTimes = [];
events(11).select = 1;
events(11).channels =[];
events(11).notes = [];

events(12).label = 'S69';
events(12).color = color3;
events(12).times = [];
events(12).reactTimes = [];
events(12).select = 1;
events(12).channels =[];
events(12).notes = [];

% TOI

events(13).label = 'S64';
events(13).color = color4;
events(13).times = [];
events(13).reactTimes = [];
events(13).select = 1;
events(13).channels =[];
events(13).notes = [];

events(14).label = 'S65';
events(14).color = color4;
events(14).times = [];
events(14).reactTimes = [];
events(14).select = 1;
events(14).channels =[];
events(14).notes = [];

events(15).label = 'S66';
events(15).color = color4;
events(15).times = [];
events(15).reactTimes = [];
events(15).select = 1;
events(15).channels =[];
events(15).notes = [];

events(16).label = 'S67';
events(16).color = color4;
events(16).times = [];
events(16).reactTimes = [];
events(16).select = 1;
events(16).channels =[];
events(16).notes = [];

% Valence

events(17).label = 'S70';
events(17).color = color5;
events(17).times = [];
events(17).reactTimes = [];
events(17).select = 1;
events(17).channels =[];
events(17).notes = [];

events(18).label = 'S71';
events(18).color = color5;
events(18).times = [];
events(18).reactTimes = [];
events(18).select = 1;
events(18).channels =[];
events(18).notes = [];

events(19).label = 'S72';
events(19).color = color5;
events(19).times = [];
events(19).reactTimes = [];
events(19).select = 1;
events(19).channels =[];
events(19).notes = [];

% Surprisal

events(20).label = 'S73';
events(20).color = color6;
events(20).times = [];
events(20).reactTimes = [];
events(20).select = 1;
events(20).channels =[];
events(20).notes = [];

events(21).label = 'S74';
events(21).color = color6;
events(21).times = [];
events(21).reactTimes = [];
events(21).select = 1;
events(21).channels =[];
events(21).notes = [];

events(22).label = 'S75';
events(22).color = color6;
events(22).times = [];
events(22).reactTimes = [];
events(22).select = 1;
events(22).channels =[];
events(22).notes = [];

for i = 1:320
    time = events(5).times(i);
    idx = find(cellfun(@(x) isnumeric(x) && x == i, config.logData(:,1)));
    
    % congruency

    if strcmp(config.logData{idx(end),13}, 'Congruent')
        events(11).times = [events(11).times time+0.1];

    elseif strcmp(config.logData{idx(end),13}, 'Incongruent')
        events(12).times = [events(12).times time+0.1];
    end
    
    % TOI

    if strcmp(config.logData{idx(end),15}, 'Actions')
        events(13).times = [events(13).times time+0.2];

    elseif strcmp(config.logData{idx(end),15}, 'Intentions')
        events(14).times = [events(14).times time+0.2];

    elseif strcmp(config.logData{idx(end),15}, 'Reflection')
        events(15).times = [events(15).times time+0.2];

    elseif strcmp(config.logData{idx(end),15}, 'Biographical')
        events(16).times = [events(16).times time+0.2];
    
    end

    % Valence

    if config.logData{idx(end),23} == 70
        events(17).times = [events(17).times time+0.3];

    elseif config.logData{idx(end),23} == 71
        events(18).times = [events(18).times time+0.3];

    elseif config.logData{idx(end),23} == 72
        events(19).times = [events(19).times time+0.3];
    end

    % Surprisal

    if config.logData{idx(end),25} == 73
        events(20).times = [events(20).times time+0.4];

    elseif config.logData{idx(end),25} == 74
        events(21).times = [events(21).times time+0.4];

    elseif config.logData{idx(end),25} == 75
        events(22).times = [events(22).times time+0.4];
    end
end

for i = 11:size(events,2)
    events(i).epochs = ones(1,length(events(i).times));
end
%%
save([fpath,'events_vmrk.mat'],'events');

%%
% Input files

RawFiles = {[fpath,'events_vmrk.mat']};

% Process: Import from file
sFiles = bst_process('CallProcess', 'process_evt_import', sFiles_raw, [], ...
    'evtfile', {RawFiles{1}, 'BST'}, ...
    'evtname', 'new', ...
    'delete',  1);

file = [bst_db_dir, '/',protocolName,'/data/', sFiles.FileName];
load(file);

OutputFile = [fpath, SubjectNames{1},'_recon.vmrk'];

sFile.events = events;
sFile.filename = [fpath, name];
sFile.prop = F.prop;

out_events_brainamp(sFile, OutputFile);

% Process: Delete subjects
sFiles = bst_process('CallProcess', 'process_delete', sFiles, [], ...
    'target', 3);  % Delete subjects