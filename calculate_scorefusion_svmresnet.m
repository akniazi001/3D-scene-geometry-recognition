function [S]=calculate_scorefusion_svmresnet(svmng,svm0, svm1,svm2,svm3,actual_label) 
%% input: indicating layer1, to layer 5 score respectively, 
%% output: S is structure. contains sum, product, and majority voting, in terms of acc, pre, rec, fscore,  and conf. matrix.
%% initialize 
no_fusion_layers=5;
label=actual_label; 

tng= (svmng.score);
t0= (svm0.score);

t1= (svm1.score);
t2=  (svm2.score) ;
t3=  (svm3.score);

% t1= 0.5*(tanh(0.1*(t1-mean(t1)/std(t1))+1));
% t2= 0.5*(tanh(0.1*(t2-mean(t2)/std(t2))+1));
% t3= 0.5*(tanh(0.1*(t3-mean(t3)/std(t3))+1));

 %% initialize
imglist=numel(t1(:,1));
   predictng=[];
  predict0=[];
 predict1=[];
  predict2=[];
  predict3=[];
 c=0;
 c1=0;
count=0;
%% max rule
for i=1:imglist
   % for j=1:clss
     [mng,ing] =  max(tng(i,:)); 
     [m0,i0] =  max(t0(i,:));
      [m1,i1] =  max(t1(i,:));
      [m2,i2]=   max(t2(i,:));
       [m3,i3]=   max(t3(i,:));
             set_temp=-inf;
         
            if(m0>set_temp)
             set_temp=m0;
             index=i0;
            end
           if(mng>set_temp)
             set_temp=mng;
             index=ing;
           end
           
           if(m1>set_temp)
             set_temp=m1;
             index=i1;
           end
          
           if(m2>set_temp)
             set_temp=m2;
             index=i2;
           end
           if(m3>set_temp)
             set_temp=m3;
             index=i3;
           end
           predict1(i)=index;
   
    list=[svm3.labels(i), svm2.labels(i),svm1.labels(i),svm0.labels(i),svmng.labels(i)];
     cap=unique(list);
    res= histc(list,cap);
  [v,indx]= max(res);
       c1(i) =cap(indx);
      if ( label(i)==c1(i))
         c=c+1;
      end

   %end
end
fprintf(' \t \t accuracy of max rule:%3f \n',  mean(label==predict1'));
S.majority = mean(label==c1'); 
[S.major.confmat, S.major.prec, S.major.recall, S.major.fscore] = prec_recall(double(label),c1')

S.maxrule = mean(label==predict1');
[S.maxr.confmat, S.maxr.prec, S.maxr.recall, S.maxr.fscore] = prec_recall(double(label),predict1')
%%  sum rule performance,
tic
count2=0;  
  for i=1:imglist
         
        m_majr(i,:)= (tng(i,:)+t0(i,:)+t1(i,:)+t2(i,:)+t3(i,:))/no_fusion_layers   ;   
 
     [value, index]= max(m_majr(i,:));
      predict2(i)=index;
   if index == label(i)
     count2=count2+1;
  end
 
  end

S.sumrule= mean(label==predict2'); 
fprintf('sum_rule: %2f \n', S.sumrule*100);
[S.sum.confmat, S.sum.prec, S.sum.recall, S.sum.fscore] = prec_recall(double(label),predict2')

toc
%% product rule
count3=0;  
  for i=1:imglist
         
     m_majr(i,:)= (tng(i,:).*t0(i,:).*t1(i,:).*t2(i,:).*t3(i,:))/no_fusion_layers;   
 
     [value, index]= max( m_majr(i,:));
      predict3(i)=index;
   if index == label(i)
     count3=count3+1;
  end
 
  end

S.productrule= mean(label==predict3');
fprintf('product_rule: %2f \n', S.productrule*100);
toc
%%
[S.product.confmat, S.product.prec, S.product.recall, S.product.fscore] = prec_recall(double(label),predict3')

% %
%   confmat = confusionmat(label,c1')
% % %
%  plotConfMat(confmat);
% % %
% % % %confmat = i;
% % %
% % %
%    plotConfMat(S.confmat, {'bkgGnd','Box','Corner','diagBkgRL','Ground', 'groundDiagBkgRL','noDepth','personBkg', 'sidewalRL', 'skyBkgGnd','skyGnd','tablePersonBkg', ''});
% % %
% xtickangle(45);
% ytickangle(0);
% 

end
%%%% may u need to assign class name to class index. 
function i=checkclass(label) %% change indix as u like to show at confusion matrix. 

            if label=='bkgGnd'
            i=6;
            elseif label=='Box'
            i=1;
             elseif label=='Corner'
            i=2;
             elseif label=='dialBkgRL'
            i=7;
             elseif label=='Ground'
            i=3;
             elseif label=='groundDiagBkgRL'
            i=8;
             elseif label=='noDepth'
            i=9;
             elseif label=='PersonBkg'
            i=4;
             elseif label=='sidewalRL'
            i=10;
             elseif label=='skyBkgGnd'
            i=11;
             elseif label=='skyGnd'
            i=12;
             elseif label=='TablePersonBkg'
            i=5;
            end
    
end