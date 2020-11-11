%  function gtheta= doublegradient(x,y, sgmu,sgmv,theta)
% 
close all;
ary= zeros(4,1);
 theta=0.000054;
  I= imread('papertest.jpg');
       I= rgb2gray(I);
  figure,imshow(I); 
%  mex anigauss_mex.c anigauss.c -output anigauss 
%   out = anigauss(in, sigma_v, sigma_u, phi,
%     derivative_order_v, derivative_order_u);
% k=10; 
% a=zeros(k,k);
%    a(k/2,k/2)=1; 
a=[-1 0 1];

  g_filter=anigauss(a,1,3,30);  out = anigauss( double(I(:,:,1)), 3.0, 7.0, 150.0,0, 1);
 %  out = anigauss(I(:,:,1), 3.0, 7.0, 30.0, 2, 0);
imshow(out,[]);
% ary =imfilter(double(I),out,'conv')
% imshow(ary,[]);



% for i=1:5
%  I= imread('a.jpg');
% %  I= rgb2gray(I);
% %  figure,imshow(I); 
%  
%  x=[ 0.25 0 0.75];
%                          y=4 ;
%                          sgmv=1 ;  
%                          theta=theta+30 ;
%                          sgmu=3*sgmv;
% % u=[10,20,32,14; 11 12 53 54;1 2 3 4];
% % v=[31,23,53,74; 61 52 43 24;11 12 23 44];
% % 
% % q=1/double(2*pi*sgmu*sgmv);
% % p1=((u*cos(theta)+v*sin(theta)).^2)/double((sgmu)^2);
% % p2=((-u*sin(theta)+v*cos(theta)).^2)/double((sgmv)^2);
% % p=-0.5*(p1+p2);
%  
% %  sgmv=2.5;
%  
% % 
% % %final_valu=q*exp(p);
% % 
% % %-------------------%
% % x=[1 2 3];
% % y=[1 2 3];
% 
% %%%%%%%%%%%%%%%%%%%%%
% sgmax= sgmu*sgmv/(sqrt((sgmv^2)*(cos(theta)^2) + (sgmu^2)*sin(theta)^2));
% tantheta=((sgmv^2)*(cos(theta)^2 ) + (sgmu^2)*(sin(theta)^2))./( (sgmu^2-sgmv^2)*cos(theta)*sin(theta) );
% 
% phi= atan(tantheta);
% 
% sgmaphi= (1/sin(phi))*(sqrt((sgmv^2)*cos(theta)^2 + (sgmu^2)*sin(theta)^2));
% 
% 
% twopi_sgmaxsgmay=1/double(2*pi*sgmax*sgmaphi);
% 
% p1=((x-y/(tantheta)).^2)/sgmax^2 + ((y/sin(phi)).^2)/sgmtheta^2 ;
% %% second equation implementatio n
% % twopi_sgmaxsgmay=1/double(2*pi*sgmu*sgmv);
% 
% % p1= ((x*cos(theta)+y*sin(theta)).^2)/sgmu^2  +  ((-x*sin(theta)+y*cos(theta)).^2)/sgmv^2 ; 
% 
% p=(-0.5)*p1;
% gtheta= abs(twopi_sgmaxsgmay*exp(p));
% plot(gtheta);
% V(i).ary =imfilter(double(I),gtheta,'conv');
%   figure , imshow(V(i).ary, []);
%  
%  end
%  figure,
% avg= V(1).ary/5+ V(2).ary/5+ V(3).ary/5+ V(4).ary/5+V(5).ary/5;
% imshow(avg,[]);
% % end