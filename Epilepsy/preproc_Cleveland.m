
for i = 1:12
    try
        restoredefaultpath;
        addpath(genpath('/ImagePTE1/brainsuite/Woojae/Analysis/bfp/src'));

        fd = {'F1960H1P','F1979I24','F1986H97','F1988I21','F1989GC7',...
            'M1960GAP','study11258','study12028','study12098','study12525',...
            'study12554','study13072'};

        % Set the input arguments
        configfile='/ImagePTE1/brainsuite/Woojae/Analysis/bfp/supp_data/config_bfp_preproc.ini';

        t1 = ['/ImagePTE1/brainsuite/Woojae/Analysis/Epilepsy/Raw_Clev/',fd{i},'_MRI.nii.gz'];
        fmri = ['/ImagePTE1/brainsuite/Woojae/Analysis/Epilepsy/Raw_Clev/',fd{i},'_fMRI.nii.gz'];
        studydir='/ImagePTE1/brainsuite/Woojae/Analysis/Epilepsy/Output_Clev';
        subid= fd{i};
        sessionid='rest';
        TR='';

        % Call the bfp function
        bfp(configfile, t1, fmri, studydir, subid, sessionid,TR);

        clc;clear all;close all;

    catch
        keyboard
        save(['/ImagePTE1/brainsuite/Woojae/Analysis/Epilepsy/Output_Clev/',fd{i},'/Error.txt']);

        clc;clear all;close all;
    end
end