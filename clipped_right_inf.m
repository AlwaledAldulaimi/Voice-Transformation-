function [fname_data_target_record1,es] = clipped_right_inf(data_zoom,winlen,overlap)

a= 0 ;b=[];bb=[];es2=[];ind=[];start_index=0;START=0;END=0;
fname_data_target_record1=[];
es = [];N=0;
N = length(data_zoom);
dif = 0;dif = winlen - overlap;
kk=0;
jj=0;
i = 0;
last = 0;start=0;
while(~last)
   jj=jj+1; 
   start = dif*i;
   if(start + winlen > N)
      kk=kk+1 ;
      winlen = N - start;
      last = 1;
   end
   a= start + (1:winlen);
   b= data_zoom(a);
   bb= b.^2;
   es(i+1) = sum(data_zoom(start + (1:winlen)).^2)/winlen;
   i = i+1;
end
if (any(es) == 1)

es2 = es./sum(es);
% find the interesting information
% find statrt index
thresould_value = 1e-5;
ind  = find(es2 > thresould_value);
k=0;
test_length = 6;
for i = 1 : (length(ind) - test_length)
    k = k+1;
    if k == test_length
        start_index = ind(i-5);
        break
    end
    if (ind(i+1) == ind(i)+1) & (ind(i+2) == ind(i+1)+1)
        continue
    end
    k = 0;
end  
START = dif * start_index;
% find last index
END = dif * ind(end);
fname_data_target_record1 = data_zoom(START:END);
else
fname_data_target_record1 =[];
end


end

