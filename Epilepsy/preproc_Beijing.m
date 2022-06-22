for i = 25:30
    i
    try
        restoredefaultpath;
        addpath(genpath('/ImagePTE1/brainsuite/Woojae/Analysis/bfp/src'));

        fd = {'sub00440','sub01018','sub01244','sub02403','sub04050',...
            'sub04191','sub05267','sub06880','sub06899','sub07144',...
            'sub07716','sub07717','sub08001','sub08251','sub08455',...
            'sub08816','sub08992','sub10186','sub10277','sub10869',...
            'sub10973','sub11072','sub11344','sub12220','sub14238',...
            'sub15441','sub16091','sub16943','sub17093','sub17159'};

        % Set the input arguments
        configfile='/ImagePTE1/brainsuite/Woojae/Analysis/bfp/supp_data/config_bfp_preproc.ini';

        t1 = ['/ImagePTE1/brainsuite/Woojae/Analysis/Epilepsy/Beijing/',fd{i},'/anat/standard.nii.gz'];
        fmri = ['/ImagePTE1/brainsuite/Woojae/Analysis/Epilepsy/Beijing/',fd{i},'/func/',fd{i},'_rest_bold.nii.gz'];
        studydir='/ImagePTE1/brainsuite/Woojae/Analysis/Epilepsy/Beijing/';
        subid= fd{i};
        sessionid='rest';
        TR='';

        % Call the bfp function
        bfp(configfile, t1, fmri, studydir, subid, sessionid,TR);

        clc;clear all;close all;

    catch
        save(['/ImagePTE1/brainsuite/Woojae/Analysis/Epilepsy/Beijing/',fd{i},'/Error.txt']);

        clc;clear all;close all;
    end
end