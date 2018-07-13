clc;
clear all;
close all;
addpath('library');
global v;
%%
Test_path = [pwd,'\Database\libri\Test\'];
signals = dir([Test_path '\' '*.flac']);
numSignals = numel(signals)
%Total_Test = numSignals
 for i= 1:numSignals
     i;
     SigName = signals(i).name;
     sig_Name = strcat(Test_path, '\', SigName);
     [sigData, Fs]= audioread(sig_Name);
              
    if size(sigData,2)==2
       sigData=sigData(:,1);
    end    
    sigData = double(sigData);   
    k=16;
    
    v = featureExtract(sigData,Fs);
    features= vqlbg(v,k);
    [N, F] = compute_bw_stats(features,'ubm');    
    model= extract_ivector([N; F], 'ubm', 'T');
    
    testdata{i} = double(model');
    test_data=cell2mat(testdata');
    [path,name]=fileparts(SigName);
    labels{i}=name;
    test_labels =str2double(labels')
    save ('libri_features.mat','test_data','test_labels','-append')
 end
disp('Test Training Done!');