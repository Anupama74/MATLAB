clc;
clear all;
close all;

addpath('src');
addpath('two-cov');

params.Vdim = 120;    
params.Udim = 0;     
params.doMDstep = 1; 
params.PLDA_type = 'two-cov';    % 'std' for standard PLDA
                           % 'simp' for simplified PLDA and
                           % 'two-cov' for two-covariance model
                              
numIter = 15;  
LDA_dim =16; % Dimensionality for LDA. If it is 0 then do not apply LDA.
               % It should be less than the number of individuals in the
               % training set.

fprintf('Vdim: %d, Udim: %d LDA_dim: %d\n\n', params.Vdim, ...
        params.Udim,LDA_dim);

    
% Load data
ivectors_path = sprintf('%s/kk_features.mat',pwd);
[train_data,train_labels,enrol_data,enrol_labels,test_data,test_labels] = ...
    load_data(ivectors_path);

% LDA
if LDA_dim > 0
    [eigvector, eigvalue] = LDA(train_labels, [], train_data);
    train_data = train_data*eigvector(:,1:LDA_dim);
    enrol_data = enrol_data * eigvector(:,1:LDA_dim);
    test_data = test_data*eigvector(:,1:LDA_dim);
end

m = mean(train_data);
train_data = bsxfun(@minus, train_data, m);
enrol_data = bsxfun(@minus, enrol_data, m);
test_data  = bsxfun(@minus, test_data, m);

m     = mean(train_data);
S     = cov(train_data);
[Q,D] = eig(S);
W     = diag(1./sqrt(diag(D)))*Q';

train_data = bsxfun(@minus, train_data, m) * W';
enrol_data = bsxfun(@minus, enrol_data, m) * W';
test_data  = bsxfun(@minus, test_data, m) * W';

train_data = bsxfun(@times, train_data, 1./sqrt(sum(train_data.^2,2))); 
enrol_data  = bsxfun(@times, enrol_data, 1./sqrt(sum(enrol_data.^2,2)));
test_data  = bsxfun(@times, test_data, 1./sqrt(sum(test_data.^2,2)));

% Average enrollment data
enrol_persons = unique(enrol_labels);
n = length(enrol_persons);
enrol_data_avr = zeros(n, size(enrol_data,2));
for i = 1:length(enrol_persons)
   spk_data = enrol_data(enrol_persons(i) == enrol_labels,:);
   enrol_data_avr(i,:) = mean(spk_data);
end
enrol_labels = enrol_persons;  
matrixID = create_incidence_matrix(train_labels);
numSessions = sum(matrixID);
[junk,I] = sort(numSessions);
matrixID = matrixID(:,I);

%% PLDA
if strcmp(params.PLDA_type, 'two-cov')
    [model stats] = two_cov_initialize(train_data', matrixID);
    for i=1:numIter
        model = two_cov_em(matrixID, model, stats);
        scores = two_cov_verification(model, enrol_data_avr, test_data); 
        [EER DCF] = get_EER_matrix(scores, enrol_labels, test_labels, 'I4U');
        fprintf('Iter:%d\t EER:%f\t DCF:%f\n', i,EER, DCF);
    end 
else
    [train_data model stats] = em_initialize(train_data, matrixID, params);
    for i=1:numIter
        model = em_algorithm(matrixID, params, model, stats);
        scores = verification(model, enrol_data_avr, test_data); 
        [EER DCF] = get_EER_matrix(scores, enrol_labels, test_labels, 'I4U');
        fprintf('Iter: %d \tEER: %f\t DCF: %f\n', i,EER, DCF);
    end  
end
%%DET

