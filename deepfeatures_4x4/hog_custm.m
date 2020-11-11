function [hog_feature]=hog_custm(patch,F)
% GETHOGDESCRIPTOR computes a HOG descriptor vector for the supplied image patch.
%   [feature,maxcolor] = hogcal(patch,bin,gradient, nrm,e)
%  patch- is NxM part of image(RGB)
%   Bin-  is number of binning where each pixel will vote into the corresponding bin.  
%   
%   Gradient- computing the gradients and computes if gradient=1 then  hx = [-1,0,1];  else hx=  [-1,0,1;-2,0,2; -1,0,1];
%   
%    
%   Returns:
%   hog_feature- 1D array of length 9 (1D array)
%   maxcolor- color value

%    The intent of this function is to implement the same design choices as
%    the original HOG descriptor for human detection by Dalal and Triggs.
%    Specifically, I'm using the following parameter choices:
%      - MxN pixel cells:4x4
%      - excluding Block size of 2x2 cells
%      - excluding 50% overlap between blocks
%      - 9-bin histogram
% 
%    - For the block normalization, I'm using L2 normalization.
%
%    

    
% Empty vector to store computed descriptor.
 
% e constant for normalization 



e= F.e;
maskdim=F.maskdim;
nrm= F.nrm;
max_angle= F.max_angle;
B=F.Bin; %% bin size 
hog_feature=zeros(B,1); % column vector with zeros
[M, N, K] = size(patch);
% ===============================
%    Compute Gradient Vectors
% ===============================
% Compute the gradient vector at every pixel in the image.

% Create the operators for computing image derivative at every pixel.
if (maskdim==1)
        hx = [-1,0,1];      % Create the operators for computing image derivative at every pixel.
        hy = -hx';             
else
            hx = [-1,0,1
                -1,0,1
                -1,0,1];
        hy = -hx';
end

 G1=fspecial('gauss',[3, 3], 0.5);
 % Compute the derivative in the x and y direction for every pixel.
  [Gx,Gy] = gradient(G1); 
 gradgassx = imfilter(double(patch),Gx);
gradgassy = imfilter(double(patch),Gy);
% Compute the derivative in the x and y direction for every pixel.
gradscalx = imfilter(double(patch),hx   );
gradscaly = imfilter(double(patch),hy  );
% 
check_x=double(abs(rgb2gray(gradgassx))+abs(rgb2gray(gradscalx)))/abs(rgb2gray(gradgassx));

if K > 1
        maxgrad = sqrt(double(gradscalx.*gradscalx + gradscaly.*gradscaly));
        [gradscal, gidx] = max(maxgrad,[],3);
        gxtemp = zeros(M,N);
        gytemp = gxtemp;
        for kn = 1:K
            ttempx = gradscalx(:,:,kn);
            ttempy = gradscaly(:,:,kn);
            tmpindex = find(gidx==kn);
          if(isempty(tmpindex )==0) 
              maxcolor=kn; 
          end
          
            gxtemp(tmpindex) = ttempx(tmpindex);
            gytemp(tmpindex) =ttempy(tmpindex);
         
        end
        gradscalx = gxtemp;
        gradscaly = gytemp;
       magnit = sqrt(double(gradscalx.*gradscalx + gradscaly.*gradscaly));
else
    
    magnit = sqrt(double(gradscalx.^2 + gradscaly.^2));
end
% Convert the gradient vectors to polar coordinates (angle and magnitude

% calculate gradient orientation matrix.  
% plus small number for avoiding dividing zero.  
              gradscalxplus = gradscalx+ones(size(gradscalx))*0.0001;  
              gradorient = zeros(M,N);  
% unsigned situation: orientation region is 0 to pi.  
if strcmp(F.issigned, 'unsigned') == 1  
    max_angle=180;
    gradorient = atan(gradscaly./gradscalxplus);
% %    gradorient(gradorient < 0) = gradorient(gradorient < 0) + pi;
    gradorient= (180/pi)*(mod(gradorient,pi));
    gradorient= gradorient(:);
   
                                            % signed situation: orientation region is 0 to 2*pi. 
elseif strcmp(F.issigned, 'signed') == 1  
        max_angle=360;
        for i=1: size(gradscalxplus)
            for j=1:size( gradscaly)
                if( gradscaly(j)<0 && gradscalxplus(i)<0)
                    gradorient(i,j) =( atan(gradscaly(j)./gradscalxplus(i))+pi);
                elseif( gradscaly(j)<0 || gradscalxplus(i)<0)
                    gradorient(i,j) =( atan(gradscaly(j)./gradscalxplus(i))+2*pi);
                end
            end 
        end
        
         gradorient= (180./pi )*(mod(gradorient,2*pi)); % for degree 0-2.*pi convert into degree
        %%%%gradorient(gradorient < 0) = gradorient(gradorient < 0) + 2*pi;
     gradorient= gradorient(:);
     else  
        error('Incorrect ISSIGNED parameter.');  
end
 
%.............

gradorient(isnan(gradorient))=0;
magnit(isnan(magnit))=0;
 
           
%         angles2=angles(n*N+1:(n+1)*N,m*M+1:(m+1)*M);
%         magnit2=magnit(n*N+1:(n+1)*N,m*M+1:(m+1)*M);
            v_angles=gradorient(:);  
            v_magnit=magnit(:);   
            pixels_num=max(size(v_angles));
        % =================================
        %     Compute Cell Histograms 
        % =================================
        % Compute the histogram for every cell in the image. We'll combine the cells
        % into blocks and normalize them later. here we have only 4x4 patch
        % of image so we consider it only one block.

        % Create a three dimensional matrix to hold the histogram for each cell.
        %assembling the histogram with 9 bins (range of pi/bin degrees per
        %bin). 
         bin=0;
         hist=zeros(B,1); % for binning, we took the size of bin for histogram
         W=max_angle/B; 
        for i=1: pixels_num
             if v_angles(i)>=0 && v_angles(i)<W/2
                         hist(1)=hist(1)+ v_magnit(i)*(v_angles(i)+W/2)/W;
                         hist(B)=hist(B)+ v_magnit(i)*(W/2-v_angles(i))/W;
            
             else
                 
             i_bin= floor(v_angles(i)/W - 0.5);
          
           bin_index= mod(i_bin,B);  
           cvalue=C(bin_index+1, W);
           Vi= v_magnit(i)*((cvalue-v_angles(i))/W) ;
           hist(bin_index+1)= hist(bin_index+1)+Vi;
           next_bin_index=mod(bin_index+1, B);
           
          cvalue=C(bin_index, W);
         Vi_plus_1= v_magnit(i)*((v_angles(i)-cvalue)/W);
             hist(next_bin_index+1)= hist(next_bin_index+1)+Vi_plus_1;
            
             end
        end
         
     V= norm(hist,nrm)^nrm;
%       if V==0 
%       
%       end
      
          hog_feature=hist/(V+e^nrm)^(1/nrm);
       
%         for z=1:length(H2)  
%              if H2(z)>0.2
%              H2(z)=0.2;
%             end
%         end
%        hog_feature=H2/sqrt(norm(H2)^2+.001);  
end
function cvalue=C(bin_index, W)
 cvalue= W*(bin_index+0.5);
end