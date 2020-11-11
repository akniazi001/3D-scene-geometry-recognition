% clear ; 
% close all; 
% clc

%% =============== Part 1: Loading Data ================
 addpath('D:\MS and PhD life\PhD\Image-Classifier-by-alexnet/');
 
fprintf('Loading Data \n');
accuracy=0;
% while (accuracy<73)
% n is the number of types of images
  %outputFolder = fullfile('Yash0330-Image-Classifier-by-alexnet-3291263', 'photos');
  outputFolder= fullfile('D:\MS and PhD life\PhD\CNN_imageClassification\Image Classification by_RESNET50\ELM\RGB_New_dataset');

%outputFolder= fullfile('D:\MS and PhD life\PhD\CNN_imageClassification\Image Classification by_RESNET50/LBP5');
% outputFolder= fullfile('D:\MS and PhD life\PhD\CNN_imageClassification\Image Classification by_RESNET50\Bilateralclasses');
%im = imageDatastore(outputFolder,'IncludeSubfolders',true,'LabelSource','foldernames');
% Resize the images to the input size of the net
im = imageDatastore(outputFolder,'IncludeSubfolders',true,'LabelSource','foldernames');
% Resize the images to the input size of the net
% im.ReadFcn = @(loc)imresize(imread(loc),[227,227]);
[imdsTrain,imdsValidation] = splitEachLabel(im,0.8,'randomized');

% fprintf(' Press enter to continue.\n');

%  net = googlenet('Weights','places365');;
% analyzeNetwork(net);
net= resnet50;
% net.Layers(1);
inputSize = net.Layers(1).InputSize;

pixelRange = [-10 10];
scaleRange = [0.9 1.1];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange, ...
    'RandXScale',scaleRange, ...
    'RandYScale',scaleRange);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
    'DataAugmentation',imageAugmenter);
augimdsTest = augmentedImageDatastore(inputSize(1:2),imdsValidation);

%layer = 'loss3-classifier';
layer = 'fc1000';

featuresTrain = activations(net,augimdsTrain,layer,'OutputAs','rows');
featuresTest = activations(net,augimdsTest,layer,'OutputAs','rows');

whos featuresTrain
YTrain = imdsTrain.Labels;
YTest = imdsValidation.Labels;
tic,classifier = fitcecoc( norma_me(featuresTrain),YTrain); toc
tic,YPred = predict(classifier,norma_me (featuresTest)); toc
accuracy = mean(YPred == YTest)
[confmat, prec, recall, fscore] = prec_recall(YTest,YPred)
 

 toc
% [confmat, prec, recall, fscore] = prec_recall(YTest,YPred)
 
% save('./majority/google_net', 'google_net');
%  save('./majority/truelabel', 'YTest');
% 
%  addpath('./elm_kernel/');
%  addpath('./elm_kernel/diabetes_train/');
%  addpath('./elm_kernel/diabetes_test/');
  train = (featuresTrain);
  test = (featuresTest);
  mytrain= [(string(YTrain)),(train)];
  mytest= [(string(YTest)),(test)];
  [TrainingTime, TestingTime, Trainacc, TestACC,  ACTUAL,PRED] = ELM(mytrain, mytest, 1,3500,'hardlim',0.5)
%   save('./result_prob/elmtreived_laplc_P','prob');
[confmat, prec, recall, fscore] = prec_recall(ACTUAL',PRED')
  %% SVM linear
  %tic,classifier = fitcecoc( (featuresTrain),YTrain); toc
  %tic,Y= predict(classifier, (featuresTest)); toc
  % acclinear = mean(Y == (YTest))
  %%
  %[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = ELM(mytrain, mytest, 1, 1000,'sig',0.057)
% %  alldata= [featuresTrain;featuresTest];
%  alllabel= [double(YTrain);double(YTest)];
%  %[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = elm_kernel(TrainingData_File, TestingData_File, Elm_Type, Regularization_coefficient, Kernel_type, kernel_para)
  
%      [TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy,predict_test]= elm_kernel('./elm_kernel/mydata/train',...
%      './elm_kernel/mydata/test', 1, 1, 'lin_kernel',1000);
%  accuracy = mean(predict_test' == double(string(YTest)))
% [confmat, prec, recall, fscore] = prec_recall(double(string(YTest)),predict_test')
%  
 % [TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = elm_kernel('diabetes_train', 'diabetes_test', 1, 1, 'RBF_kernel',100)
 
% Opts.ELM_Type='Class';    % 'Class' for classification and 'Regrs' for regression
% Opts.number_neurons=200;  % Maximam number of neurons 
% Opts.Tr_ratio=0.70;       % training ratio
% Opts.Bn=0;   
% [net]= elm_LB(alldata,alllabel,Opts);
% %  net;
% elmp=predict_test';
% svmp= double(string(YPred));
% actual=double(string(YTest));
% count=0;
% for i=1:numel(actual)
%     if(svmp(i)==elmp(i))
%         if elmp(i) == actual(i)
%             count =count +1;
%         
%         elseif elmp(i) == actual(i)
%             count =count +1;
%         end
%     end
% end
% count/numel(actual)

function out= norma_me(inputdata)
    %for i=1:numel(inputdata(:,1))
            out=normalize(inputdata,2,'range');
    %end

end
