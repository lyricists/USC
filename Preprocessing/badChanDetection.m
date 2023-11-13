% Author: Woojae Jeong

%% Bad channel detection using ASR routine EEGLab

% EEG file directory path

path = '/Users/woojaejeong/Desktop/Data/USC/DARPA-NEAT/Data/Classical Stroop/EEG/';

fileName = dir([path,'*.vhdr']);

%% Bad channel detection

eeglab;

for n = 1:size(fileName,1)
    n
    chan = [];
    
    dat = pop_loadbv(path, fileName(n).name);
    
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

    save([path,'badChan_',erase(fileName(n).name,'.vhdr'),'.mat'],'chan');
end