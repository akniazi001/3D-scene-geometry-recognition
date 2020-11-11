% clear ;
% close all;
% clc

%% =============== Part 1: Loading Data ================
%  addpath('D:\MS and PhD life\PhD\Image-Classifier-by-alexnet/');
 
outputFolder = fullfile('D:\MS and PhD life\PhD\research paper of Dataset\12 Scene datasets\RGB_New_dataset 12000');
%outputFolder= fullfile('D:\MS and PhD life\PhD\CNN_imageClassification\Image Classification by_RESNET50/LBP5');
%   outputFolder= fullfile('Z:\Remote Scene\UCMerced_LandUse\UCMerced_LandUse\Images');
% %  outputFolder= fullfile('Z:\phd\Image-Classifier-by-alexnet\Yash0330-Image-Classifier-by-alexnet-3291263/photos');
% %  outputFolder= fullfile('D:\MS and PhD life\PhD\Image-Classifier-by-alexnet\Yash0330-Image-Classifier-by-alexnet-3291263/photos');
image_data = imageDatastore(outputFolder,'IncludeSubfolders',true,'LabelSource','foldernames');
% Resize the images to the input size of the net
% im.ReadFcn = @(loc)imresize(imread(loc),[227,227]);
%[imdsTrain,imdsValidation] = splitEachLabel(im,0.8,'randomized');
%%load RGB dataset

%% =============== Part 2: feature extraction ================
[YTrain,Xng,X0, X1,X2,X3] = deepfeatures_deepnet(image_data); %% extract deep features at multi-layers CNN: RESNET,GoogLeNET
%% uncomments layers for googlenet model inside deepfeatures_deepnet function, extract three (pooling, FC layers) instead of 5 different layers.

addpath('deepfeatures_4x4');
[grid_basedFeature,imageid_scene]=Mainfile_features_gridpatch(image_data); %% extract handcrafted features
% for i=1:length(Xng)
   
% end

p=0.80; %%%% training and testing ratio
No_images=length(YTrain); %% randomly selection for training + testing
idx = randperm(No_images);
rnd_train=idx(1:round(p*No_images));
rnd_test= idx(round(p*No_images)+1: end);
T6=sortrows(localfeatureset,1) ;; %% grid features

%%  =====================using RESNET Model ===================================
%% =============== Part 3: Training + testing for googlenet ================
%%%% training and testing using SVM+ ELM,
%function: obtain_train_test_list_of_features: normalized(): takes two different features, random index of training+testing,
% divided into train+test features while keeping image index information into YTRAIN_1, YTEST_1.
% function:
%% call features training for 1st layers
[train_set_1, Test_set_1, YTRAIN_1,YTEST_1]=obtain_train_test_list_of_features(YTrain,Xng,T6,rnd_train,rnd_test); %% combine at each layer's outcome
[svmng,elmng ]=classification_processing_usingSVM_ELM(train_set_1,Test_set_1,YTRAIN_1,YTEST_1);
%% call features training for 2nd layers
[train_set_1, Test_set_1, YTRAIN_1,YTEST_1]=obtain_train_test_list_of_features(YTrain,X0,T6,rnd_train,rnd_test); %% combine at each layer's outcome
[svm0,elm0 ]=classification_processing_usingSVM_ELM(train_set_1,Test_set_1,YTRAIN_1,YTEST_1);
%% call features training for 3rd layers
[train_set_1, Test_set_1, YTRAIN_1,YTEST_1]=obtain_train_test_list_of_features(YTrain,X1,T6,rnd_train,rnd_test); %% combine at each layer's outcome
[svm1,elm1 ]=classification_processing_usingSVM_ELM(train_set_1,Test_set_1,YTRAIN_1,YTEST_1);

%% call features training for 4rth layers
[train_set_2, Test_set_2, YTRAIN_2,YTEST_2]=obtain_train_test_list_of_features(YTrain,X2,T6,rnd_train,rnd_test); %% combine at each layer's outcome
[svm2,elm2 ]=classification_processing_usingSVM_ELM(train_set_2,Test_set_2,YTRAIN_2,YTEST_2);
%% call features training for 5th layers
[train_set_3, Test_set_3, YTRAIN_3,YTEST_3]=obtain_train_test_list_of_features(YTrain,X3,T6,rnd_train,rnd_test);%% combine at each layer's outcome
[svm3,elm3 ]=classification_processing_usingSVM_ELM(train_set_3,Test_set_3,YTRAIN_3,YTEST_3);

%% =============== Part 4: score-level fusion using Model: (a)	Model-HSF (score-level fusion)===============
%% score level fusion  for svm and elm (elm only work for  majority voting )/// model (Model-HSF)
[Ssvm]=calculate_scorefusion_svmresnet(svmng,svm0, svm1,svm2,svm3,YTEST_3); %% linear svm score , fusion using sum,product rule, and majority voting
%% Ssvm: return accuracy of majorty voting,sum, product, max rules. 
[Selm]=calculate_scorefusion_ELM_resnet(elmng, elm0,elm1 ,elm2 ,elm3,YTEST_3); %% majority voting, YTEST_3 has same testing images as like YTEST_1,.2...
%% Selm return accuracy of majority voting
% Ssvm is struct contains acc, pre, recal,fscore, confusion matrix for sum
% rule, product rule, max rule, and majorty voting. while Selm is only
% contain acc, prec, recall, fscore and conf.matrix for majority voting.
%% =============== Part 5: score-level fusion using Model: (b) Model HFF  (score-level fusion)===============
%% feature-level fusion and elements application // Model (B) combine all features: deep+handcrafted,
deepfeature_cmb=[Xng, X0,X1 X2 X3];
[train_set_cmb, Test_set_cmb, YTRAIN_cmb,YTEST_cmb]=obtain_train_test_list_of_features(YTrain,deepfeature_cmb,T6,rnd_train,rnd_test);
[svmCMB,elmCMB ]=classification_processing_usingSVM_ELM(train_set_cmb,Test_set_cmb,YTRAIN_cmb,YTEST_cmb); %% return performance: acc, pre, recall, and f-score, Conf. matrix.
% svmCMB represent result of combine the features first and then train a classifier
%% svmCMB: combined features and predict using svm: accuray, precision, recall, fscore
%% elmCMB: combined all features and predict using elm: accuracy, precision, recall, fscore
%% saving results
if ~exist(resnetm, 'dir')
else
    mkdir('resnetm');
end
save('./resnetm/Ssvm','Ssvm');
save('./resnetm/Selm','Selm');
save('./resnetm/svmCMB','svmCMB');
save('./resnetm/elmCMB','elmCMB');


%===========================using GoogLeNEt model==================================================================================
%% =============== Part 3: Training + testing ================
%%%% training and testing using SVM+ ELM,
%function: obtain_train_test_list_of_features: normalized(): takes two different features, random index of training+testing,
% divided into train+test features while keeping image index information into YTRAIN_1, YTEST_1.
% function:
[train_set_1, Test_set_1, YTRAIN_1,YTEST_1]=obtain_train_test_list_of_features(YTrain_label,X1,T6,rnd_train,rnd_test); %% combine at each layer's outcome
[svm1,elm1 ]=classification_processing_usingSVM_ELM(train_set_1,Test_set_1,YTRAIN_1,YTEST_1);

%% call features training for 2nd layers
[train_set_2, Test_set_2, YTRAIN_2,YTEST_2]=obtain_train_test_list_of_features(YTrain_label,X2,T6,rnd_train,rnd_test); %% combine at each layer's outcome
[svm2,elm2 ]=classification_processing_usingSVM_ELM(train_set_2,Test_set_2,YTRAIN_2,YTEST_2);
%% call features training for 3rd layers
[train_set_3, Test_set_3, YTRAIN_3,YTEST_3]=obtain_train_test_list_of_features(YTrain_label,X3,T6,rnd_train,rnd_test);%% combine at each layer's outcome
[svm3,elm3 ]=classification_processing_usingSVM_ELM(train_set_3,Test_set_3,YTRAIN_3,YTEST_3);

%% =============== Part 4: score-level fusion using Model: (a)	Model-HSF (score-level fusion)===============
%% score level fusion  for svm and elm (elm only work for  majority voting )/// model (Model-HSF)
[Ssvm]=calculate_scorefusion_svm(svm1 ,svm2 ,svm3,YTEST_3); %% linear svm score , fusion using sum,product rule, and majority voting
[Selm]=calculate_scorefusion_ELM(elm1 ,elm2 ,elm3,YTEST_3); %% majority voting

%% =============== Part 5: score-level fusion using Model: (b) Model HFF  (score-level fusion)===============
%% feature-level fusion and elements application // Model (B) combine all features: deep+handcrafted,
deepfeature_cmb=[X1 X2 X3];
[train_set_cmb, Test_set_cmb, YTRAIN_cmb,YTEST_cmb]=obtain_train_test_list_of_features(YTrain_label,deepfeature_cmb,T6,rnd_train,rnd_test); %% T6 is features from grid patches, deepfeatures from googlenet/resnet
[svmCMB,elmCMB ]=classification_processing_usingSVM_ELM(train_set_cmb,Test_set_cmb,YTRAIN_cmb,YTEST_cmb); %% return performance: acc, pre, recall, and f-score, Conf. matrix.

%% saving results
if exist(googlnet, 'dir')
else
    mkdir(googlnet)
end
save('./googlnet/Ssvm','Ssvm');
save('./googlnet/Selm','Selm');
save('./googlnet/svmCMB','svmCMB');
save('./googlnet/elmCMB','elmCMB');
