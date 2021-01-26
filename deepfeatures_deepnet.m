 function [YTrain,Xng,X0, X1,X2,X3]= deepfeatures_deepnet(imdsTrain )
   net = resnet50(); %% only ResNet model is given here, you may use other CNN pre-trained model 
%  net = vgg16;;
%  net = googlenet
%    analyzeNetwork(net);
 
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

%%  resnet intermediate layers
layerneg = 'activation_29_relu'; %% get features from particular intermediate layers
layer0 = 'activation_35_relu';
layer1 = 'activation_41_relu';
layer2= 'activation_45_relu';
   layer3= 'fc1000';
 
Xng = activations(net,augimdsTrain,layerneg); %% Xng, X0,..,X3 are indicating the deep features vector of different layers of ResNet Model. 
 Xng= squeeze(mean(Xng,[1 2]))';
X0 = activations(net,augimdsTrain,layer0);
 X0= squeeze(mean(X0,[1 2]))'; % this function work as Average pooling for N number of images, NXL feature vectors return, L is a feature vector per image.
 X1 = activations(net,augimdsTrain,layer1);
 X1= squeeze(mean(X1,[1 2]))';
 X2 = activations(net,augimdsTrain,layer2);
 X2= squeeze(mean(X2,[1 2]))';
 X3 = activations(net,augimdsTrain,layer3,'OutputAs','rows');
whos featuresTrain
YTrain = imdsTrain.Labels;
 end
