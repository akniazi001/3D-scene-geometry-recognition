function [S]=calculate_scorefusion_ELM(e1,e2,e3,actual_label)

%% initialize 
label=actual_label; 


t1= (e1.predict);
t2=  (e2.predict) ;
t3=  (e3.predict); 

imglist=numel(t1(:,1));
  
  predict1=0;
  predict2=0;
  predict3=0;
 c=0;
 c1=0;
count=0;
%% max rule
for i=1:length(e1.predict)
    list=[e1.predict(i), e2.predict(i),e3.predict(i)];
     cap=unique(list);
    res= histc(list,cap);
  [v,indx]= max(res);
       c1(i) =cap(indx);
      if ( label(i)==c1(i))
         c=c+1;
      end 
end   
S.majority = mean(label==c1'); 
[S.majr.confmat, S.majr.prec, S.majr.recall, S.majr.fscore] = prec_recall(double(label),c1')
% 
% for i=1:imglist
%    % for j=1:clss
%    
%       [m1,i1] =  max(t1(i,:));
%       [m2,i2]=   max(t2(i,:));
%        [m3,i3]=   max(t3(i,:));
%              set_temp=-inf;
%           if(m1>set_temp)
%              set_temp=m1;
%              index=i1;
%            end
%           
%            if(m2>set_temp)
%              set_temp=m2;
%              index=i2;
%            end
%            if(m3>set_temp)
%              set_temp=m3;
%              index=i3;
%            end
%     if index== label(i)
%              predict1(i)=label(i);
%     end
%     list=[T1.labels(i), T2.labels(i),T3.labels(i)];
%      cap=unique(list);
%     res= histc(list,cap);
%   [v,indx]= max(res);
%        c1(i) =cap(indx);
%       if ( label(i)==c1(i))
%          c=c+1;
%       end
% 
%    %end
% end
% fprintf(' \t \t accuracy of max rule:%3f \n',  mean(label==predict1'));
% S.majority = mean(label==c1'); 
% S.maxrule = mean(label==predict1');
% %%  sum rule performance,
%  
% tic
% count2=0;  
%   for i=1:imglist
%          
%         m_majr(i,:)= t1(i,:)+t2(i,:)+t3(i,:)   ;   
%  
%      [value, index]= max(m_majr(i,:));
%       predict2(i)=index;
%    if index == label(i)
%      count2=count2+1;
%   end
%  
%   end
% 
% S.sumrule= mean(label==predict2'); 
% fprintf('sum_rule: %2f \n', S.sumrule*100);
% toc
% %% product rule
% count3=0;  
%   for i=1:imglist
%          
%         m_majr(i,:)= t1(i,:).*t2(i,:).*t3(i,:)  ;   
%  
%      [value, index]= max( m_majr(i,:));
%       predict3(i)=index;
%    if index == label(i)
%      count3=count3+1;
%   end
%  
%   end
% 
% S.productrule= mean(label==predict3');
% fprintf('product_rule: %2f \n', S.productrule*100);
% toc
% %%
% [S.product.confmat, S.product.prec, S.product.recall, S.product.fscore] = prec_recall(double(label),predict3')
% 
% % %
% %   confmat = confusionmat(label,c1')
% % % %
% %  plotConfMat(confmat);
% % % %
% % % % %confmat = i;
% % % %
% % %
%    plotConfMat(S.confmat, {'bkgGnd','Box','Corner','diagBkgRL','Ground', 'groundDiagBkgRL','noDepth','personBkg', 'sidewalRL', 'skyBkgGnd','skyGnd','tablePersonBkg', ''});
% % %
% xtickangle(45);
% ytickangle(0);
% 
% % %
% %
end
function i=checkclass(label)

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