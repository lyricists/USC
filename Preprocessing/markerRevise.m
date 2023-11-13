% Author: Woojae Jeong, Sep 26, 2023

% EEG file directory path

path = '/Users/woojaejeong/Desktop/Data/USC/DARPA-NEAT/Data/Sentence Stroop/';

items = dir(path);
folderNames = {items([items.isdir] & ~strcmp({items.name}, '.') & ~strcmp({items.name}, '..')).name};

% Start BrainStorm
if ~brainstorm('status')
    brainstorm nogui % Start BrainStorm without GUI
    % brainstorm    % Start BrainStorm with GUI
end

for n = 21:size(folderNames,2)
    
    fpath = [path, folderNames{n},'/'];

    % EEG file
    fileName = dir([fpath,'*.eeg']);

    logName = dir([fpath,'*SentenceStroop.mat']);
    load(fullfile([fpath, logName.name]));

    % Preprocessing pipeline
    gui_brainstorm('EmptyTempFolder');  % Empty temporary folder

    % File name
    name = fileName.name;

    % Subject name (for BrainStorm)
    SubjectNames = {erase(name,'.eeg')};

    % EEG data in *.eeg format
    RawFiles = {[fpath,name]};

    % Protocol name (for BrainStorm)
    protocolName = 'DARPA_marker';

    % Call preprocessing pipelines

    if n < 8
        Orig = load(fullfile([fpath, 'recon_events_', SubjectNames{1},'.mat']));
        preprocMarker_ver2;
    else
        preprocMarker;
    end
end

clc;

brainstorm stop