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

    pix_left = [pix_left; length(find(nii_left >= M*0.8))];
    pix_right = [pix_right; length(find(nii_right >= M*0.8))];

    max_left = [max_left; ML];
    max_right = [max_right; MR];

    lobe = [lobe; lobe_L];
end

%% svm max value & pixel count ratio

maxv = (max_left - max_right);
pix = (pix_left - pix_right);

maxv = (maxv - mean(maxv))./std(maxv);
pix = (pix - mean(pix))./std(pix);

for i = 1:size(pix_left,1)
    hold on
    if class(i) == -1
        scatter(maxv(i), pix(i), 100, 'red.')       
        text(maxv(i),pix(i),cellstr(fd(i)));

    elseif class(i) == 1
        scatter(maxv(i), pix(i), 100,'blue.')
    end        

end

CF = @(x) -2*(x+1);
tmp = -4:4;

plot(-4:4,zeros(1,9),'k:');
plot(zeros(1,9),-4:4,'k:');
plot(tmp,CF(tmp),'k');
% title(['Init (', num2str(i),'/', num2str(size(pix_left,1)),')'])
% legend('Left','Right','Test','Classifier','Location','NorthEastOutside')
xlabel('MVL - MVR (Z-Score)')
ylabel('PCL - PCR (Z-Score)')
axis([-4 4 -4 4])
axis square
set(gca, 'Fontsize', 15)
