addpath activations/
addpath utilities/
addpath utilities/initialization/
[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = ELM(Train, Test, 1, 1000,'tribas',0.1);


[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = ELM(Train, Test, 1, 300,'tribas',0.1)
