clc;clear all;close all;
addpath(genpath('/home/brainsuite/WJ_Epilepsy/matlab_tool/NIfTI_tool'));

%%
t1 = input('T1: ','s');
fmri = input('fMRI: ','s');

%% Rotation

flip_rotate([t1,'.nii.gz'],[t1,'_rotate.nii.gz']);
flip_rotate([fmri,'.nii.gz'],[fmri,'_rotate.nii.gz']);