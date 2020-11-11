function [color_Sat_uv_F,Weibul_F,line_Perst_F,hsv_F,hog_F]= Feature_extraction_from_each_image(img, F,classindex)
        %=========== img input, and par contains parameters values, classindex is
        %class id where image belong to
  
% function one_segment_features= feature_extraction( img, F)
   [Row,Col,K]=size(img); % row and column and K represent color channel  
    
  Row_chunk=floor(Row/(F.M)); %% nxn patches
  col_chunk=floor(Col/(F.N));  
  F.Row_chunk=Row_chunk;
  F.col_chunk=col_chunk;
  color_Sat_uv_F=[]; Weibul_A=[]; Weibul_B=[];line_Perst_F=[];
   hsv_F=[];hog_F=[];
  %% step_x and step_y are nxn patch to use for getting the feature.
  for m=1:Row_chunk:(Row- (Row_chunk-1))     %%% row-N
      
      for n=1:col_chunk:(Col - (col_chunk-1))   %%col-M
          %n
          patch=img(m:m+(Row_chunk-1), n:n+(col_chunk-1),:);
          %                   patch=img(m*F.M+1:(m+1)*F.M,n*F.N+1:(n+1)*F.N, :);
          [color_Sat_uv_f, Weibul_a,Weibul_b, line_Perst_f,hsv_f,hog_f]=feature_for_patch(patch, F);
          
          hsv_F =cat(1,hsv_F,hsv_f);
          hog_F=cat(1,hog_F,hog_f);
          color_Sat_uv_F= cat(1,color_Sat_uv_F,color_Sat_uv_f);
          Weibul_A= cat(1,Weibul_A,Weibul_a);
          Weibul_B= cat(1,Weibul_B,Weibul_b);
          line_Perst_F=cat(1,line_Perst_F, line_Perst_f);
           
      end % end step colmn
      %
  end % end steprows
%%final vector
Weibul_A=Weibul_A/norm(Weibul_A);
Weibul_B=Weibul_B/norm(Weibul_B);
Weibul_F= cat(1,Weibul_A,Weibul_B);

 %% set dim in one array
 color_Sat_uv_F= color_Sat_uv_F';
 line_Perst_F=line_Perst_F';
 Weibul_F=Weibul_F';
 hsv_F= hsv_F';
 hog_F=hog_F';
             
                  %% add class label
%        color_Sat_uv_F=[classindex,color_Sat_uv_F]; %% color: 5 features:  mean of RGB, variance and mean of Saturation component. 
%        Weibul_F= [classindex,Weibul_F]; %% 4 features : weibull x and y direction alpha and beta value 
%        line_Perst_F=[classindex,line_Perst_F]; %% 8 features: 4 different angle alpha and beta value 
%       hsv_F=[classindex,hsv_F]; % 3 mean value of HSV channels
%       hog_F=[classindex,hog_F]; % 9 features: Hog features for patch 
                   
%%%%%%%%%%%%%%%%%%%%% color +saturation variance +average
 
end % end function
 
 