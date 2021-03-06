sjn='/gpfs01/sirota/home/gerrit/data/';
FileBase='g09-20120330';
FreqBins=[60 120];%[30 120];
% BurstShanks=[41:48,63];% channels, burst cluseter
HP=[41:48,63]';%33:40
nhp=length(HP);
EC=10;
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

par.width=.3;
Btitle={'EC to HP','HP to EC'};
t=([1:nlag]-nlag+1)*stp;
x=t;
y=1:nhp;

nRes=AllBursts.BurstTime(AllBursts.BurstChan<=8 & AllBursts.BurstChan>=5 ...
    & AllBursts.BurstFreq>55 & AllBursts.BurstFreq<130);
nb=length(nRes);
fprintf('\n you have %d bursts',nb);

%%

% tt=[1:2:40]-40;
tRes=nRes-randi(round(1250/65));
% tRes=bsxfun(@plus,nRes(nRes>=2.00*10^5 & nRes<=2.24*10^5),tt);
nbs=size(tRes,1);
% time=bsxfun(@plus,[1:nbs]'*100,tt);
% time=time(:);
% tRes=tRes(:);
% figure;hist(tRes,500)
nlag=10;
oci=zeros(nlag,4,3,9);
bss=zeros(nbs,200);
for k=1:200
[~,bss(:,k)]=sort(rand(nbs,1));
end
bss=bss-1;
for k=1:9
filtLFP_temp = lfp(:,[k,1+nhp]);
fLFP=fangle(filtLFP_temp(2:end,:))-fangle(filtLFP_temp(1:(end-1),:));
if k<7
    dch=k+2;
else
    dch=k-2;
end
dd=fangle(lfp(2:end,dch))-fangle(lfp(1:(end-1),dch));
for n=1:nlag
    %             pl(k,n,m)=fangle(filtLFP_temp(tRes-stp*(nlag-n+1),2))'*fangle(filtLFP_temp(tRes,1))/nb;
    %             if n<nlag(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))(Clu<=FreqBins(k,2))
    X=filtLFP_temp(tRes-stp*(nlag-n+1),2);
    Y=filtLFP_temp(tRes,1);
    Z=filtLFP_temp(tRes-stp*(nlag-n+1),1);
    a=abs(fLFP(tRes-stp*(nlag-n+1),2));
    b=abs(fLFP(tRes,1));
    c=abs(fLFP(tRes-stp*(nlag-n+1),1));
                oci(n,:,1,k)=...
                    mKCIcausal_new(a,b,[c,abs(dd(tRes-stp*(nlag-n+1)-1)),real(Z)-real(filtLFP_temp(tRes-stp*(nlag-n+1)-1,1))],par,bss,0);%abs(X),abs(Y),abs(Z)
                oci(n,:,2,k)=...
                    mKCIcausal_new(a,b,[c,real(Z)-real(filtLFP_temp(tRes-stp*(nlag-n+1)-1,1))],par,bss,0);%
                oci(n,:,3,k)=...
                    mKCIcausal_new(fangle(X),fangle(Y),[fangle(Z),abs(dd(tRes-stp*(nlag-n+1)-1)),real(Z)-real(filtLFP_temp(tRes-stp*(nlag-n+1)-1,1))],par,bss,0);%


%                     KCIcausal_new(fangle(X),fangle(Y),[fangle(Z),time],par,0,0);%
% %                 pci(k,n,m)=oci(1);
% %                 pst(k,n,m)=oci(2);
% %                 cst(k,n,m)=oci(3);
% %                 cci(k,n,m)=oci(5);
% %                 cpap(k,n,m)=oci(7);
% %     condition on time
%     [oci(n,:,2,k), ~]=...
%         KCIcausal_new(real(X),real(Y),real(Z),par,0,0);%[Z,-rRes]
% %     pci(k,n,m+2)=oci(1);
% %     pst(k,n,m+2)=oci(2);
% %     cst(k,n,m+2)=oci(3);
% %     cci(k,n,m+2)=oci(5);
% %     cpap(k,n,m+2)=oci(7);
% [oci(n,:,3,k), ~]=...
%         KCIcausal_new(abs(X),abs(Y),abs(Z),par,0,0);%[Z,-rRes]
    % TE
    %             [nte(k,n,m), me(k,n,m), ste(k,n,m), pval(k,n,m),~, ~, ~, ~, ~]=nTE(Y,X,Z,400);
    fprintf('*')
end
end
figure(3)
for m=1:3
    subplot(1,3,m)
plot(sq(oci(:,4,m,:)))
end
figure(4)
for m=1:3
    subplot(1,3,m)
plot(sq(oci(:,1,m,:)))
end
legend
figure(13)
for m=1:3
    subplot(1,3,m)
plot(sq(oci(:,3,m,:)))
end
figure(14)
for m=1:3
    subplot(1,3,m)
plot(sq(oci(:,2,m,:)))
end
save([myfilename, num2str(EC), 'Shank', num2str((HP(1)-25)/8), 'r.mat'],'oci','FreqBins','bss','HP','EC','nRes','tRes')
legend