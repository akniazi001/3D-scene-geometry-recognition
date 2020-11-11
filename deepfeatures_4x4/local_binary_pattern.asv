function [binary_f,E]= local_binary_pattern(img, F,r)
  [Row,Col,K]=size(img); % row and column and K represent color channel  
  
  Row_chunk=floor(Row/(F.M));
  col_chunk=floor(Col/(F.N));  
  F.Row_chunk=Row_chunk;
  F.col_chunk=col_chunk;
  binary_f=[];
  E=[];
  for m=1:Row_chunk:(Row- (Row_chunk-1))     %%% row-N
         
          for n=1:col_chunk:(Col - (col_chunk-1))   %%col-M
                  patch=img(m:m+(Row_chunk-1), n:n+(col_chunk-1),:);
                       
                      lbp = LBP(patch, r);
                      
                     h=hist(lbp(:),5)/(length(lbp(:))+0.001);
                      E= cat(1,E, (entropy(lbp)));
                      binary_f= cat(1,binary_f, h);
                     
                      
          end
          
   end

end