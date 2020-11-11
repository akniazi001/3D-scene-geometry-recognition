function [color_Sat_uv_f, Weibul_a,Weibul_b, line_Perst_f,hsv_f,Hog_f]=feature_for_patch(patch, F)

set_global_path;
%% feature extraction from input image img,
% - Function: features= Feature_for_segment(patch, M, N, e, Bin, nrm, gradient ) is called to calculate the HOG, COLOR:RGB and HSV,
%   and weilbul distribution features are obtained.
% -	Inputs are same as previous function.
%   output is a vector (1D array-float data-type)which contains 9 feature of hog, 3 RGB, 3 HSV, 4 are weilbul distribution, and 8 feature perspective line.



Hog_f=[];
color_cof_f=[];
Sat_uv_f=[];             %
Weibul_F=[];           %
line_Perst_f=[];
hsv_f=[];
%
%                         [hog_feature]=hogcal(patch, F); %  maxcolor represent maximum gradient for this patch
[Hog_f]=hog_custm(patch, F);
%                         hog_feature=    extractHOGFeatures(patch, [4 4], [4 4], 2,9, true );% image, cellsize, blocksize, overlape,bins, and sign/unsign
%                                  hog_feature=    extractHOGFeatures(patch, 'CellSize', [4 4],'BlockSize',[4 4],  );                                                %% for weibul distribution


[a1,b1,a2,b2] = weibul_fit(patch);
weibul_A= [a1,b1];
weibul_B= [a2,b2];
%shape parmater are taken 4 represent 4 values and 1 represet in one direction vector

%% color features
%                         r = patch(:,:,1);
%                         g = patch(:,:,2);
%                         b = patch(:,:,3);
[wR,wG,wB,out1]=general_cc(patch,0,1,0); % k.e^(0,1,0) general_cc(input_data,njet,mink_norm,sigma,mask_im)

[h s v]=rgb2hsv(patch); % hsv values
R=mean(mean(wR)); % means of R,G and B
G=mean(mean(wG));
B=mean(mean(wB));

H=mean(mean(h));
S= mean(mean(s));
V= mean(mean(v));
Sat_var= mean(var(s));

color_Sat_uv_f=cat(1, Sat_var,R,G,B);
% color_Sat_uv_f=color_cof_f;             %
Weibul_a=cat(1,weibul_A');
Weibul_b=cat(1,weibul_B');


hsv_f= cat(1,H,S,V);
%                      

%   end  % for loop y rows column
%end    % for loop x%
%  line_Perst_f=cat(1,Alpha1,Beta1,Alpha2,Beta2,Alpha3,Beta3,Alpha4,Beta4);
% %  features= cat(1, features,');
end                         % end function

%% taking derviative of weibulfit'

function [a1,b1,a2,b2]=weibul_fit(patch)
   G1=fspecial('gauss',[3,3], 1);
                         [Gx,Gy] = gradient(G1); 
                       % gradscalx = imfilter(double(patch),Gx   );
%                           dy = ( imfilter(double( (patch)),Gy  ));
%                         dx=imfilter(patch,Gx,'replicate','conv');
                              dy=imfilter( double(patch),Gy,'replicate','conv');
                         dx=imfilter( double(patch),Gx,'replicate','conv');
%                            
                              %  [dx,dy]=gaussgradient( (patch),3,1); %gaussgradient(IM,size,sigma)size is filter, sigma =3 as it written in paper 
%                            dy= sqrt(double( dy.^2));
                            dy=double(dy);
%                         hue_histogram = (hist(rhue, [0.1:0.2:0.9]) + 0.01)/(length(rhue)+0.05)
                         h=   (hist(dy, [0.15,0.5,5])+0.01)/(length(dy)+0.01);
                            derivativ_y=(abs(h(:)));
                          derivativ_y=  derivativ_y+0.01;                      
                        [parmhat, ~] = wblfit(double(derivativ_y), 0.05); %% alpha =0.05 according six stimulus discussion 
                            a1=parmhat(2);
                           b1= parmhat(1);
                        %dx=double(dx);
                 h=   (hist(dx, [0.15,0.5,5])+0.01)/(length(dx)+0.01);
                        
                        derivativ_y=(abs(h(:)));
                        derivativ_y= derivativ_y+0.01;                      
                        [parmhat, ~] = wblfit(double(derivativ_y), 0.05); %% alpha =0.05 according six stimulus discussion 
                            a2=parmhat(2);
                           b2= parmhat(1);
     
end
%  function [Alpha, Beta]= prespectiveline(patch,theta) 
% 
%                         
%                          sgmv=3;
%                          sgmu=3*sgmv; %% follwoing Nedoic parameters 
% %                          theta=0.53
% %                             [x,y] = ndgrid(-round(1*1):round(1*7));
%                      out = anigauss( double(rgb2gray(patch)), sgmv, sgmu,theta,0, 1);
%                      %  out = anigauss(I(:,:,1), 3.0, 7.0, 30.0, 2, 0);
%               
%                              dy=double(out);
% %                         hue_histogram = (hist(rhue, [0.1:0.2:0.9]) + 0.01)/(length(rhue)+0.05)
%                          h=   (hist(dy, [0.15,0.7,5])+0.01)/(length(dy)+0.01);
%                             derivativ_y=(abs(h(:)));
%                           derivativ_y=  derivativ_y+0.01;
% %                         derivativ_y(derivativ_y==inf)=0.5;
% %                         derivativ_y=derivativ_y/norm(derivativ_y);
%      [parmhat, ~] = wblfit(double(derivativ_y), 0.05); %% alpha =0.05 according six stimulus discussion 
%                             Alpha= double(parmhat(2));
%                            Beta=  double(parmhat(1) );
%                          
% 
% 
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



