function cost=costANNPso(xx,network,Xtr,Ytr)
% Ara fonksiyonumuz hesaplamay� yap�yor
cost=zeros(size(xx,1),1);
for i=1:size(xx,1)
x=xx(i,:);
newtwork2=creatnet(x,network);
Netytr=sim(newtwork2,Xtr);
% Mean Square Error(Hatalar�n ortalama kareleri)
c=mse(Netytr-Ytr);
cost(i,1)=c;
end
end