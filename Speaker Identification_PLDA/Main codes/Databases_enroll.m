clc;
clear all;
close all;
addpath('library');
global v;
%%
Enrol_path = [pwd,'\Database\libri\Enrol\'];
signals = dir([Enrol_path '\' '*.flac']);
numSignals = numel(signals)  
%Total_enrol = numSignals
 for i= 1:numSignals
     i;
     SigName = signals(i).name;
     sig_Name = strcat(Enrol_path, '\', SigName);
     [sigData, Fs]= audioread(sig_Name);
              
    if size(sigData,2)==2
       sigData=sigData(:,1);
    end    
     sigData = double(sigData);   
     k =16;

     v = featureExtract(sigData,Fs);
     features= vqlbg(v,k);
     [N, F] = compute_bw_stats(features,'ubm');    
     model= extract_ivector([N; F], 'ubm', 'T');
 
     enroldata{i} = double(model');
     enrol_data=cell2mat(enroldata');
     [path,name]=fileparts(SigName);
     labels{i}=name;
     enrol_labels =str2double(labels')
     save ('libri_features.mat','enrol_data','enrol_labels','-append')
 end
disp('Enrol Database Training Done!');