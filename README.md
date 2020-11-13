
Information
===================================================================================


# 3D-scene-geometry-recognition
3D scene geometry recognition system using low-level feature and multi-layer deep features
This code is implementation of Image scene geometry recognition using low-level features fusion at multi lyaer deep CNN, (under review).

For questions concerning the code please contact Altaf khan at <altaf.khan@emu.edu.tr>.

The system is implemented in Matlab. 

The code is tested on Linux (Ubuntu 18.x) and Window 7 with a Matlab version R2019b. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Two types of features are extracted in this model. 
1) Deep CNN, 
2) Handcrafted features
Main file is 'G_multilayersystem.m'
 you can access all other function by 'G_multilayersystem.m' pyramid. 
  

%%%%%%%%%%%%%%%%%%
Program has two different modules: first ResNet model is implemented and features from five different stage are extracted
These features are combined with local handcrafted features, at each stage. (5 different stages)
5 stages: means 5 classifiers are parallel connected.  We test two classifiers; SVM and ELM at each stage.
% SVM uses default setting by matlab with linear kernel. 
% ELM parameters are: 12000 hidden neurons, L=0.0078125=> L=1/2^7.
% ELM need training and testing dataset both as input, and return, accuracy, predicted labels.
combined their outcome at 'calculate_scorefusion_svmresnet.m' if ResNEt model is used. 
Else for ELM use 'calculate_scorefusion_ELM_resnet.m'
obtain_train_test_list_of_features.m shows dividing the features for training and testing images. 
pre_recall.m shows to calcualte precision, recall and Fscore values with confusion matrix. 
%%%%%%%%%%%55
for GoogeLeNet model, user needs to set the deep GoogLeNet and three stages features will be combined with handcrafted features. code is given in section 2. More detail will be given soon. 

