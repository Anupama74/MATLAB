clc;
close all;
clear all;

load 'Libri_features.mat';
m=FAR;
n=FRR;
%% DET and EER

figure(1); grid on;hold on;
l1 = [m;n];
plot(n,m,'-bo','LineWidth',1.3);
x=0:100;y=0:100;
l2 = [x;y];
plot(x,y,'r','LineWidth',1.3)
p= InterX (l1,l2);
EER = p(1)
label1 = {'EER='};
label = {num2str(EER)};
plot(p,p,'k+','LineWidth',2);
text(p,p,label1,'VerticalAlignment','top','HorizontalAlignment','right'...
                 ,'Fontsize',16);
text(p,p,label,'VerticalAlignment','top','HorizontalAlignment','left'...
    ,'Fontsize',16);

xlabel('FAR','Fontsize',16); ylabel('FRR','Fontsize',16);
title('DET CURVE','Fontsize',16);

%% Thresholding: FAR,FRR and EER
threshold=[60 65 70 75 79 80 81 82 83 85 87 89 91 92 93];
x1=n;
y= 1:length(n);
figure(2)
plot(y,x1,'-ro','LineWidth',1);   %%FRR

hold on;
x2=m;
plot(y,x2,'-ko','LineWidth',1);   %FAR

x=TSR;
plot(y,x,'-bo','LineWidth',1);%TSR 

far = [x2;y];
frr = [x1;y];
q = InterX (far,frr);
p1 = q(1);
p2 = q(2);
label1 = {'EER='};
label = {num2str(p1)};
plot(p2,p1,'b*','LineWidth',1.5);
text(p2,p1,label1,'VerticalAlignment','top','HorizontalAlignment','right','Fontsize',16);
text(p2,p1,label,'VerticalAlignment','top','HorizontalAlignment',...
                   'left','Fontsize',16);
set(gca, 'XTick', 1:length(y),'Fontsize',16)
set(gca,'XTickLabel',{threshold},'Fontsize',16);
xlabel('Threshold Values','Fontsize',16);
ylabel('Error in %','Fontsize',16);
title('FAR/FRR/TSR variation','Fontsize',16);
axis([1 15 0 100]);
grid on;
legend('FRR','FAR','TSR');

Cm=1; Pt=0.01; Cfa=1;   %acc. to NIST EVALUATION PLAN 2016
min_DCF =min(Cm*n(y)*Pt + Cfa*m(y)*(1-Pt))

figure;grid on;hold on
plot(FAR,(1-FRR),'-ko','LineWidth',2)
xlabel('1-FRR','Fontsize',16);
ylabel('FAR','Fontsize',16);
title('Receiver operating characteristic','Fontsize',16);



