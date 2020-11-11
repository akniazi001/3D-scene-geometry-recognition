                 %%%%%%%+++++++++++++++++++++%%%%%%%%%%%%%%
                 %% implementation of handcrafted features %%%%%%%%%%%%%%%%%
                 %%%%%%++++++++++++++++++++++++++%%%%%%%%%%%%%%%%
                 %% Code implementation: Matlab 2019a. 
 %% extract grid patches features:  hog, weibull, coefficient of RGB, HSV         
 function [grid_basedFeature, imageid_scene] = Mainfile_features_gridpatch(im)
 
 
 grid_basedFeature=[];
 % im =
 % imageDatastore(outputFolder,'IncludeSubfolders',true,'LabelSource','foldernames');
 % load manually images if you want only handcrafted features.

 for i=1: numel(im.Files)
     a= im.Files(i);
     img= a{1};
     I= imread(img);
       out=regexp(a,'\','split');

     c=out{1};%% need to set according to your folder path
     category=c{5};%% need to set according to your folder path
     img_name= c{6};%% need to set according to your folder path
     
     [t1]= extract_feature(I,i); %% call for features extraction
     grid_basedFeature(i,:)= [str2num(category), t1];
     imageid_scene(i).category=[category];
     imageid_scene(i).name=[img_name];
     
 end
  
 grid_basedFeature(isnan(grid_basedFeature))=0; %% later assigned with average value 
 save('grid_basedFeature.mat','grid_basedFeature');
 save('local_sceneimageid_1200','imageid_scene')
 end

 function  [t_1]=extract_feature(img,i)
%% function has several comments that are not used in this work
% input: images : each image with indix means class indix, and return a
% features set for hog, color, weibull parameters.
 F.id=i;
 F.M =4;       %              o	f.M= 4 and f.N=4 ;  for patch size (MxN)
 F.N=4;       %               o	f.e=0.01   ; hog constant,
 F.Bin=9;       %             o	f.Bin= 9   ; hog histogram
 F.maskdim=2 ;      %         o f.maskdim= 1 ; gradient 1D
 F.nrm=2;       %             o	f.nrm=2           ; normalize type 2
 F.max_angle=360;      %      o	f.max_angle =360;  in degree ,
 F.e=0.01;
 F.thresh= 0.50;%% it is used for find the internal window number of ones to select the window or reject
 F.threshold=1.5; %0.90
 F.issigned = 'unsigned'; %issigned = 'unsigned': 0-180;  or  signed :0-360
 %F.overlaphor=2; %%%enter the window overpalling in horizontal direction
 %F.overlapver=2; %% enter overlapping the window in vertical direction.
 
 [color_Sat_uv_F,Weibul_F,line_Perst_F,hsv_F,hog_F]= Feature_extraction_from_each_image(img, F,i);
 % [binary_f,E]= local_binary_pattern(img, F,1);
 
 t_1=[color_Sat_uv_F,Weibul_F,hsv_F,hog_F];
 
 %
 %%weibul
 %                            feature_path=('./classes/newdata/WIEBUL/');
 %                            if exist(feature_path, 'dir')
 %                            else
 %                                   mkdir(feature_path);
 %                             end
 %          %           feature_=strcat(feature_path,('weibul'));
 %               feature_path=strcat(feature_path,num2str(image_num) );
 %                            weibul=strcat(feature_path,'.mat');
 %                             save(weibul,'Weibul_F');
 %
 %                              %%color
 %                            feature_path=('./classes/newdata/COLOR/');
 %                            if exist(feature_path, 'dir')
 %                            else
 %                                   mkdir(feature_path);
 %                             end

 
 end
 