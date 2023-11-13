% Author: Woojae Jeong, May 18, 2023
% Revised: Aug 1, 2023

%% Automated BrainStorm preprocessing pipeline

% EEG file directory path

path = '/Users/woojaejeong/Desktop/Data/USC/DARPA-NEAT/Data/Sentence Stroop/';

items = dir(path);
folderNames = {items([items.isdir] & ~strcmp({items.name}, '.') & ~strcmp({items.name}, '..')).name};

% Start BrainStorm
if ~brainstorm('status')
    brainstorm nogui % Start BrainStorm without GUI
    % brainstorm    % Start BrainStorm with GUI
end

cnt = 0;

error_List = [];

for n = 21:size(folderNames,2)
    n
    cnt

    try
        % EEG file
        fpath = [path, folderNames{n},'/'];
        fileName = dir([fpath,'*.eeg']);

        % Load badChan.mat
            
        chan = {};
        % load([fpath,'badChan_',erase(fileName.name,'.eeg'),'.mat']);
               
        % Preprocessing pipeline
        gui_brainstorm('EmptyTempFolder');  % Empty temporary folder
        
        % File name
        name = fileName.name;

        % Subject name (for BrainStorm)
        SubjectNames = {erase(name,'.eeg')};

        % EEG data in *.eeg format
        RawFiles = {[fpath,name]};

        % Protocol name (for BrainStorm)
        protocolName = 'DARPA_Sentence_task';
        
        % Call preprocessing pipelines
        preprocPipelineDarpa_sentence;

    catch
        cnt = cnt+1;
        error_List{cnt} = SubjectNames;
    end
    clc;
end

if ~isempty(error_List)
    save([fpath, 'errorList.mat'],'error_List');
end

% Stop BrainStorm
brainstorm stop;
