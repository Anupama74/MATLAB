clc;
clear all;
close all;
addpath('library');
load V;
global v;
%%
%%
Data_Path = [pwd,'\ED\Train\'];

signals = dir([Data_Path '\' '*.flac']);  %ko=libri=.flac,us=.wav
numSignals = numel(signals)
Total_Train = numSignals
for i= 1:numSignals                     
    i    
    SigName = signals(i).name;
    sig_Name = strcat(Data_Path, '\', SigName);
    [sigData, Fs]= audioread(sig_Name);
    Fs=16000;         
    if size(sigData,2)==2
       sigData=sigData(:,1);
    end    
    sigData = double(sigData);
    
    k =16;
    v = featureExtract(sigData,Fs);
     
    [N, F] = compute_bw_stats(v,'ubm');   
    model = extract_ivector([N; F], 'ubm', 'T');
    model = V' * model;    
    features{i} = vqlbg(model, k);   
    save ('Libri_features.mat','features');
end

disp('Train Database Training is Done!');


