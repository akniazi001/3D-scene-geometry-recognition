%%%%%%%%%%%%%%%%%%%final accuracy %%%%%%%%%%%%%%%5


%%%%%%%%%%%%%%%%%%%%%main program is develop to calculate accuracy
%%%%%%%%%%%%%%%%%%%%%confusion materix and re-call precision R value 
% groundtruth = cell2mat(struct2cell(load('./classes/mywork_propose/label.mat')));
% prediction = cell2mat(struct2cell(load('./classes/mywork_propose/predicted_majority')));
% 

% groundtruth='';       % actual  
% prediction=''          %% %class which we predicited

% groundtruth=a;
% prediction=b;
[confmat, prec, recall, fscore] = prec_recall(color_Line(:,1),uint8(validationPredictions))