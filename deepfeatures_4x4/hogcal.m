function [hog_feature]=hogcal(patch,F)
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
gradient=F.gradient;
nrm= F.nrm;
max_angle= F.max_angle
B=F.Bin; %% bin size 
hog_feature=zeros(B,1); % column vector with zeros
[M, N, K] = size(patch);
% ===============================
%    Compute Gradient Vectors
% ===============================
% Compute the gradient vector at every pixel in the image.

% Create the operators for computing image derivative at every pixel.
if (gradient==1)
        hx = [-1,0,1];      % Create the operators for computing image derivative at every pixel.
        hy = -hx';             
else
            hx = [-1,0,1
                -2,0,2
                -1,0,1];
        hy = -hx';
end

%%%%
 

%%%5



 G1=fspecial('gauss',[3, 3], 1);
 % Compute the derivative in the x and y direction for every pixel.
  [Gx,Gy] = gradient(G1); 
 gradgassx = imfilter(double(patch),Gx);
gradgassy = imfilter(double(patch),Gy);
gradscalx = imfilter(double(patch),hx);
gradscaly = imfilter(double(patch),hy);
% 

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
    maxcolor=0;
    magnit = sqrt(double(gradscalx.^2 + gradscaly.^2));
end
% Convert the gradient vectors to polar coordinates (angle and magnitude).
angles=atan2(gradscalx,gradscaly);
angles(isnan(angles))=0;
magnit(isnan(magnit))=0;

%%% if(signed)
%     ang=angles;
%     total_Ang=180; %% eedit
% else
%     unsigned_ang=angles;
%     unsigned_ang(signed_ang(:)<0)=signed_ang(signed_ang(:)<0)+180;
%     ang=unsigned_ang;    
%     total_Ang=360;
%%% end
           
%         angles2=angles(n*N+1:(n+1)*N,m*M+1:(m+1)*M);
%         magnit2=magnit(n*N+1:(n+1)*N,m*M+1:(m+1)*M);
            angles2=angles;  
            magnit2=magnit;   
            v_angles=angles2(:) ;   
            v_magnit=magnit2(:);
            K=max(size(v_angles));
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
        H2=zeros(B,1); % for binning, we took the size of bin for histogram
        
        for ang_lim=-pi+2*pi/B:2*pi/B:pi %%%%
            bin=bin+1;
            for k=1:K
                if v_angles(k)<=ang_lim
                    v_angles(k)=100;
                    H2(bin)=H2(bin)+v_magnit(k);
                end
            end
        end
                
         %% norm and 0.001 is e (constant)      
      
        % normalization {'l2hys'}
   
        
        H2=H2/sqrt(norm(H2,nrm)^2+e^2);
         hog_feature=H2;
%         for z=1:length(H2)  
%              if H2(z)>0.2
%              H2(z)=0.2;
%             end
%         end
%        hog_feature=H2/sqrt(norm(H2)^2+.001);  
    end