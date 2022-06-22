clc;clear all;close all;
addpath(genpath('/ImagePTE1/brainsuite/Woojae/Analysis/matlab_tool/NIfTI_tool'));
addpath(genpath('/ImagePTE1/brainsuite/Woojae/Analysis/matlab_tool/Public'));

fd = {'pb0438','pb0710','sn0141','sn0364','sn4055',...
            'sn4102','sn4214','sn4503','sn4553','sn4781',...
            'sn5097','sn5579','sn5895','sn6012','sn6095',...
            'sn6372','sn6594','sn7256','sn7602','sn7915',...
            'sn8002','sn8035','sn8133','sn8252','sn8333',...
            'sn8440','sn8556','sn8578','ta0418',...
            'ta8088','ta8409','ta8451','ta8600','ta9130'};
% 
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
%     nii = niftiread(['/ImagePTE1/brainsuite/Woojae/Analysis/Epilepsy/fMRI_Analysis/Borg/',fd{i},'_pval(0.01)_borg_fdr_sig.nii.gz']);

    idx_white = find(mask == 0);
    idx_cere = find(mask == 900);
    idx_stem = find(mask == 3);

    nii(idx_cere) = 0;
    nii(idx_stem) = 0;
    nii(idx_white) = 0;

    %% whole brain
%     nii_left = nii(1:25,:,:);
%     nii_right = nii(27:51,:,:);
% 
%     ML = max(nii_left(:));
%     MR = max(nii_right(:));
%     M = max(nii(:));
% 
%     pix_left = [pix_left; length(find(nii_left >= M*0.8))];
%     pix_right = [pix_right; length(find(nii_right >= M*0.8))];
% 
%     max_left = [max_left; ML];
%     max_right = [max_right; MR];

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

dispstat('','init')

maxv = (max_left - max_right);
pix = (pix_left - pix_right);

maxv = (maxv - mean(maxv))./std(maxv);
pix = (pix - mean(pix))./std(pix);

d = 0.02;
[x1Grid,x2Grid] = meshgrid(-4:d:4, -4:d:4);
xGrid = [x1Grid(:), x2Grid(:)];

dc_mvp = []; score_mvp = [];

for i = 1:size(pix_left,1)
    dispstat(sprintf('Processing svm pixel count...(%d/%d)\n',i,size(pix_left,1)));
    
    tmp_l = maxv; tmp_r = pix; tmp_c = class;

    tmp_l(i) = []; tmp_r(i) = []; tmp_c(i) = [];

    svmdl = fitcsvm([tmp_l tmp_r], tmp_c, 'KernelFunction', 'polynomial'...
        ,'PolynomialOrder', 2, 'Standardize', true, 'KernelScale', 1);

%     svmdl = fitcsvm([tmp_l tmp_r], tmp_c, 'KernelFunction', 'rbf',...
%         'Standardize', true, 'KernelScale', 'auto');

    [~,tmp] = predict(svmdl, xGrid);
    score_mvp = [score_mvp squeeze(tmp(:,2))];

    [tmp,~] = predict(svmdl, [maxv(i) pix(i)]);
    dc_mvp = [dc_mvp; tmp];
end

concord_mvp = (length(find((class-dc_mvp) == 0))/30)*100;

for i = 1:size(pix_left,1)
    hold off

    tmp_l = maxv; tmp_r = pix; tmp_c = class;

    tmp_l(i) = []; tmp_r(i) = []; tmp_c(i) = [];

    gscatter(tmp_l, tmp_r, tmp_c, 'rb','.')
    hold on
    if class(i) == -1
        scatter(maxv(i), pix(i), 100, 'red*')
        text(maxv(i),pix(i),cellstr(fd(i)));

    elseif class(i) == 1
        scatter(maxv(i), pix(i), 100,'blue*')
    end    
    
    contour(x1Grid,x2Grid,reshape(score_mvp(:,i),size(x1Grid)),[0 0],'k');

    plot(-4:4,zeros(1,9),'k:');
    plot(zeros(1,9),-4:4,'k:');
    title(['Init (', num2str(i),'/', num2str(size(pix_left,1)),')'])
    legend('Left','Right','Test','Classifier','Location','NorthEastOutside')
    xlabel('MVL - MVR (Z-Score)')
    ylabel('PCL - PCR (Z-Score)')
    axis([-4 4 -4 4])
    axis square
    set(gca, 'Fontsize', 15)
    pause(1)  
end

%% svm max value & pixel ratio

dispstat('','init')

d = 0.01;
[x1Grid,x2Grid,x3Grid] = meshgrid(min(max_left):d:max(max_left), min(max_right):d:max(max_right),...
    min(pix):d:max(pix));
xGrid = [x1Grid(:), x2Grid(:), x3Grid(:)];

dc_mvpr = []; score_mvpr = [];

for i = 1:size(pix_left,1)
    dispstat(sprintf('Processing svm pixel count...(%d/%d)\n',i,size(pix_left,1)));
    
    tmp_l = max_left; tmp_r = max_right; tmp_p = pix; tmp_c = class;

    tmp_l(i) = []; tmp_r(i) = []; tmp_p(i) = []; tmp_c(i) = [];

%     svmdl = fitcsvm([tmp_l tmp_r tmp_p], tmp_c, 'KernelFunction', 'polynomial'...
%         ,'PolynomialOrder', 3, 'Standardize', true, 'KernelScale', 'auto');

    svmdl = fitcsvm([tmp_l tmp_r tmp_p], tmp_c, 'KernelFunction', 'rbf',...
        'Standardize', true, 'KernelScale', 'auto');

    [~,tmp] = predict(svmdl, xGrid);
    score_mvpr = [score_mvpr squeeze(tmp(:,2))];

    [tmp,~] = predict(svmdl, [max_left(i) max_right(i) pix(i)]);
    dc_mvpr = [dc_mvpr; tmp];
end

concord_mvpr = (length(find((class-dc_mvpr) == 0))/34)*100;

for i = 1:size(pix_left,1)
    hold off

    tmp_l = max_left; tmp_r = max_right; tmp_p = pix; tmp_c = class;

    tmp_l(i) = []; tmp_r(i) = []; tmp_p(i) = []; tmp_c(i) = [];

    idx = find(tmp_c == -1);
    scatter3(tmp_l(idx), tmp_r(idx), tmp_p(idx), 'filled', 'red')
    hold on
    
    idx = find(tmp_c == 1);
    scatter3(tmp_l(idx), tmp_r(idx), tmp_p(idx), 'filled', 'blue')

    if class(i) == -1
        scatter3(max_left(i), max_right(i), pix(i), 'red*')

    elseif class(i) == 1
        scatter3(max_left(i), max_right(i), pix(i), 'blue*')
    end

    [faces,verts,~] = isosurface(x1Grid, x2Grid, x3Grid, reshape(score_mvpr(:,i),size(x1Grid)), 0, x1Grid);
    patch('Vertices', verts, 'Faces', faces, 'FaceColor','g','edgecolor',...
        'none', 'FaceAlpha', 0.2);
    grid on
    box on
    view(3)
    title(['Init (', num2str(i),'/', num2str(size(pix_left,1)),')'])
    legend('Left','Right','Test','Classifier')
    xlabel('Normalized max value left')
    ylabel('Normalized max value Right')
    zlabel('Normalized pixel count (Left - Right)')
    axis square
    set(gca, 'Fontsize', 15)
    pause(1)  
end

%% 4-D

dispstat('','init')

max_left = (max_left-mean(max_left))./std(max_left);
max_right = (max_right - mean(max_right))./std(max_right);

pix_left = (pix_left - mean(pix_left))./std(pix_left);
pix_right = (pix_right - mean(pix_right))./std(pix_right);

% d = 0.01;
% [x1Grid,x2Grid,x3Grid] = meshgrid(min(max_left):d:max(max_left), min(max_right):d:max(max_right),...
%     min(pix_left):d:max(pix_left),min(pix_right):d:max(pix_right));
% xGrid = [x1Grid(:), x2Grid(:), x3Grid(:)];

dc_mvpr = []; score_mvpr = [];

for i = 1:size(pix_left,1)
    dispstat(sprintf('Processing svm pixel count...(%d/%d)\n',i,size(pix_left,1)));
    
    tmp_l = max_left; tmp_r = max_right; tmp_pl = pix_left; tmp_pr = pix_right; tmp_c = class;

    tmp_l(i) = []; tmp_r(i) = []; tmp_pl(i) = []; tmp_pr(i) = []; tmp_c(i) = [];

%     svmdl = fitcsvm([tmp_l tmp_r tmp_p], tmp_c, 'KernelFunction', 'polynomial'...
%         ,'PolynomialOrder', 3, 'Standardize', true, 'KernelScale', 'auto');

    svmdl = fitcsvm([tmp_l tmp_r tmp_pl tmp_pr], tmp_c, 'KernelFunction', 'rbf',...
        'Standardize', true, 'KernelScale', 'auto');

%     [~,tmp] = predict(svmdl, xGrid);
%     score_mvpr = [score_mvpr squeeze(tmp(:,2))];

    [tmp,~] = predict(svmdl, [max_left(i) max_right(i) pix_left(i) pix_right(i)]);
    dc_mvpr = [dc_mvpr; tmp];
end

concord_mvpr = (length(find((class-dc_mvpr) == 0))/30)*100;
