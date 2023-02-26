% Temizleme i�lemi yap�l�p veriler okunup haz�rlan�yor
clc;
clear;
close all;
veri_okuma;
data = Close1;
ndata=size(data,1);
train_rate = 0.80;
num_train = round(ndata*train_rate);
% Datam�z� -1 ile 1 aral���na �eviriyoruz
[scaled_data,PS] = mapminmax(data');
scaled_data = scaled_data';
traindata=scaled_data(1:num_train,:);
x_train = [];
y_train = [];

% Veriler 7 g�nl�k haline getiriliyor
n1 = 7;
n2 = n1-1;
for c= n1:num_train
   x_train(c-n2,1:n1) =  traindata(c-n2:c);
   y_train(c-n2,1) = traindata(c);
end
testdata=scaled_data(num_train-n1:end,:);
x_test = [];
for c= n1:length(testdata)
   x_test(c-n2,1:n1) =  testdata(c-n2:c);
end
y_test = data(num_train-1:end);
traininput=x_train';
% traininput = mapminmax(traininput);
traintarget=y_train';
% [traintarget ps] = mapminmax(traintarget) 
testinput=x_test';
% testinput = mapminmax(testinput);
testtarget=y_test';

%mapminmax('reverse',data_scaled(1:5),PS)

%% creat network
% Bir Katman 7 N�rondan olu�an bir sinir a�� modeli olu�turuldu
layers = [7];

Network=newfit(traininput,traintarget,layers);
% Kulllan�lan default parametre de�erleri
% Network.trainParam.lr = 0.01;
% Network.trainParam.goal = 1e-20; % belirli bir yak�nsamada dur 

% A�imiz, e�itim ve test datam�z� PSOya g�nderiliyoruz
enetwork=TrainingPso(Network,traininput,traintarget);

% Sonu�lar tekarar hesaplan�yor e�itilen modelle
sinavtr=sim(enetwork,traininput);
% sinavtr = mapminmax('reverse',sinavtr',PS);
% sinavtr = sinavtr';
hatatr=(sinavtr-traintarget);
% Test datas� ile tahmin i�lemi yap�l�yor
sinavts=sim(enetwork,testinput);
% sinavts = mapminmax('reverse', sinavts , ps) %denormalizasyon
% Test datas� normal veriler ile �al��t�rd���m�zdan denormanize ediyoruz
% B�ylece ger�ek hatalar� g�rebiliyoruz
sinavts = mapminmax('reverse',sinavts',PS);
sinavts = sinavts';
hatats=(sinavts-testtarget);

%% Grafikler
figure;
subplot(2,2,[1 2])
plot(traintarget,'b')
hold on
plot(sinavtr,'r')
legend('gercek','ysadan gelen sonuc')
title('Train Data')
subplot(2,2,3)
plot(hatatr)
legend('hatalar')
subplot(2,2,4)
histfit(hatatr)
legend('histogram')
figure;
subplot(2,2,[1 2])
plot(testtarget,'b')
hold on
plot(sinavts,'r')
legend('gercek','ysadan gelen sonuc')
title('Test Data')
subplot(2,2,3)
plot(hatats)
legend('hatalar')
subplot(2,2,4)
histfit(hatats)
legend('histogram')
