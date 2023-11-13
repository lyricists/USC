nchan = [];

for n = 1:12
    % Define directory path and name of the EEG file
    path = ['/Users/woojaejeong/Desktop/Data/USC/DARPA-NEAT/Data/Classical Stroop/EEG/Sub',...
        num2str(n),'/'];

    load([path,'badChan.mat'],'chan');

    nchan = [nchan; size(chan,2)];
end
