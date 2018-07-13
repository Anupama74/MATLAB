clc;
clear all;
close all;
%%
Signals_Per_person = 5;         
Number_of_person=10;
load Libri_features.mat;
load V;
threshold=[60 65 70 75 79 80 81 82 83 85 87 89 91 92 93];
FAR=[];
m=1;
global v;
%%
Data_NonMatchPath = [pwd,'\ED\FAR\'];
D = dir(Data_NonMatchPath); 
numFolders = numel(D)

for pp = 3:numFolders
    
    folderName=D(pp).name    
    sigFilepth = strcat(Data_NonMatchPath, '\', folderName);     
    files = dir([sigFilepth '\' '*.flac']);   %k=.flac,u=.wav  
    numFiles = numel(files);
    
    for ii= 1:Signals_Per_person                               
        fileName = files(ii).name;
        sigFileName = strcat(sigFilepth, '\', fileName);

        [sigData, Fs]= audioread(sigFileName);
        
        if size(sigData,2)==2
           sigData=sigData(:,1);
        end
        sigData = double(sigData);
        
         k =16;
        v = featureExtract(sigData,Fs);        
        [N, F] = compute_bw_stats(v,'ubm');
        model = extract_ivector([N; F], 'ubm', 'T');
        model = V' * model;        
        res = vqlbg(model, k);

         k1      = 1;
           for jj=1:size(features,1)
               
                distmin = Inf; 
                
               for kk=1:size(features,2)
                   
                d  = disteu(res, features{jj,kk},0);
                
                dist = sum(min(d,[],2)) / size(d,1);
                
                if dist < distmin
                    
                    distmin = dist;
                    
                    dist_vals(k1) = distmin;                    
                end                
               end
               
               k1=k1+1;
           end
                      
     count_value(m)=min(dist_vals);     
     m=m+1;             
    end      
end      
count_value

kk=1;       
for k=threshold
    match_cnt = 0;
    mismatch_cnt = 0;    
    m=1;
    for pp = 3:numFolders
        for ii= 1:Signals_Per_person   
            if count_value(m) <=k
                disp('Matches Found');
                match_cnt = match_cnt+1;
            else
                disp('Sorry! NO Matches Found');
                mismatch_cnt = mismatch_cnt+1;
            end            
            m=m+1;       
        end
    end       
    match_cnt
    FAR(kk) = (match_cnt/ (Number_of_person*Signals_Per_person))*100;                                    
    kk=kk+1;    
end

save ('Libri_features.mat','FAR','-append')
