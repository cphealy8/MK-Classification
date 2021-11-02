clc; clear; close all;
%% Input
x1 = [zeros([1 4]) ones([1 4])]';
x2 = [0 0 1 1 0 0 1 1]';
x3 =[repmat([0 1],[1 4])]';

%% Part A
dT = table(x1,x2,x3);
dT.lab = double((~x1 | x2 | ~x3));
labT = dT.lab==1;
labF = dT.lab==0;

figure
hold on
plot3(dT.x1(labT),dT.x2(labT),dT.x3(labT),'.r','MarkerSize',25)
plot3(dT.x1(labF),dT.x2(labF),dT.x3(labF),'ob','MarkerSize',10,'LineWidth',2)
hold off
grid on
view(60,30)
xlabel('x1')
ylabel('x2')
zlabel('x3')
legend('True','False')

%
p = [0 0 1];
q = [1 0 0];
r = [1 1 1];

pq = q - p;
pr = r - p;

w = -1*cross(pq,pr);
b = 1.5;
y = mySign([x1 x2 x3]*w'+b);
%% Part B
clear dT
dT = table(x1,x2,x3);
dT.lab = double(((x1 | x2) & x3));
labT = dT.lab==1;
labF = dT.lab==0;

figure
hold on
plot3(dT.x1(labT),dT.x2(labT),dT.x3(labT),'.r','MarkerSize',25)
plot3(dT.x1(labF),dT.x2(labF),dT.x3(labF),'ob','MarkerSize',10,'LineWidth',2)
hold off
grid on
view(60,30)
xlabel('x1')
ylabel('x2')
zlabel('x3')
legend('True','False')

%
p = [0 0 1];
q = [0 1 0.5];
r = [1 1 1];

pq = q - p;
pr = r - p;

w = [1 1 2];
b = -2.5;
wx = [x1 x2 x3]*w';
y = mySign(wx+b);
%% Part C
clear dT
dT = table(x1,x2,x3);
dT.lab = double(((x1 & (~x2)) | (~x3)));
labT = dT.lab==1;
labF = dT.lab==0;

figure
hold on
plot3(dT.x1(labT),dT.x2(labT),dT.x3(labT),'.r','MarkerSize',25)
plot3(dT.x1(labF),dT.x2(labF),dT.x3(labF),'ob','MarkerSize',10,'LineWidth',2)
hold off
grid on
view(60,30)
xlabel('x1')
ylabel('x2')
zlabel('x3')
legend('True','False')

w = [1 -1 -2];
b = 1.5;
wx = [x1 x2 x3]*w';
y = mySign(wx+b);
%% Part D
clear dT
dT = table(x1,x2,x3);
dT.lab = double(xor(x1,xor(x2,x3)));
labT = dT.lab==1;
labF = dT.lab==0;

figure
hold on
plot3(dT.x1(labT),dT.x2(labT),dT.x3(labT),'.r','MarkerSize',25)
plot3(dT.x1(labF),dT.x2(labF),dT.x3(labF),'ob','MarkerSize',10,'LineWidth',2)
hold off
grid on
view(60,30)
xlabel('x1')
ylabel('x2')
zlabel('x3')
legend('True','False')

%% Part E
clear dT
dT = table(x1,x2,x3);
dT.lab = double((x1 & (~x2) & x3));
labT = dT.lab==1;
labF = dT.lab==0;

figure
hold on
plot3(dT.x1(labT),dT.x2(labT),dT.x3(labT),'.r','MarkerSize',25)
plot3(dT.x1(labF),dT.x2(labF),dT.x3(labF),'ob','MarkerSize',10,'LineWidth',2)
hold off
grid on
view(60,30)
xlabel('x1')
ylabel('x2')
zlabel('x3')
legend('True','False')

w = [1 -1 1];
b = -1.5;
wx = [x1 x2 x3]*w';
y = mySign(wx+b);