
clc;clear all;close all;
addpath(genpath('/home/brainsuite/WJ_Epilepsy/matlab_tool/NIfTI_tool'));

fd = {'pb0438','pb0710','sn0141','sn0364','sn4055',...
            'sn4102','sn4214','sn4503','sn4553','sn4781',...
            'sn5097','sn5579','sn5895','sn6012','sn6095',...
            'sn6372','sn6594','sn7256','sn7602','sn7915',...
            'sn8002','sn8035','sn8133','sn8252','sn8333',...
            'sn8440','sn8556','sn8578','ta0418',...
            'ta8088','ta8409','ta8451','ta8600','ta9130'};

sub = [0 0 0 0 0 1 0 1 1 1 1 0 1 0 1 0 0 0 1 1 0 0 1 1 1 0 0 1 0 0 0 0 0 1]'; % Left: 0, Right: 1

num_left = []; num_right = [];
max_left = []; max_right = [];

mask = niftiread('/home/brainsuite/for_woojae_lobes/BCI-DNI_brain3mm.label.nii.gz');

for i = 1:size(fd,2)

    fprintf('Processing...(%d/%d)\n',i,size(fd,2));

    nii = niftiread(['/home/brainsuite/WJ_Epilepsy/Epilepsy/fMRI_Analysis/Borg/',fd{i},'_pval(0.05)_borg_fdr_sig.nii.gz']);
     
    idx_cere = find(mask == 900);
    idx_stem = find(mask == 3);
    idx_white = find(mask == 0);

    nii(idx_cere) = 0;
    nii(idx_stem) = 0;
    nii(idx_white) = 0;

    %% whole brain
    nii_left = nii(1:25,:,:);
    nii_right = nii(27:51,:,:);

    ML = max(nii_left(:));
    MR = max(nii_right(:));
    M = max(nii(:));

    num_left = [num_left; length(find(nii_left >= M*0.9))];
    num_right = [num_right; length(find(nii_right >= M*0.9))];

    max_left = [max_left; ML];
    max_right = [max_right; MR];
end

SL_num = []; SL_max = [];

for i = 1:length(fd)

    if num_left(i) > num_right(i)
        SL_num = [SL_num; 0];

    else
        SL_num = [SL_num; 1];
    end

    if max_left(i) > max_right(i)
        SL_max = [SL_max; 0];

    else
        SL_max = [SL_max; 1];
    end
end

length(find(sub-SL_num == 0))
length(find(sub - SL_max == 0))