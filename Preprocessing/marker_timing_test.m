id = '007';
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

    TOI = events(5).times(fullid(i));

    for j = 1:5
        id = length(idx)-j;

        if j == 1
            mTime = TOI - config.logData{idx(id),16};
            wt5 = [wt5 mTime];
            wi5 = [wi5 config.logData{idx(id),16}];

        elseif j == 2
            mTime = mTime - config.logData{idx(id),16};
            wt4 = [wt4 mTime];
            wi4 = [wi4 config.logData{idx(id),16}];

        elseif j == 3
            mTime = mTime - config.logData{idx(id),16};
            wt3 = [wt3 mTime];
            wi3 = [wi3 config.logData{idx(id),16}];

        elseif j == 4
            mTime = mTime - config.logData{idx(id),16};
            wt2 = [wt2 mTime];
            wi2 = [wi2 config.logData{idx(id),16}];

        elseif j == 5
            mTime = mTime - config.logData{idx(id),16};
            wt1 = [wt1 mTime];
            wi1 = [wi1 config.logData{idx(id),16}];
        end
    end
end

%%
a1 = [mean(abs(wt5 - events(6).times)) std(abs(wt5-events(6).times))]
a2 = [mean(abs(wt4 - events(7).times)) std(abs(wt4-events(7).times))]
a3 = [mean(abs(wt3 - events(8).times(fullid))) std(abs(wt3-events(8).times(fullid)))]
a4 = [mean(abs(wt2 - events(9).times(fullid))) std(abs(wt2-events(9).times(fullid)))]
a5 = [mean(abs(wt1 - events(10).times(fullid))) std(abs(wt1-events(10).times(fullid)))]

(a1(2)+a2(2)+a3(2)+a4(2)+a5(2))/5

%%
a6 = [wt5-events(6).times;...
    wt4-events(7).times;...
    wt3-events(8).times(fullid);...
    wt2-events(9).times(fullid);...
    wt1-events(10).times(fullid)];

%%
b1 = events(5).times(fullid) - events(6).times;
b2 = events(6).times - events(7).times;
b3 = events(7).times - events(8).times(fullid);
b4 = events(8).times(fullid) - events(9).times(fullid);
b5 = events(9).times(fullid) - events(10).times(fullid);

c1 = mean(abs(wi1-b1))
c2 = mean(abs(wi2-b2))
c3 = mean(abs(wi3-b3))
c4 = mean(abs(wi4-b4))
c5 = mean(abs(wi5-b5))
