clc; clear; close all;
x = [1 1; 1 -1; -1 -1; -1 1];
y = [-1; 1; -1; -1];
fa = @(x) mySign(x(:,1));
fb = @(x) mySign(x(:,1)-2);
fc = @(x) -1*mySign(x(:,1));
fd = @(x) -1*mySign(x(:,2));

et = @(x,D,h) 0.5 - 0.5*sum(D.*y.*h(x));

i=0;
D = zeros(4,5);
%% Round 1
i=i+1;
D(:,i) = ones(4,1)/4;

errs = [et(x,D(:,i),fa); 
        et(x,D(:,i),fb); 
        et(x,D(:,i),fc); 
        et(x,D(:,i),fd)];
h{i} = fa;
e(i) = et(x,D(:,i),h{i});
a(i) = (1/2)*log((1-e(i))/e(i));

i=i+1;
D(:,i) = D(:,i-1).*exp(-a(i-1).*y.*h{i-1}(x));
D(:,i) = D(:,i)/sum(D(:,i));

%% Round 2
errs = [et(x,D(:,i),fa); 
        et(x,D(:,i),fb); 
        et(x,D(:,i),fc); 
        et(x,D(:,i),fd)];
h{i} = fd;
e(i) = et(x,D(:,i),h{i});
a(i) = (1/2)*log((1-e(i))/e(i));

i=i+1;
D(:,i) = D(:,i-1).*exp(-a(i-1).*y.*h{i-1}(x));
D(:,i) = D(:,i)/sum(D(:,i));

%% Round 3
errs = [et(x,D(:,i),fa); 
        et(x,D(:,i),fb); 
        et(x,D(:,i),fc); 
        et(x,D(:,i),fd)];
h{i} = fb;
e(i) = et(x,D(:,i),h{i});
a(i) = (1/2)*log((1-e(i))/e(i));

i=i+1;
D(:,i) = D(:,i-1).*exp(-a(i-1).*y.*h{i-1}(x));
D(:,i) = D(:,i)/sum(D(:,i));

%% Round 4
errs = [et(x,D(:,i),fa); 
        et(x,D(:,i),fb); 
        et(x,D(:,i),fc); 
        et(x,D(:,i),fd)];
h{i} = fa;
e(i) = et(x,D(:,i),h{i});
a(i) = (1/2)*log((1-e(i))/e(i));

i=i+1;
D(:,i) = D(:,i-1).*exp(-a(i-1).*y.*h{i-1}(x));
D(:,i) = D(:,i)/sum(D(:,i));