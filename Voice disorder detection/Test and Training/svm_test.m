clc;
clear all;
close all;
addpath('library');
load V;
global v;
%%
    Data_Path = [pwd,'\TT\Test\'];  
    files = dir([Data_Path '\' '*.wav']);    
    numFiles = numel(files);
    
for i= 1:numFiles                                  
    
    fileName = files(i).name ;   
    sigFileName = strcat(Data_Path, '\', fileName);    
    [sigData]= audioread(sigFileName);      
    Fs=16000;
    if size(sigData,2)==2
       sigData=sigData(:,1);  
    end   
    sigData = double(sigData);
    
    v = featureExtract(sigData,Fs);    
    [N, F] = compute_bw_stats(v,'ubm');   
    model = extract_ivector([N; F], 'ubm', 'T');
    
    testdata{i,1} = model;
    test_data = cell2mat(testdata');
    test_data = double(test_data');
    [path,name]=fileparts(fileName);     
     labels{i,1}=name;            
     test_labels =str2double(labels)
           
     if(length(name)==4)        
         Total_test(i)=2;     
     else
         Total_test(i)=1;
     end    
    
    save ('dy_features.mat','test_data','Total_test','-append');
end
  disp('Test Training Completed!');
   

   