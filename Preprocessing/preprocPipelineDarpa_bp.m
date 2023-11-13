% Woojae Jeong: May 18, 2023
% Revised: Aug 1, 2023

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

if ~isempty(char(chan{:}))
    % Process: Set bad channels

    sFiles = bst_process('CallProcess', 'process_channel_setbad', sFiles, [], ...
        'sensortypes', chan); % Specify bad channel names

    % Process: Interpolate bad electrodes
    sFiles = bst_process('CallProcess', 'process_eeg_interpbad', sFiles, [], ...
        'maxdist',     5, ...
        'sensortypes', 'EEG');
end

% Process: Re-reference EEG
sFiles = bst_process('CallProcess', 'process_eegref', sFiles, [], ...
    'eegref',      'AVERAGE', ...
    'sensortypes', 'EEG');

% Process: Detect eye blinks
sFiles = bst_process('CallProcess', 'process_evt_detect_eog', sFiles, [], ...
    'channelname', 'VEOG', ...   % Define the reference channel for eye blink detection
    'timewindow',  [], ...
    'eventname',   'blink');    % Define the marker name

% Process: SSP EOG: blink
sFiles = bst_process('CallProcess', 'process_ssp_eog', sFiles, [], ...
    'eventname',   'blink', ... % Marker name defined from the eye blink detect process
    'sensortypes', 'EEG', ...
    'usessp',      0, ...
    'select',      1);

sFiles_notch = sFiles;

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

% Process: Notch filter: 60Hz
sFiles = bst_process('CallProcess', 'process_notch', sFiles, [], ...
    'sensortypes', 'MEG, EEG', ...
    'freqlist',    [60], ...  % Define frequency of the line noise
    'cutoffW',     1, ...
    'useold',      0, ...
    'overwrite',   1);

% Process: Band-pass filter
sFiles = bst_process('CallProcess', 'process_bandpass', sFiles, [], ...
    'sensortypes', '', ...
    'highpass',    0.5, ...   % High-pass frequency
    'lowpass',     30, ...  % Low-pass frequency
    'tranband',    0, ...
    'attenuation', 'strict', ...  % 60dB
    'ver',         '2019', ...  % 2019
    'mirror',      0, ...
    'overwrite',   1);

% Process: Remove linear trend: all time series
sFiles = bst_process('CallProcess', 'process_detrend', sFiles, [], ...
    'timewindow',  [], ...
    'sensortypes', 'EEG', ...
    'overwrite',   1);

% Process: Import MEG/EEG: Events
sFiles = bst_process('CallProcess', 'process_import_data_event', sFiles, [], ...
    'subjectname',   SubjectNames{1}, ...
    'condition',     '', ...
    'eventname',     'S  1, S  2', ...  % Marker name
    'timewindow',    [], ...
    'epochtime',     [-0.199, 1], ...
    'split',         0, ...
    'createcond',    0, ...
    'ignoreshort',   0, ...
    'usectfcomp',    1, ...
    'usessp',        1, ...
    'freq',          [], ...
    'baseline',      [], ...
    'blsensortypes', 'MEG, EEG');

% Process: Z-score transformation: [-199ms,-1ms]
sFiles = bst_process('CallProcess', 'process_baseline_norm', sFiles, [], ...
    'baseline',    [-0.199, -0.001], ...
    'sensortypes', 'EEG', ...
    'method',      'zscore', ...  % Z-score transformation:    x_std = (x - &mu;) / &sigma;
    'overwrite',   1);

%% Data save
 
Result = [];

for i = 1:size(sFiles,2)  

    file = [bst_db_dir, '/',protocolName,'/',sFiles(i).FileType,'/', sFiles(i).FileName];
    load(file);

    if i == 1
        fileChan = [bst_db_dir, '/',protocolName,'/',sFiles(i).FileType,'/', sFiles(i).ChannelFile];
        load(fileChan)
        Result.channel = Channel(1:64);
        Result.Time = Time;
    else
    end

    Result.data = cat(3, Result.data, F(1:64,:));
    Result.label{i} = sFiles(i).Comment;
end

save([path,erase(name,'.eeg'),'_bst_preprocessed_data.mat'],'Result','-v7.3');
save([path,erase(name,'.eeg'),'_bst_preprocessed_sFiles.mat'],'sFiles','sFiles_notch','-v7.3');