clc;clear all;close all;
addpath(genpath('/ImagePTE1/brainsuite/Woojae/Analysis/matlab_tool/NIfTI_tool'));
addpath(genpath('/ImagePTE1/brainsuite/Woojae/Analysis/matlab_tool/Public'));

fd = {'pb0438','pb0710','sn0364','sn4055',... 
      'sn4102','sn4214','sn4503','sn4781',...
      'sn5097','sn5579','sn5895','sn6012','sn6095',...
      'sn6372','sn6594','sn7256','sn7602','sn7915',...
      'sn8002','sn8035','sn8252','sn8333',...
      'sn8556','sn8578','ta0418',...
      'ta8088','ta8409','ta8451','ta8600','ta9130'};

class = [-1 -1 -1 -1 -1 1 -1 1 1 1 1 -1 1 -1 1 -1 -1 -1 1 1 -1 -1 1 1 1 -1 -1 1 -1 -1 -1 -1 -1 1]'; % Left: -1, Right: 1
class([3,9,23,25]) = [];

pix_left = []; pix_right = [];
max_left = []; max_right = [];

mask = niftiread('/ImagePTE1/brainsuite/Woojae/Atlas/BCI-DNI_brain3mm.label.nii.gz');

load(fullfile('/ImagePTE1/brainsuite/Woojae/Analysis/matlab_tool/Epilepsy/classified_dat.mat'));
 
lobe = [];

dispstat('','init')

for i = 1:size(fd,2)

    dispstat(sprintf('Processing...(%d/%d)\n',i,size(fd,2)));

    nii = niftiread(['/ImagePTE1/brainsuite/Woojae/Analysis/Epilepsy/fMRI_Analysis/Borg/',fd{i},'_pval(0.01)_borg_fdr_sig_ver2.nii.gz']);

    idx_white = find(mask == 0);
    idx_cere = find(mask == 900);
    idx_stem = find(mask == 3);

    nii(idx_cere) = 0;
    nii(idx_stem) = 0;
    nii(idx_white) = 0;

    %% Lobe detection

    [val, idx] = max(nii(:));
    [x,y,z] = ind2sub(size(nii),idx);
    
    if x < 26
        lobe_L = mask(x,y,z);
        lobe_R = mask(51-x,y,z);

    elseif x > 26
        lobe_R = mask(x,y,z);
        lobe_L = mask(51-x,y,z);
    end
    
    idx_lobe_L = find(mask == lobe_L);
    idx_lobe_R = find(mask == lobe_R);
    
    nii_left = nii(idx_lobe_L);
    nii_right = nii(idx_lobe_R);

    ML = max(nii_left(:));
    MR = max(nii_right(:));
    M = max(nii(:));
    
    tmp_l = []; tmp_r = [];

    for num = 1:10
        tmp_l = [tmp_l length(find(nii_left >= M*0.1*(num-1)))];
        tmp_r = [tmp_r length(find(nii_right >= M*0.1*(num-1)))];
    end
    
    pix_left = [pix_left; tmp_l];
    pix_right = [pix_right; tmp_r];

    max_left = [max_left; ML];
    max_right = [max_right; MR];
end

class = [-1 -1 -1 1 -1 -1 -1 1 1 -1 1 1 1 -1 1 -1 1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1]';

for n = 1:4
    figure(n)
    
    idx = 0+(n-1)*8;

    if n < 4
        rep = 1:2:16;

    else
        rep = 1:2:12;
    end

    for i = rep
        idx = idx + 1;
        
        x = [10:10:90];

        subplot(4,4,i)
        plot(x, pix_left(idx,2:end),'r')
        hold on
        plot(x, pix_right(idx,2:end),'b')

        if class(idx) == -1
            title(['\color{red}Subject (', fd{idx},')'])

        else
            title(['\color{blue}Subject (', fd{idx},')'])
        end
        axis square
        xlabel('Threshold (%)')
        ylabel('Pixel count')

        subplot(4,4,i+1)
        x = categorical({'Left','Right'});

        y = bar(x,[max_left(idx); max_right(idx)],'FaceColor','flat');
        y.CData(1,:) = [1 0 0];
        ylabel('Max value')
        axis square
    end
end

%%
idx_l = find(class == -1);
idx_r = find(class == 1);

x = 10:10:90;

figure()
subplot(2,2,1)
plot(x, mean(pix_left(idx_l,2:end),1),'r');
hold on
plot(x, mean(pix_right(idx_l,2:end),1),'b');
xlabel('Threshold (%)')
ylabel('Pixel count')
title('Left')
legend('Left','Right')
axis square

subplot(2,2,3)
plot(x, mean(pix_left(idx_r,2:end),1),'r');
hold on
plot(x, mean(pix_right(idx_r,2:end),1),'b');
xlabel('Threshold (%)')
ylabel('Pixel count')
title('Right')
legend('Left','Right')
axis square

x = categorical({'left','right'});

subplot(2,2,2)
y = bar(x,[mean(max_left(idx_l)); mean(max_right(idx_l))],'FaceColor','flat');
y.CData(1,:) = [1 0 0];
ylabel('Max value')
axis square

subplot(2,2,4)
y = bar(x,[mean(max_left(idx_r)); mean(max_right(idx_r))],'FaceColor','flat');
y.CData(1,:) = [1 0 0];
ylabel('Max value')
axis square


