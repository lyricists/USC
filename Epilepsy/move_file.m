pdset = '/ImagePTE1/brainsuite/Woojae/Analysis/Epilepsy/Output_Bord_Beijing/';

for i = 1:30
    try
        fd = {'sub00440','sub01018','sub01244','sub02403','sub04050',...
            'sub04191','sub05267','sub06880','sub06899','sub07144',...
            'sub07716','sub07717','sub08001','sub08251','sub08455',...
            'sub08816','sub08992','sub10186','sub10277','sub10869',...
            'sub10973','sub11072','sub11344','sub12220','sub14238',...
            'sub15441','sub16091','sub16943','sub17093','sub17159'};

        p = ['/ImagePTE1/brainsuite/Woojae/Analysis/Epilepsy/Beijing/',fd{i},'/func/'];

%         filename1 = [fd{i},'_rest_bold.32k.GOrd.filt.mat'];
        filename2 = [fd{i},'_rest_bold.BOrd.mat'];

%         source1 = fullfile(p,filename1);
%         destination1 = fullfile(pdset,filename1);
%         copyfile(source1,destination1);

        source2 = fullfile(p,filename2);
        destination2 = fullfile(pdset,filename2);
        copyfile(source2,destination2);

    catch
    end
end

%% Available subject

fd = {'F1960H1P','F1979I24','F1988I21','F1989GC7','M1960GAP',...
            'study11258','study12028','study12098','study12525','study12554',...
            };

fd = {'pb0438','pb0710','sn0141','sn0364','sn4055',...
            'sn4102','sn4214','sn4503_2','sn4553','sn4781',...
            'sn5097','sn5579','sn5895','sn6012','sn6095',...
            'sn6372','sn6594','sn7256','sn7602','sn7915',...
            'sn8002','sn8035','sn8133','sn8252','sn8333',...
            'sn8440','sn8556','sn8578','ta0418',...
            'ta8088','ta8409','ta8451','ta8600','ta9130'};
% % 
fd = {'pb0438','pb0710','sn0141','sn0364','sn4055',...
            'sn4102','sn4214','sn4503','sn4503_2','sn4553',...
            'sn4753','sn4781','sn5097','sn5097_2','sn5563',...
            'sn5579','sn5895','sn6012','sn6095','sn6372',...
            'sn6594','sn7120','sn7256','sn7602','sn7915',...
            'sn7915_2','sn8002','sn8035','sn8133','sn8252',...
            'sn8333','sn8440','sn8556','sn8578','ta0418',...
            'ta8088','ta8409','ta8451','ta8600','ta9130'};

fd = {'pb0438','pb0710','sn0364','sn4055',... 
      'sn4102','sn4214','sn4503','sn4781',...
      'sn5097','sn5579','sn5895','sn6012','sn6095',...
      'sn6372','sn6594','sn7256','sn7602','sn7915',...
      'sn8002','sn8035','sn8252','sn8333',...
      'sn8556','sn8578','ta0418',...
      'ta8088','ta8409','ta8451','ta8600','ta9130'};

fd = {'1038415','1050345','1050975','1056121','1068505',...
    '1093743','1094669','1113498','1117299','1132854',...
    '1133221','1139030','1159908','1177160','1186237',...
    '1201251','1240299','1245758','1253411','1258069',...
    '1282248','1302449','1341865','1356553','1391181',...
    '1399863','1404738','1408093','1411536','1419103'};

fd = {'sub-OAS30001_ses-d0129_run_02',...
    'sub-OAS30003_ses-d0558_run_02',...
    'sub-OAS30004_ses-d1101_run_02',...
    'sub-OAS30007_ses-d0061_run_02',...
    'sub-OAS30008_ses-d0061_run_02',...
    'sub-OAS30009_ses-d0148_run_02',...
    'sub-OAS30010_ses-d0068_run_02',...
    'sub-OAS30011_ses-d0055_run_02',...
    'sub-OAS30013_ses-d0102_run_02',...
    'sub-OAS30014_ses-d0196_run_02',...
    'sub-OAS30016_ses-d0021_run_02',...
    'sub-OAS30017_ses-d0054_run_02',...
    'sub-OAS30018_ses-d0070_run_02',...
    'sub-OAS30019_ses-d0376_run_02',...
    'sub-OAS30025_ses-d0210_run_02',...
    'sub-OAS30026_ses-d0048_run_02',...
    'sub-OAS30027_ses-d0433_run_02',...
    'sub-OAS30028_ses-d0043_run_02',...
    'sub-OAS30029_ses-d0131_run_02',...
    'sub-OAS30030_ses-d0170_run_02',...
    'sub-OAS30033_ses-d0133_run_02',...
    'sub-OAS30034_ses-d0044_run_02',...
    'sub-OAS30035_ses-d2218_run_02',...
    'sub-OAS30036_ses-d0059_run_02',...
    'sub-OAS30037_ses-d0154_run_02',...
    'sub-OAS30039_ses-d0103_run_02',...
    'sub-OAS30042_ses-d0067_run_02',...
    'sub-OAS30043_ses-d0145_run_02',...
    'sub-OAS30044_ses-d0054_run_02',...
    'sub-OAS30046_ses-d0072_run_02'};