id = '004';
path = ['/Users/woojaejeong/Desktop/Data/USC/DARPA-NEAT/Data/Sentence Stroop/Sub',id,'/'];

load([path, 'sub_',id,'_SentenceStroop.mat']);
load([path, 'recon_events_sub',id,'_sent.mat']);

rank = [];

for i = 1:320
    tmp = find(cellfun(@(x) isnumeric(x) && x == i, config.logData(:,1)));
    
    rank = [rank; config.logData{tmp(1),11}];
end

fullid = 1:320;
fullid(rank < 5) = [];

wt1 = []; wt2 = []; wt3 = []; wt4 = []; wt5 = [];
wi1 = []; wi2 = []; wi3 = []; wi4 = []; wi5 = [];

for i = 1:length(fullid)

    idx = find(cellfun(@(x) isnumeric(x) && x == fullid(i), config.logData(:,1)));

    TOI = events(6).times(i);

    for j = 1:5
        id = length(idx)-j;

        if j == 2
            mTime = TOI - config.logData{idx(id),16};
            wt5 = [wt5 mTime];

        elseif j == 3
            mTime = mTime - config.logData{idx(id),16};
            wt4 = [wt4 mTime];

        elseif j == 4
            mTime = mTime - config.logData{idx(id),16};
            wt3 = [wt3 mTime];

        elseif j == 5
            mTime = mTime - config.logData{idx(id),16};
            wt2 = [wt2 mTime];

        elseif j == 1
            % mTime = mTime - config.logData{idx(id),16};
            % wt1 = [wt1 mTime];
        end
    end
end

%%
a1 = [mean(abs(wt5 - events(7).times)) std(abs(wt5-events(7).times))]
a2 = [mean(abs(wt4 - events(8).times(fullid))) std(abs(wt4-events(8).times(fullid)))]
a3 = [mean(abs(wt3 - events(9).times(fullid))) std(abs(wt3-events(9).times(fullid)))]
a4 = [mean(abs(wt2 - events(10).times(fullid))) std(abs(wt2-events(10).times(fullid)))]
