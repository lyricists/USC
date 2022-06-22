
%%
clc;clear all;close all;
addpath(genpath('/home/brainsuite/WJ_Epilepsy/matlab_tool/NIfTI_tool'));

t1 = input('T1: ','s');
fmri = input('fMRI: ','s');

nii_t1 = load_nii([t1,'.hdr']);
save_nii(nii_t1,[t1,'.nii']);

nii_fmri = load_nii([fmri,'.hdr']);
save_nii(nii_fmri,[fmri,'.nii']);

gzip([t1,'.nii']);
gzip([fmri,'.nii']);