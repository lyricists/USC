% Woojae Jeong: May 18, 2023
% Revised: Aug 1, 2023

%% Automated BrainStorm preprocessing pipeline

% EEG file directory path

path = '/Users/woojaejeong/Desktop/Data/USC/DARPA-NEAT/Data/Classical Stroop/EEG/';

fileName = dir([path,'*.eeg']);

% Start BrainStorm
if ~brainstorm('status')
    brainstorm nogui % Start BrainStorm without GUI
    % brainstorm    % Start BrainStorm with GUI
end

cnt = 0;

error_List = [];

for n = 1:size(fileName,1)
    n
    cnt

    try
        % Load badChan.mat

        chan = {};
        load([path,'badChan_',erase(fileName(n).name,'.eeg'),'.mat']);
        
        % Preprocessing pipeline
        gui_brainstorm('EmptyTempFolder');  % Empty temporary folder
        
        % File name
        name = fileName(n).name;

        % Subject name (for BrainStorm)
        SubjectNames = {erase(name,'.eeg')};

        % EEG data in *.eeg format
        RawFiles = {[path,name]};

        % Protocol name (for BrainStorm)
        protocolName = 'DARPA_marker';
        
        % Call preprocessing pipelines
        preprocPipelineDarpa;
        % preprocPipelineDarpa_bp;

    catch
        cnt = cnt+1;
        error_List{cnt} = SubjectNames;
    end
    clc;
end

if ~isempty(error_List)
    save([path, 'errorList.mat'],'error_List');
end

% Stop BrainStorm
brainstorm stop;
