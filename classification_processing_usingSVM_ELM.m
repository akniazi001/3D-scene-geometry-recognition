function [svm,elm ]=classification_processing_usingSVM_ELM(train_set,Test_set,YTRAIN,YTEST)
tic, 
classifier= fitcecoc((train_set),  (YTRAIN)); % svm training 
toc
%% classify
tic, [svm.labels, svm.score]= predict(classifier, Test_set);
toc

tic, svm.accuracy = mean(svm.labels== (YTEST));
toc
 
[svm.confmat, svm.prec,svm.recall, svm.fscore] = prec_recall(YTEST,svm.labels)
figure, %%% confusion matrix 
confcount = confusionmat(double(YTEST),double(svm.labels)');
plotConfMat(svm.confmat,{'skyBkgGnd','skyGnd','bkgGnd','ground','sidewalRL', 'Box','diagBKgRL','groundDiagBkgRL', 'Corner', 'TablePersonBkg','PersonBkg','noDepth', ''});

% confusionchart(confcount,{'Bedroom','Calsubrub','Industrial','Kitchen','Living Room','Coast','Forest','Highway', 'Insidecity', 'Mountain', 'Opencountry','Street','Tallbuilding','Office', 'Store'})
title(['Accuracy =' num2str(svm.accuracy*100,4)] );
% figure,
% plotConfMat(confmat, {'Bedroom','Calsubrub','Industrial','Kitchen','Living Room','Coast','Forest','Highway', 'Insidecity', 'Mountain', 'Opencountry','Street','Tallbuilding','Office', 'Store'});
% xtickangle(45)
%   out=normalize(featuresTest,2,'range');
% save('./majority/google_net', 'google_net');
% %  save('./majority/truelabel', 'YTest');
 mytrain= [double((YTRAIN)),double(train_set)];
 mytest= [double((YTEST)),double(Test_set)];
% %  alldata= [featuresTrain;featuresTest];
% %  alllabel= [double(YTrain);double(YTest)];
% %[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = elm_kernel(mytrain, mytest, Elm_Type, Regularization_coefficient, Kernel_type, kernel_para)
     addpath('./ELM\ELM-LRF-master/');
  [elm.TrainingTime, elm.TestingTime, elm.Trainacc, elm.TestACC,  elm.predict,elm.true] =ELM(mytrain, mytest, 1,12000,'sig',0.007815);
% 
[elm.confmat, elm.prec, elm.recall, elm.fscore] = prec_recall(double(YTEST),elm.predict')
figure,
confcount = confusionmat(double(YTEST),double(elm.predict)');
plotConfMat(confcount,{'skyBkgGnd','skyGnd','bkgGnd','ground','sidewalRL', 'Box','diagBKgRL','groundDiagBkgRL', 'Corner', 'TablePersonBkg','PersonBkg','noDepth', ''});
xtickangle(45);
% title(['Accuracy =' num2str(elm.TestACC*100,4)] );
end
