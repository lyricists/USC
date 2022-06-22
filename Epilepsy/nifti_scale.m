clc;clear all;close all;
addpath(genpath('/home/brainsuite/WJ_Epilepsy/matlab_tool/NIfTI_tool'));

%%
t1 = input('T1: ','s');

nii_t1 = niftiread([t1,'.nii.gz']);

nii_scale = (nii_t1.*500)./max(max(max(nii_t1)));

niftiwrite(nii_scale,[t1,'_scale.nii'])
gzip([t1,'_scale.nii'])
