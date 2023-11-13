path = '/Users/woojaejeong/Desktop/Data/USC/DARPA-NEAT/Data/Sentence Stroop/';

items = dir(path);
folderNames = {items([items.isdir] & ~strcmp({items.name}, '.') & ~strcmp({items.name}, '..')).name};

for k = 3:7
    k
    id = ['00',num2str(k)];
    path = ['/Users/woojaejeong/Desktop/Data/USC/DARPA-NEAT/Data/Sentence Stroop/Sub',id,'/'];

    load([path, 'sub_',id,'_SentenceStroop.mat']);
    log = config.logData;
    eyelink = edfmex([path,'EY',id,'_ST.edf']);
    marker_ori = load([path, 'events_sub',id,'_sent.mat']);

    idx = [];

    for n = 1:size(marker_ori.events,2)

        if strcmp(marker_ori.events(n).label, 'S 52')
            time_ori = marker_ori.events(n).times;
            idx = [idx; n];

        elseif strcmp(marker_ori.events(n).label, 'S 54')
            idx = [idx; n];

        elseif strcmp(marker_ori.events(n).label, 'S 55')
            idx = [idx; n];

        elseif strcmp(marker_ori.events(n).label, 'S 56')
            idx = [idx; n];
        end
    end

    for i = 1:160
        tmp = i+80;

        name{i} = ['S',num2str(tmp)];
    end

    startime = []; endtime_TOI = [];
    endtime1 = []; endtime2 = []; endtime3 = []; endtime4 = []; endtime5 = [];

    for n = 1:size(eyelink.FEVENT,2)

        if strcmp(eyelink.FEVENT(n).message, 'S52')
            startime = [startime eyelink.FEVENT(n).sttime];
        end

        if sum(strcmp(name, eyelink.FEVENT(n).message)) > 0
            endtime_TOI = [endtime_TOI eyelink.FEVENT(n).sttime];
        end

        if sum(strcmp('S241', eyelink.FEVENT(n).message)) > 0
            endtime1 = [endtime1 eyelink.FEVENT(n).sttime];
        end

        if sum(strcmp('S242', eyelink.FEVENT(n).message)) > 0
            endtime2 = [endtime2 eyelink.FEVENT(n).sttime];
        end

        if sum(strcmp('S243', eyelink.FEVENT(n).message)) > 0
            endtime3 = [endtime3 eyelink.FEVENT(n).sttime];
        end

        if sum(strcmp('S244', eyelink.FEVENT(n).message)) > 0
            endtime4 = [endtime4 eyelink.FEVENT(n).sttime];
        end

        if sum(strcmp('S245', eyelink.FEVENT(n).message)) > 0
            endtime5 = [endtime5 eyelink.FEVENT(n).sttime];
        end
    end

    rank = [];

    for i = 1:320
        tmp = find(cellfun(@(x) isnumeric(x) && x == i, log(:,1)));

        rank = [rank; log{tmp(1),11}];
    end

    fullid = 1:320;
    fullid(rank < 5) = [];

    startime2 = startime(fullid);
    time_ori2 = time_ori(fullid);

    noevent.label = [];
    noevent.color = [];
    noevent.epochs = [];
    noevent.times = [];
    noevent.reactTimes = [];
    noevent.select = [];
    noevent.channels = [];
    noevent.notes = [];

    events(1) = marker_ori.events(idx(1));
    events(2) = marker_ori.events(idx(2));

    if length(idx) < 3
        events(3) = noevent;
        events(4) = noevent;

    elseif length(idx) < 4
        events(3) = marker_ori.events(idx(3));
        events(4) = noevent;

    else
        events(4) = marker_ori.events(idx(4));
    end

    time = time_ori + (double(endtime_TOI) - double(startime))./1000;

    events(5).label = 'target word';
    events(5).color = [1,0,0];
    events(5).epochs = ones(1,length(time));
    events(5).times = time;
    events(5).reactTimes = [];
    events(5).select = 1;
    events(5).channels = [];
    events(5).notes = [];

    time = time_ori2 + (double(endtime1) - double(startime2))./1000;

    events(6).label = 'Wordn_5';
    events(6).color = [1,0,0];
    events(6).epochs = ones(1,length(time));
    events(6).times = time;
    events(6).reactTimes = [];
    events(6).select = 1;
    events(6).channels = [];
    events(6).notes = [];

    time = time_ori2 + (double(endtime2) - double(startime2))./1000;

    events(7).label = 'Wordn_4';
    events(7).color = [1,0,0];
    events(7).epochs = ones(1,length(time));
    events(7).times = time;
    events(7).reactTimes = [];
    events(7).select = 1;
    events(7).channels = [];
    events(7).notes = [];

    time = time_ori + (double(endtime3) - double(startime))./1000;

    events(8).label = 'Wordn_3';
    events(8).color = [1,0,0];
    events(8).epochs = ones(1,length(time));
    events(8).times = time;
    events(8).reactTimes = [];
    events(8).select = 1;
    events(8).channels = [];
    events(8).notes = [];

    time = time_ori + (double(endtime4) - double(startime))./1000;

    events(9).label = 'Wordn_2';
    events(9).color = [1,0,0];
    events(9).epochs = ones(1,length(time));
    events(9).times = time;
    events(9).reactTimes = [];
    events(9).select = 1;
    events(9).channels = [];
    events(9).notes = [];

    time = time_ori + (double(endtime5) - double(startime))./1000;

    events(10).label = 'Wordn_1';
    events(10).color = [1,0,0];
    events(10).epochs = ones(1,length(time));
    events(10).times = time;
    events(10).reactTimes = [];
    events(10).select = 1;
    events(10).channels = [];
    events(10).notes = [];

    save([path,'recon_events_sub',id,'_sent.mat'],'events');
end
