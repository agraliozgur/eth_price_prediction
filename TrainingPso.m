function Newnetwork=TrainingPso(network,Xtr,Ytr)
    % Maliyet fonksiyonumuz
    % Ger�ek de�er ile tahmin edilen deper aras�ndaki hata fonksiyonudur.
    costfunction=@costANNPso;
    
    % Giri� A��rl�k de�erlerimiz 
    % Rastgele olu�turulan birebir matrix de�erleri ve say�s�
    IW=network.IW{1,1}; IWnum=numel(IW);
    
    % Katman A��rl�klar� 
    LW=network.LW{2,1}; LWnum=numel(LW);
 
    % Bias de�erlerimiz
    b1=network.b{1,1};  b1num=numel(b1);
    b2=network.b{2,1};  b2num=numel(b2);

    % Toplam parametre de�erleri hesaplan�yor
    toplamparams=IWnum+LWnum+b1num+b2num;
    nvar=toplamparams;
    varsize=[1 nvar];
    % -1 ile 1 lik paremetre say�s� kadar matrix olu�turuluyor  
    varmin=-1*ones(1,toplamparams);
    varmax=1*ones(1,toplamparams);
    


    %% pso parameters
    % iterasyon belirleniyor
    maxit=200;
    % Havuz b�y�kl��� belirleniyor
    npop=10;
    % Sabit Katsay�lar
    w=2;
    wdamp=0.99;
    c1=1; 
    c2=1; 

    %% initialization  
    % Bos durumlar setleniyor
    bos_parca.pozisyon=[];
    bos_parca.velocity=[];
    bos_parca.cost=[];
    bos_parca.best.pozisyon=[];
    bos_parca.best.cost=[];
    Globalbest.pozisyon=[];
    Globalbest.cost=inf;
    
    parca=repmat(bos_parca,npop,1);
    % En iyi sonu� bulunuyor
    for i=1:npop
        parca(i).pozisyon=unifrnd(varmin,varmax,varsize);
        disp(parca(i).pozisyon);
        parca(i).cost=costfunction(parca(i).pozisyon,network,Xtr,Ytr);

        parca(i).valocity=zeros(varsize);

        parca(i).best.pozisyon=parca(i).pozisyon;
        parca(i).best.cost=parca(i).cost;
         if parca(i).cost<Globalbest.cost
             Globalbest.pozisyon=parca(i).pozisyon;
             Globalbest.cost=parca(i).cost;
         end

    end
    bestcost=zeros(maxit,1);
    %% main loop
    % Her iterasyonda en iyi sonu� bulunuyor
    for it=1:maxit

        for i=1:npop
            parca(i).valocity=w*parca(i).valocity...
               +c1*rand(varsize).*(parca(i).best.pozisyon-parca(i).pozisyon)...
               +c2*rand(varsize).*(Globalbest.pozisyon- parca(i).pozisyon);
            % Bias ve a��rl�klar� g�ncelleniyor
            parca(i).pozisyon=parca(i).pozisyon+parca(i).valocity;
            % Hesaplama yap�l�yor       
            parca(i).cost=costfunction(parca(i).pozisyon,network,Xtr,Ytr);
            % Local en iyi g�ncelleniyor
            if  parca(i).cost<parca(i).best.cost
                parca(i).best.pozisyon=parca(i).pozisyon;
                parca(i).best.cost=parca(i).cost;
                % Genel en iyi g�ncelleniyor
                if parca(i).best.cost<Globalbest.cost
                  Globalbest=parca(i).best;
                end
            end
        end
        bestcost(it)=Globalbest.cost;
        disp(['itration' num2str(it)  ': bestcost ' num2str(bestcost(it))]);
        w=w*wdamp;
    end

%% Sonu�
figure;
plot(bestcost);
Newnetwork=creatnet(Globalbest.pozisyon,network);
end
