# 3D-scene-geometry-recognition
3D scene geometry recognition system using low-level feature and multi-layer deep features



This code is belong to Image scene geometry recognition using low-level features fusion at multi lyaer deep CNN

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Two types of features are extracted in this model. 
1) Deep CNN, 
2) Handcrafted features
Main file is 'G_multilayersystem.m'
 you can access all other function by 'G_multilayersystem.m' pyramid. 
contact altaf.khan@emu.edu.tr if you need further assistant. 

%%%%%%%%%%%%%%%%%%55
Program has two different modules: first ResNet model is implemented and features from 5 differents layers are extracted
These features are combined with local handcrafted features, at each stage. (5 different stages)
5 stages: means 5 classifiers are parallel connected.  We use two classifiers, SVM and ELM at each stage.
combined their outcome at 'calculate_scorefusion_svmresnet.m' if ResNEt model is used. 
Else for ELM use 'calculate_scorefusion_ELM_resnet.m'
obtain_train_test_list_of_features.m shows dividing the features for training and testing images. 
pre_recall.m shows to calcualte precision, recall and Fscore values with confusion matrix. 
%%%%%%%%%%%55
for GoogeLeNet model, use needs to set the deep GoogLeNet and three deep features will combined with handcrafted features. code is given in section 2. 
