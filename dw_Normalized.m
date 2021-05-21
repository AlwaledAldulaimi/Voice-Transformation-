function [pp,qq,aa,bb]=dw_Normalized(ss,tt,wdtw2)

s=[];t=[];ns=0;nt=0;
s = ss;
t = tt;
if nargin<3
    w=Inf;
end
ns=size(s,1);
nt=size(t,1);
wdtw2=max(wdtw2, abs(ns-nt)); % adapt window size

%% initialization
D=zeros(ns+1,nt+1)+Inf; % cache matrix
D(1,1)=0; 

phi = zeros(ns,nt);
tb = 0; dmax = 0;

%% begin dynamic programming
ns1=0;nt1=0;
ns1=size(ss,2);
nt1=size(tt,2);

D1D=zeros(ns1+1,nt1+1)+Inf; % cache matrix
D1D(1,1)=0;

for i=1:ns
    
    for j=max(i-wdtw2,1):min(i+wdtw2,nt)
    D1D=zeros(ns1+1,nt1+1)+Inf; % cache matrix
    D1D(1,1)=0;
    
    phi1 = zeros(ns1,nt1); tb = 0;
    w1=0;
    w1=max(wdtw2, abs(ns1-nt1)); % adapt window size
    % initialization
    ikji = 0;
    %begin dynamic programming
    for iki=1:ns1   % 35
        sss1 = [];ttt1=[];sss =[];ttt=[];
        for jkj=max(iki-w1,1):min(iki+w1,nt1)
            oost=norm(abs(log10((ss(i,iki)))-(log10((tt(j,jkj))))));
            dmax1=0;tb=0;
            [dmax1,tb]=min( [D1D(iki,jkj+1), D1D(iki+1,jkj), D1D(iki,jkj)] );
            D1D(iki+1,jkj+1) = oost + dmax1;
            phi1(iki,jkj) =tb;
        end
    end
    d_new_cost=D1D(ns1+1,nt1+1);
    i1i=0;j1j=0;pp=[];qq=[];DD=[];
    i1i=ns1;
    j1j=nt1;
    pp=i1i;
    qq=j1j;
    while i1i > 1 & j1j > 1
        tb = phi1(i1i,j1j);
        if (tb == 3)
            i1i = i1i-1;
            j1j = j1j -1;
        elseif (tb == 1)
            i1i = i1i-1;
        elseif (tb == 2)
            j1j = j1j-1;
        else
            error;
        end
        pp = [i1i,pp];
        qq = [j1j,qq];
    end
    aa{i,j} = pp;%a;
    bb{i,j} = qq;%b;
    pp=[];qq=[];
    D1 = 0;
    D1 = d_new_cost;
    D2=0;%area1;
    % DTW decision 
    [dmax, tb] = min( [D(i,j+1), D(i+1,j), D(i,j)] );
    D(i+1,j+1)=D1 + dmax;
    phi(i,j) =tb;
    % find distance score after outter dtw           
    D11(i,j)=D(i+1,j+1);
   end
end
fprintf('\n');
    
i=0;j=0;pp=[];qq=[];DD=[];
% d=D(ns+1,nt+1);
DD= D(2:end,2:end);
i=ns;
j=nt;
pp=i;
qq=j;
D_area=[];
D_area1=0;
while i > 1 & j > 1
  tb = phi(i,j);
  if (tb == 3)
    i = i-1;
    j = j-1;
  elseif (tb == 1)
    i = i-1;
  elseif (tb == 2)
    j = j-1;
  else 
   i;
   j;
   DD(i,j)
   D1(i,j)
   D2(i,j)
   tb
    error;
  end
  pp = [i,pp];
  qq = [j,qq];
end
end

