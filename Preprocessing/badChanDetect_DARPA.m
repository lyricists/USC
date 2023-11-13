% Author: Woojae Jeong

%% Bad channel detection using ASR routine EEGLab

% EEG file directory path

path = '/Users/woojaejeong/Desktop/Data/USC/DARPA-NEAT/Data/Emotional Stroop/';

items = dir(path);
folderNames = {items([items.isdir] & ~strcmp({items.name}, '.') & ~strcmp({items.name}, '..')).name};

%% Bad channel detection

% eeglab;

for n = 21:size(folderNames,2)
    n
    
    fpath = [path, folderNames{n},'/'];

    % EEG file
    fileName = dir([fpath,'*.vhdr']);

    chan = [];
    
    dat = pop_loadbv(fpath, fileName.name);
    
    % Non-EEG channel rejection
    if dat.nbchan ~=64
        dat.nbchan = 64;
        dat.data = dat.data(1:64,:);
        dat.chanlocs(65:68) = [];
    end

    EEG = clean_rawdata(dat, 5, [0.25 0.75], 0.7, -1, -1, -1);
    chan = [];

    if EEG.nbchan ~= 64
        id = find(EEG.etc.clean_channel_mask == 0);

        for i = 1:size(id,1)
            chan{i} = dat.chanlocs(id(i)).labels;
        end

    else
        chan{1} = {''};
    end

    save([fpath,'badChan_',erase(fileName.name,'.vhdr'),'.mat'],'chan');
end