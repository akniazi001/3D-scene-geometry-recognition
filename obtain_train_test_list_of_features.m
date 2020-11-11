function [train_set, Test_set, YTRAIN,YTEST]=obtain_train_test_list_of_features(YTrainRGB,deepfeaturesRGB,local_feature,rnd_train,rnd_test)
 %%% concatenate features and divide them into train and test;
%input : train_set->dataset features, Test_set->datasetfeatures, YTRAIN->train
%labels,YTEST->test labels
%output: traing, testing their labels, YTRAIN ,YTEST
local_feature=local_feature(:,2:end);

% for i=1: length(YTrainRGB)
%     for j=1: length(local_feature(1,:))
%       if  local_feature(i,j)==0
%         local_feature(i,j)= sum(local_feature(i,:))./length(local_feature(1,:));
%       end
%     end
% end


allintoOne= [double(string(YTrainRGB)),  normalize(deepfeaturesRGB), normalize(local_feature)];  
 
% divide it into set    normalize(local_feature)
% [m,~]=size(allintoOne);

training = allintoOne(rnd_train,:);
testing = allintoOne(rnd_test,:);
YTRAIN= training(:,1);
train_set=training(:,2:end);
YTEST= testing(:,1);
Test_set=testing(:,2:end);
end
