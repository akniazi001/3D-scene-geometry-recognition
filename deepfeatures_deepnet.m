 function [YTrain,Xng,X0, X1,X2,X3]= deepfeatures_deepnet(imdsTrain )
   net = resnet50();
%  net = vgg16;;
%  net = googlenet
   analyzeNetwork(net);
 
net.Layers(1);
inputSize = net.Layers(1).InputSize;
pixelRange = [-1 1];
scaleRange = [0.9 1.1];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange, ...
    'RandXScale',scaleRange, ...
    'RandYScale',scaleRange);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
    'DataAugmentation',imageAugmenter);
% augimdsTest = augmentedImageDatastore(inputSize(1:2),imdsValidation);
%% vgg16            
%   layer1='pool2';
%    layer2='pool3';
%    layer3= 'fc8';
%   
%%googlenet
%   layer1='pool3-3x3_s2';
%    layer2='pool4-3x3_s2';
%    layer3= 'loss3-classifier';

%%  resnet
layerneg = 'activation_29_relu';
layer0 = 'activation_35_relu';
layer1 = 'activation_41_relu';
layer2= 'activation_45_relu';
   layer3= 'fc1000';
%    layer4= 'res5b_relu';
Xng = activations(net,augimdsTrain,layerneg);
 Xng= squeeze(mean(Xng,[1 2]))';
X0 = activations(net,augimdsTrain,layer0);
 X0= squeeze(mean(X0,[1 2]))';
 X1 = activations(net,augimdsTrain,layer1);
 X1= squeeze(mean(X1,[1 2]))';
 X2 = activations(net,augimdsTrain,layer2);
 X2= squeeze(mean(X2,[1 2]))';
 X3 = activations(net,augimdsTrain,layer3,'OutputAs','rows');
whos featuresTrain
YTrain = imdsTrain.Labels;
% Xng=0;
% X0=0;
% layer15 = 'activation_26_relu';
% layer18 = 'activation_29_relu';
% layer24 = 'activation_32_relu';
% layerneg = 'activation_35_relu';
% layer0 = 'activation_38_relu';
% layer1 = 'activation_41_relu';
% layer2= 'activation_45_relu';
%    layer3= 'fc1000';
% %    layer4= 'res5b_relu';
% X15 = activations(net,augimdsTrain,layer15);
 
 

 end