clc;
clear all;
close all;
addpath('library');
load V;
global v;

%%
    Data_Path = [pwd,'\TT\Normal\'];
  
    files = dir([Data_Path '\' '*.wav']);
    
    numFiles = numel(files);
    
for i= 1:numFiles       
      
    fileName = files(i).name;    
    sigFileName = strcat(Data_Path, '\', fileName);    
    [sigData, Fs]= audioread(sigFileName);    
          
    if size(sigData,2)==2
       sigData=sigData(:,1);
    end
    
    sigData = double(sigData); 
    
    % MFCC and I-vectors
    v = featureExtract(sigData,Fs);    
    [N, F] = compute_bw_stats(v,'ubm');   
    model = extract_ivector([N; F], 'ubm', 'T');    
     
   
    train_data{i,1} = model;   
    train_data{i,2}=1;
    [path,name]=fileparts(fileName);     
    labels{i,1}=name;   
    train_labels =str2double(labels)
end
disp('Normal Speakers Training Process Done!');
%%
k_count=i+1;
    Data_Path = [pwd,'\TT\Abnormal\'];  
    files = dir([Data_Path '\' '*.wav']);    
    numFiles = numel(files);

for i= 1:numFiles  
    
    fileName = files(i).name;    
    sigFileName = strcat(Data_Path, '\', fileName);   
    [sigData]= audioread(sigFileName);
          
    if size(sigData,2)==2
       sigData=sigData(:,1);
    end
    sigData = double(sigData);
    Fs=16000;
    
     %MFCC and I-vectors
    v = featureExtract(sigData,Fs);
    [N, F] = compute_bw_stats(v,'ubm');    
    model = extract_ivector([N; F], 'ubm', 'T');
       
    train_data{k_count,1} = model; 
    train_data{k_count,2}=2;
    [path,name]=fileparts(fileName);     
    labels{k_count,1}=name;   
    train_labels =str2double(labels)
    
    k_count=k_count+1;
    save ('dy_features.mat','train_data','train_labels');
end

disp('Abnormal Speakers Training Process Done!')
%

