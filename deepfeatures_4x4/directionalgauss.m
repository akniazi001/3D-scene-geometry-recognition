  
close all;
 
  
  I= imread('4.jpg');

%            I= rgb2gray(I);
  figure,imshow(I);  
phi= 0;
n=5;
for i=1:n
 
  
 figure,imshow(I); 
phi =phi+30 ; 
 x=[-1 0 1];
 
   
   sigmav=3 ;  
   sigmau=3*sigmav;         
                         
    su2 = sigmau*sigmau;
    sv2 = sigmav*sigmav;
    phirad = phi*pi/180;

    a11 = cos(phirad)*cos(phirad)*su2 + sin(phirad)*sin(phirad)*sv2;
    a21 = cos(phirad)*sin(phirad)*(su2-sv2);
    a22 = cos(phirad)*cos(phirad)*sv2 + sin(phirad)*sin(phirad)*su2;

    sigmax = sqrt(a11-a21*a21/a22);
    tanp = a21/a22;
    sigmay = sqrt(a22);
    
twopi_sgmaxsgmav=1/double(2*pi*sigmax*sigmav);
y= x.*tanp; 
 

p1=a11-(a21^2)/a22;
p1=-0.5*((x.^2)/p1);
 
p2=  (y+(a21/a22)*x).^2;
p2= -0.5*p2/a22;
P2=exp(p1+p2);

                         
%  gthetax= twopi_sgmaxsgmav*(P1);                        
       gtheta=twopi_sgmaxsgmav*(P2);                   
                         
                         
                         
% %%%%%%%%%%%%%%%%%%%
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
% second equation implementatio n
% twopi_sgmaxsgmay=1/double(2*pi*sgmu*sgmv);
% 
% p1= ((x*cos(theta)+y*sin(theta)).^2)/sgmu^2  +  ((-x*sin(theta)+y*cos(theta)).^2)/sgmv^2 ; 
% 
% p=(-0.5)*p1;
% gtheta= abs(twopi_sgmaxsgmay*exp(p));
% plot(gtheta);    
% V(i).ary =imfilter(double(I),gtheta,'conv');
%   figure , imshow(V(i).ary, []);
 k=12; 
a=zeros(k,k);
ks= floor(k/2);
   a(ks,ks)=1; 
     out = anigauss(a, 1.0, 3.0, phi, 2, 0);
 %  out = anigauss(I(:,:,1), 3.0, 7.0, 30.0, 2, 0);

V(i).ary =imfilter(double(I),out,'conv');imshow(V(i).ary,[]);
 end
 figure,
 avg= V(1).ary/n;
 for i=2:n
avg= avg+V(i).ary/n;
imshow(avg,[]);
 end
 