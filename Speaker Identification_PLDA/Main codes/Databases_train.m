clc;
clear all;
close all;
addpath('library');
global v;
%%
Train_path = [pwd,'\Database\libri\Train\'];
signals = dir([Train_path '\' '*.flac']);  %k=.flac
numSignals = numel(signals)
%Total_Train = numSignals

 for i= 1:numSignals
     i;
     SigName = signals(i).name;
     sig_Name = strcat(Train_path, '\', SigName);
     [sigData, Fs]= audioread(sig_Name);
              
    if size(sigData,2)==2
       sigData=sigData(:,1);
     end   
    sigData = double(sigData);   
    k =16;
    v = featureExtract(sigData,Fs);
    features= vqlbg(v, k);
    [N, F] = compute_bw_stats(features,'ubm');    
    model= extract_ivector([N; F], 'ubm', 'T');    
    traindata{i} = double(model');
    train_data=cell2mat(traindata');
    [path,name]=fileparts(SigName);     
    labels{i}=name;
    train_labels =str2double(labels')
    save ('libri_features.mat','train_data','train_labels')
 end
disp('Train Database Training Done!');

