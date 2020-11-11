
%  param_SVMV2=[];

% for  i=1:5
%     M=[];
%            M= strcat('M',num2str(1));
% [trainedClassifier, validationAccuracy,validationScores] = trainClassifierQhoiem(M5)
%  param_SVMV2.M5=validationScores;
%  
param.t1= load('elmLapc_P.mat');
param.t2= load('elmRGB_P.mat');
% param.t3= load('./classes/mywork_propose/T3score.mat');
% param.t4= load('./classes/mywork_propose/T4score.mat');
% param.t5= load('./classes/mywork_propose/T5score.mat');
% param.t6= load('./classes/mywork_propose/T6score.mat');
param.label= load('actual_label.mat');
%   param.t7= load('./classes/mywork_propose/T7score.mat');
%     param.t8= load('./classes/mywork_propose/T8score.mat');


t1= (param.t1.prob)';
t2= (param.t2.prob)';
label=double(string(param.label.YTest));
% t3= param.t3.validationScores;
% t4= param.t4.validationScores;
% t5= param.t5.validationScores;
% t6= param.t6.validationScores;
%   t7= param.t7.validationScores;
%    t8= param.t8.validationScores;
% end
  t1= 0.5*(tanh(0.01*(t1-mean(t1)/std(t1))+1));
% end
 t2= 0.5*(tanh(0.01*(t2-mean(t2)/std(t2))+1));
%;
%         t6=t7;
 imglist=numel(t1(:,1));
  count=0;
  
%   for ii=1:imglist
%       if param.label.label(ii)==param.t1.yt1(ii)
%          
%           count=count+1;
%       end
%   
% %   end
% for ii=1:imglist
%     
%    list = [param.t1.validationPredictions(ii),param.t2.validationPredictions(ii),param.t3.validationPredictions(ii),param.t4.validationPredictions(ii),param.t5.validationPredictions(ii),param.t6.validationPredictions(ii)];
%     
%     cap=unique(list);
%     res= histc(list,cap);
%   [v,indx]= max(res);
%   
%        predict(ii) =cap(indx);
%       if param.label.label(ii)==predict(ii)
%          
%           count=count+1;
%       end
%       
%            
% end
% 
% 
% % images=111;%%%images in metrix
% % class=12;%%classes
% % %%%% using min rules
% accuracy= (count/imglist)*100;
% 
%  Z=zeros(111,1);
%  Z2=Z;
% label= (cell2mat(struct2cell(load('SVM1_label.mat'))));
% 
for i=1:imglist
   % for j=1:clss
   
      [m1,i1] =  max(t1(i,:));
      [m2,i2]=   max(t2(i,:));
%       [m3,i3] =  max(t3(i,:));
%       [m4,i4]=   max(t4(i,:));
%       [m5,i5] =  max(t5(i,:));
%        [m6,i6] =  max(t6(i,:));
%    [m7,i7] =  max(t7(i,:));
%    [m8,i8] =  max(t8(i,:));
       set_temp=-inf;
           if(m1>set_temp)
             set_temp=m1;
             index=i1;
           end
          
            if(m2>set_temp)
             set_temp=m2;
             index=i2;
           end
%             if(m3>set_temp)
%               set_temp=m3;
%               index=i3;
%             end
%             if(m4>set_temp)
%              set_temp=m4;
%               index=i4;
%             end
%            if(m5>set_temp)
%              set_temp=m5;
%              index=i5;
%            end
%              if(m6>set_temp)
%              set_temp=m6;
%              index=i6;
%              end;
%               if(m7>set_temp)
%              set_temp=m7;
%              index=i7;
%               end
%               if(m8>set_temp)
%                 set_temp=m8;
%                 index=i8;
%                end
             
    if index==label(i)
             count=count+1;
    end

   %end 
end
fprintf(' \t \t accuracy of max rule:%3f \n', 100*count/imglist);
%%% compare performance,

% % label= (cell2mat(struct2cell(load('SVM1_label.mat'))));
%     count=0;
% for  i=1:(images)
%    
%     if(Z(i)==label(i))
%         count=count+1;
%     end
%     
%     
% end
% accuracy_max= double(count/double(images));
% 
% 
% m_majr= zeros(images,class);
%   %%% using majoriting voting
count2=0; a=-0.0006;
  for i=1:imglist
   % for j=1:clss
%    if (max(t1(i,:))>=0 | max(t1(i,:))>a ) 
%    m_majr(i,:)=t1(i,:);
%    
%    elseif(max(t2(i,:))>=0 | max(t2(i,:))>a ) 
%    m_majr(i,:)= t2(i,:);
%   elseif(max(t3(i,:))>=0 | max(t3(i,:))> a ) 
%    m_majr(i,:)= t3(i,:);
%    elseif(max(t4(i,:))>=0 | max(t4(i,:))>a ) 
%    m_majr(i,:)= t4(i,:);
%     elseif(max(t5(i,:))>=0 | max(t5(i,:))>a ) 
%    m_majr(i,:)= t5(i,:);
%     elseif(max(t6(i,:))>=0 | max(t6(i,:))>a ) 
%    m_majr(i,:)= t6(i,:);
%    
%     elseif(max(t7(i,:))>=0 | max(t7(i,:))>a ) 
%    m_majr(i,:)= t7(i,:);
%     elseif(max(t8(i,:))>=0 | max(t8(i,:))>a ) 
%    m_majr(i,:)= t8(i,:);
%    else         
      m_majr(i,:)= t1(i,:)+t2(i,:); ; 
%    end
   [value, index]= max( m_majr(i,:)./8);
  predict(i)=index;
  if index ==label(i)
  count2=count2+1;
  end
  
  end
%    %end 
%      count2=0;
%     
% for i=1:(imglist)
%    
%     if(Z2(i)==label(i))
%         count2=count2+1;
%     end
%     
% end

accuracy2_majority= double(count2/double(imglist));
fprintf('max_adaptiverule: %2f \n', accuracy2_majority*100);
