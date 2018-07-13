clc;
clear all;
close all;
load('dy_features.mat');

%%    Trained Data Loading
features = train_data(:,2);
train_data = train_data(:,1);
train_data = cell2mat(train_data');
train_data = double(train_data');
% SVM Classifier 
svm = fitcecoc(train_data,train_labels)
label=predict(svm,test_data)

disp('SVM Classification Done!');


%% Matching Classified Results

features = cell2mat(features);
u=length(features);    %train labels length
Normal=0;
Abnormal=0;
for i=1:u
    if (features(i)==1)   
        Normal = Normal+1;       
    else     
        Abnormal = Abnormal+1;        
    end
end
x=train_labels(1:Normal);
y=train_labels(Normal+1:u);
disp('Normal trained signals:'); Normal
disp('Abnormal trained signals:'); Abnormal

v=length(label);  %test labels length
disp('No. of Test signals:'); v
for i=1:Normal
    for j=1:v
       if (label(j)==x(i))
         %disp('signal is Normal');
         result(j)=1;
       end      
    end   
end
for i=1:Abnormal
    for j=1:v
       if (label(j)==y(i))
         %disp('signal is Abnormal');
         result(j)=2 ;
       end      
    end   
end

disp('Calculating Performance Measures....')
disp('...')
%%
%% 
[tp,tn,fp,fn,Sen,Spec,Accu,Preci,Recall,F_score] = Result...
                                        (Total_test,result);

Res = [tp,tn,fp,fn,Sen,Spec,Accu,Preci,Recall,F_score];

for i = 1:length(Res)
    if isnan(Res(i))
        Res(i) = 0;
    end
    if isinf(Res(i))
        Res(i) = 0;
    end
end

tp = Res(1);
tn = Res(2);
fp = Res(3);
fn = Res(4);
Sen = Res(5);
Spec = Res(6);
Accu = Res(7);
Preci = Res(8);
Recall = Res(9);
F_score = Res(10);

%% Display the results

disp('%=============== Performance Measure =================%')
disp(' ')
disp(['Accuracy = ' num2str(Accu*100)])
disp(' ')

%%
disp(' ')
disp(['Specificity = ' num2str(Spec*100)])
disp(' ')

%%
disp(' ')
disp(['Sensitivity = ' num2str(Sen*100)])
disp(' ')

%%
disp(' ')
disp(['Precision = ' num2str(Preci*100)])
disp(' ')

%%
disp(' ')
disp(['Recall = ' num2str(Recall*100)])
disp(' ')

%%
disp(' ')
disp(['True Positive = ' num2str(tp)])
disp(' ')

disp(' ')
disp(['True Negative = ' num2str(tn)])
disp(' ')

disp(' ')
disp(['False Positive = ' num2str(fp)])
disp(' ')

disp(' ')
disp(['False Negative = ' num2str(fn)])
disp(' ')

disp(' ')
disp(['F Measure = ' num2str(F_score * 100)])
disp(' ')



