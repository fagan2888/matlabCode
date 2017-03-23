% clear all
% close all
% first of all, I will try mEC3 to all HP layers during MEC bursts
sjn='/gpfs01/sirota/home/gerrit/data/';
FileBase='g09-20120330';
FreqBins=[60 120];%[30 120];
BurstShanks=[41:48,63];% channels, burst cluseter
HP=[53,35]';
nhp=length(HP);
EC=[17:32]';
nec=length(EC);
BG=[17 22; 21 24; 25 29; 28 32];
myfilename=mfilename;
cd ~/data/g09_20120330/
load('g09_20120330.RUN3.Burst4Info.[14-250].all.mat')
FS = Par.lfpSampleRate;

cd([sjn, FileBase])
lfp= LoadBinary([FileBase '.lfp'],[HP;EC],Par.nChannels,2,[],[],Period)';

cd ~/data/g09_20120330/
wn = FreqBins/(FS/2);
[z, p, kk] = butter(4,wn,'bandpass');
[b, a]=zp2sos(z,p,kk);
% sos=zp2sos(z,p,kk);
% fltLFP=sosfilt(sos,lfp);

% [rho,pval] = partialcorr(zscore(fltLFP(:,[2,3,5,7,9,10])));
% yy=fltLFP'*fltLFP;
% T=svd(yy);
lfp = filtfilt(b, a, lfp);
lfp=hilbert(lfp);

nlag=10;
cl=ceil(FS/60);
stp=2;

pl=zeros(nhp,nlag,4);
nte=zeros(nhp,nlag,4);
me=zeros(nhp,nlag,4);
ste=zeros(nhp,nlag,4);
pval=zeros(nhp,nlag,4);
pci=zeros(nhp,nlag,4,2);
pst=zeros(nhp,nlag,4,2);
cst=zeros(nhp,nlag,4,2);
cci=zeros(nhp,nlag,4,2);
cpap=zeros(nhp,nlag,4,2);
par.width=.3;
Btitle={'EC to HP_p','HP_p to EC','EC to HP_d','HP_d to EC'};
t=([1:nlag]-nlag+1)*stp;
x=t;
y=1:nec;
nsbs=2500;
randpm=zeros(nsbs,4);
obgn=0;
for k=1:nec
    if k<12
        bgn=ceil(k/4);
    else
        bgn=4;
    end
    if bgn~=obgn
    nRes=AllBursts.BurstTime(AllBursts.BurstChan<=BG(bgn,2) & AllBursts.BurstChan>=BG(bgn,1) ...
        & AllBursts.BurstFreq>55 & AllBursts.BurstFreq<125);
    nb=length(nRes);
    
    fprintf('\n you have %d bursts',nb);
    
    [~,tpm]=sort(rand(nb,1));
    tpm=tpm(1:nsbs);
    randpm(:,bgn)=tpm;
    nRes=nRes(tpm);
    obgn=bgn;
    end
    rRes=randi(cl,nsbs,1);
    tRes=nRes-rRes;%repmat(nRes,2,1)-randi(cl,2*length(nRes),1);
%     filtLFP_temp = lfp(:,[1,k+nhp,2]);% hp, ec
    for m=1:4
        switch m
            case 1
                filtLFP_temp = lfp(:,[1,k+nhp,2]);
            case 2
                filtLFP_temp = lfp(:,[k+nhp,1,2]);
            case 3
                filtLFP_temp = lfp(:,[2,k+nhp,1]);
            case 4
                filtLFP_temp = lfp(:,[k+nhp,2,1]);
        end
        for n=1:nlag
            pl(k,n,m)=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),2))'*fangle(filtLFP_temp(tRes,1))/nb;
            %             if n<nlag(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))
            X=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),2));
            Y=fangle(filtLFP_temp(tRes,1));
            Z=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),1));
            Z2=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),3));
            
            [oci, ~]=...
                KCIcausal_new(X,Y,Z,par,0,0);%
            pci(k,n,m,1)=oci(1);
            pst(k,n,m,1)=oci(2);
            cst(k,n,m,1)=oci(3);
            cci(k,n,m,1)=oci(5);
            cpap(k,n,m,1)=oci(7);
            % condition on time
            [oci, ~]=...
                KCIcausal_new(X,Y,[Z,Z2],par,0,0);%
            pci(k,n,m,2)=oci(1);
            pst(k,n,m,2)=oci(2);
            cst(k,n,m,2)=oci(3);
            cci(k,n,m,2)=oci(5);
            cpap(k,n,m,2)=oci(7);
            % TE
            [nte(k,n,m), me(k,n,m), ste(k,n,m), pval(k,n,m),~, ~, ~, ~, ~]=nTE(Y,X,Z,400);
            fprintf('*')
        end
        fprintf('inv')
        figure(226)
        subplot(2,4,m)
        imagesc(x,y,sq(cci(:,:,m,1)),[0, .05])
        set(gca,'Ytick',y,'Yticklabel',HP)
        title(Btitle{m})
        subplot(2,4,m+4)
        imagesc(x,y,sq(cci(:,:,m,2)),[0, .05])
        set(gca,'Ytick',y,'Yticklabel',HP)
        title([Btitle{m}, '| HP'])
        drawnow
    end
    clear filtLFP_temp
end


cd ~/data/g09_20120330/
datat=sprintf('compLFP%d-%dHz.ec_all_shank-hp.phase.mat',FreqBins);

save(datat,'pci','pst','cst','cci','cpap','nte','me','ste','pval','nRes','Clu','FreqBins','BurstShanks','AllBursts','Btitle','t','myfilename')%['8_9nitry', labels{ln}])% 724all bursts

% for h=1:2
%     figure(225+h)
%     for m=1:2
%         for z=1:nhp
%             subplot(2,nhp,(m-1)*nhp+z)
%             imagesc(x,y,sq(cci(:,z,m,:,h)),[0, .05])
%             set(gca,'Ytick',y,'Yticklabel',EC(:,1))
%             title(['HP channel', num2str(HP(z,1))])
%         end
%     end
%     drawnow
% end