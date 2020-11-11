function [S]=calculate_scorefusion_ELM_resnet(en,e0,e1,e2,e3,actual_label)

%% initialize 
label=actual_label; 

tn= (en.predict);
t0= (e0.predict);
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
%%  start majority.
for i=1:length(e1.predict)
    list=[en.predict(i),e0.predict(i),e1.predict(i), e2.predict(i),e3.predict(i)];
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
%% end of majority

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