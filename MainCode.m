clc
clear all
close all

fs1 = 16000;
wdtw2 = 50;   %DTW width for outer DTW (dtw2)
wdtw1 = 30;   % DTW width for inner DTW (dtw)
% alpha = 1; lamda = 0.5;
winlen = 200;  % window length 
overlap = 100;%winlen/2; % overlapping between two windows 

Infolder_female = dir(f_female); % loading path of the folder (f_female) that have all your female sounds
MyListOfFiles_F = {Infolder_female(~[Infolder_female.isdir]).name};
[n_f,m_f] = size(MyListOfFiles_F);

Infolder_male = dir(f_male); % loading path of the folder (f_male) that have all your male sounds

MyListOfFiles_M = {Infolder_male(~[Infolder_male.isdir]).name};
[n_m,m_m] = size(MyListOfFiles_M);

new_i = 440;

for i = 1 : Num    % Num = how many sentances you want to find features and warping paths
%% Now Read Source and Target sounds %%
    filename_f = MyListOfFiles_F{i};
    f1_f = fullfile(Infolder_female(i).folder,filename_f);
    d11 = [];sr1 = 0;
    [d11,sr1] = audioread(f1_f);
   
    filename_m = MyListOfFiles_M{i};
    f1_m = fullfile(Infolder_male(i).folder,filename_m);
    d22 = [];sr2 = 0;
    [d22,sr2] = audioread(f1_m);
d1=[];d2=[];
d1 = d11(:,1);
d2 = d22(:,1);

d1(d1 ==0)=[];
d2(d2 ==0)=[];
% Resampling
fname_data_target = [];
fname_data_target = d1;
fname_data_target = Resample_data(fname_data_target,fs1,sr1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clipping step %
fname_data_target1 = [];
fname_data_target1 = clipped_right_inf(fname_data_target,winlen,overlap);
% zero mean Step %
d11=[];
d11 = diff(Normalize_data(fname_data_target1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% d1 = diff(fname_data_target11);
fname_data_target = [];
fname_data_target = d2;
fname_data_target = Resample_data(fname_data_target,fs1,sr2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clipping step %
fname_data_target1 = [];
fname_data_target1 = clipped_right_inf(fname_data_target,winlen,overlap);
% zero mean Step %
d22=[];
d22 = diff(Normalize_data(fname_data_target1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d11(d11 ==0)=[];
d22(d22 ==0)=[];
d_11_16k = [];d_22_16k=[];
d_11_16k = d11;
d_22_16k = d22;

%% Spectrogram iniformation and STFT

winlen1 = 512; 
overlap1 = 400;%winlen/2;
nfft = 512;

anal_win = hamming(winlen1, 'periodic');

hop =winlen1 - overlap1;
D1_16k=[];D2_16k=[];D11_16k=[];D22_16k=[];
% Female
D11_16k = stft(d_11_16k, anal_win, hop, nfft);
% Male
D22_16k = stf(d_22_16k, anal_win, hop, nfft);

%% Spectral Normalization
nD2=0;mD2=0;nD1=0;mD1=0;
[nD2,mD2]= size(D22_16k);
[nD1,mD1]= size(D11_16k);
D22_16k_N = [];D11_16k_N=[];i1=0;i2=0;
for  i1 = 1 : mD2
    waled = 0;
    waled = sqrt(sum((abs(D22_16k(:,i1))).^2));
    D22_16k_N(:,i1) = abs(D22_16k(:,i1))/waled;
    D22_16k_phase(:,i1) = abs(D22_16k(:,i1));
end    
for  i2 = 1 : mD1
    waled = 0;
    waled = sqrt(sum((abs(D11_16k(:,i2))).^2));
    D11_16k_N(:,i2) = abs(D11_16k(:,i2))/waled;
    D11_16k_phase(:,i1) = abs(D11_16k(:,i1));
end
%% DTW
% find DTW between male and female signals 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a_spec_first=[];b_spec_first=[];aa1_16k =[];bb1_16k =[];
[a_spec_first,b_spec_first,aa1_16k,bb1_16k]=dw_Normalized(D22_16k_N,D11_16k_N,wdtw2);     

p=[];q=[];
p = a_spec_first; q = b_spec_first;

% DTW
D22x_16k_N_direct_1 = []; D22x_16k_N_direct_1(:,p(:)) = D22_16k(:,q(:));

% DFW %
for ik = 1: length(D2i1_16k)
a1a_16k =[]; b1b_16k=[];
a1a_16k = aa1_16k{D2i2_16k(ik),D2i1_16k(ik)};
b1b_16k = bb1_16k{D2i2_16k(ik),D2i1_16k(ik)};
D2iL1_16k = zeros(1, size(D11_16k(:,ik),1));
for iik = 1:length(D2iL1_16k)
    D2iL1_16k(iik) = b1b_16k(min(find(a1a_16k >= iik)));
end
D2iL1_index_warping_cell_16k{i,ik} = D2iL1_16k;
a1_total_16k_N{1,ik} = a1a_16k;
b1_total_16k_N{1,ik} = b1b_16k;
D22X_16k_N(:,ik) = D22x_16k_N(D2iL1_16k(:),ik);
end

% Save thew temproal Spectral aligned featuers 
D2x_TimeAlign_cell_16k{1,i} = D22x_16k_N_direct_1;
D2x_TimeAlign_cell_abs_16k{1,i} = abs(D22x_16k_N_direct_1);

% Find the warping paths for the frequency warping
p=[];q=[];
p = a_spec_first; q = b_spec_first;
for ik = 1: length(p)
a1a_16k_test =[]; b1b_16k_test=[];
a1a_16k_test = aa1_16k{p(ik),q(ik)};
b1b_16k_test = bb1_16k{p(ik),q(ik)};
a1_total_16k_N_waled{i,p(ik)}= a1a_16k_test;
b1_total_16k_N_waled{i,p(ik)}= b1b_16k_test;
end
% Doing spectral warping 
[size_row,size_colu] = size(D22x_16k_N_direct_1);
for iji = 1 : size_colu
    a1a_16k_test = [];a1a_16k_test = a1_total_16k_N_waled{i,iji};
    b1b_16k_test = [];b1b_16k_test = b1_total_16k_N_waled{i,iji};
    D22X_16k_N_b1b_1(a1a_16k_test(:),iji) = D22x_16k_N_direct_1(b1b_16k_test(:),iji);
end

% % % % % % % Create Sound and Inverse STFT
synth_win = anal_win;
d22xx_original=[];x_istft1=[];
[x_istft1] = istft(D22X_16k_N_b1b_1, anal_win, synth_win, hop, nfft, fs1);
d22xx_original = resize(x_istft1', length(d_11_16k),1);
y_16k = bandpass(d22xx_original,[500 7500],fs1);


% save transformed signal
save(filename0,'y_16k');


end
