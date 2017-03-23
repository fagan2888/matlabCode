function [mA,mW,As,Ws,normAs,nWs]=ICsRFbyBS(lfp,w,nbs,tt)
[nt,nch]=size(lfp);
[ncomp,nchw]=size(w);
if nt<nch
    lfp=lfp';
    [nt,nch]=size(lfp);
end
if nchw~=nch
    if ncomp==nch
        w=w';
        ncomp=size(w,1);
    else
        error('data and unmixing matrix dimention mismatch.')
    end
end
if isempty(nbs);nbs=20;end
if isempty(tt);tt=nt-fix(nt/nbs);end
W=cell(nbs,1);
A=cell(nbs,1);
J=zeros(nbs,1);
for k=1:nbs
    [~,st]=sort(rand(nt,1));
    [~, A{k}, W{k}, J(k)]=wKDICA(lfp(st(1:tt),:)',ncomp,0,0,0);%
end
[As,Ws,normAs,nWs]=ClustICbasic(pinv(w),A,W);
mA=normAs{1};
mW=nWs{1};
for k=2:nbs
mA=mA+normAs{k};
mW=mW+nWs{1};
end
mA=mA/nbs;
mW=mW/nbs;
fprintf('-')