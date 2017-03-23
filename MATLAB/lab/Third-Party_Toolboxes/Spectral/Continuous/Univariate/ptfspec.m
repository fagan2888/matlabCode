function [spec, f, err] = ptfspec(X, tapers, sampling, dn, fk, pad, pval, flag);
%PTFSPEC  Parallel version of TFSPEC
%
% [SPEC, F, ERR] = PTFSPEC(X, TAPERS, SAMPLING, DN, FK, PAD, PVAL, FLAG) 
%
%  Inputs:  X		=  Time series array in [Space/Trials,Time] form.
%	    TAPERS 	=  Data tapers in [K,TIME], [N,P,K] or [N,W] form.
%			   	Defaults to [N,3,5] where N is NT/10
%				and NT is duration of X. 
%	    SAMPLING 	=  Sampling rate of time series X in Hz. 
%				Defaults to 1.
%	    DN		=  Overlap in time between neighbouring windows.
%			       	Defaults to N./10;
%	    FK 	 	=  Frequency range to return in Hz in
%                               either [F1,F2] or [F2] form.  
%                               In [F2] form, F1 is set to 0.
%			   	Defaults to [0,SAMPLING/2]
%	    PAD		=  Padding factor for the FFT.  
%			      	i.e. For N = 500, if PAD = 2, we pad the FFT 
%			      	to 1024 points; if PAD = 4, we pad the FFT
%			      	to 2048 points.
%				Defaults to 2.
%	   PVAL		=  P-value to calculate error bars for.
%				Defaults to 0.05 i.e. 95% confidence.
%
%	   FLAG = 0:	calculate SPEC seperately for each channel/trial.
%	   FLAG = 1:	calculate SPEC by pooling across channels/trials. 
%
%  Outputs: SPEC	=  Spectrum of X in [Space/Trials, Time, Freq] form. 
%	    F		=  Units of Frequency axis for SPEC.
%	    ERR 	=  Error bars in[Hi/Lo, Space, Time, Freq]  
%			   form given by the Jacknife-t interval for PVAL.
% 
%   See also DPSS, PSD, SPECGRAM.

%   Author: Bijan Pesaran, version date 09/28/98.

sX = size(X);
nt = sX(2);              % calculate the number of points
nch = sX(1);               % calculate the number of channels

if nargin < 3 sampling = 1.; end
n = floor(nt./10)./sampling;
if nargin < 2 tapers = [n,3,5]; end
if length(tapers) == 2
   n = tapers(1);
   w = tapers(2);
   p = n*w;
   k = floor(2*p-1);
   tapers = [n,p,k];
%   disp(['Using ' num2str(k) ' tapers.']);
end
if length(tapers) == 3
   tapers(1) = tapers(1).*sampling;  
   tapers = dpsschk(tapers);
end
if nargin < 4 dn = n./10; end
if nargin < 5 fk = [0,sampling./2.]; end
if length(fk) == 1
    fk = [0,fk];
end
if nargin < 6 pad = 2; end
if nargin < 7 pval = 0.05; end
if nargin < 8 flag = 0; end

K = length(tapers(1,:)); 
N = length(tapers(:,1));
if N > nt error('Error: Tapers are longer than time series'); end

% Determine outputs
errorchk = 0;
if nargout > 2 errorchk = 1; end

dn = dn.*sampling;
nf = max(256, pad*2^nextpow2(N+1)); 
nfk = floor(fk./sampling.*nf);
nwin = floor((nt-N)./dn);           % calculate the number of windows
neid = PMI_Size;
eid = [1:neid];

seg = floor([0:neid].*(nt-N)./neid);

f = linspace(fk(1),fk(2),diff(nfk));

if ~flag				% No pooling across trials
    spec = zeros(nch,nwin,diff(nfk));
if ~errorchk				%  Don't estimate error bars
    for id = 1:neid
   	tmp = X(:,seg(id)+1:seg(id+1)+N);
   	status = PMI_Send2(eid(id),tmp);
   	status = PMI_Send2(eid(id),tapers);
        cmd = ['ftmp = tfspec(tmp, tapers, ' num2str(sampling) ...
               ',' num2str(dn./sampling) ',[' num2str(fk(1)) ...
               ',' num2str(fk(2)) '],' num2str(pad) ');'];    
        PMI_IEval(eid(id),cmd);
%        disp(['Computing on engine ' num2str(eid(id))]);
    end
    win = 0;
    for id = 1:neid
        ftmp = PMI_Recv(eid(id),'ftmp');
        spec(:,win+1:win+size(ftmp,2),:) = ftmp;
        win = win+size(ftmp,2);
    end
else 					%  Estimate error bars
   	[ftmp, dum, err_tmp] = dmtspec(tmp, tapers, sampling, fk, pad, pval);
   	spec(ch,win,:) = ftmp;
	err(1,ch,win,:) = err_tmp(1,:);
	err(2,ch,win,:) = err_tmp(2,:);
end
end

if flag					% Pooling across trials
    spec = zeros(nwin,diff(nfk));
    for win = 1:nwin
   	tmp = X(:,win*dn+1:win*dn+N);
if ~errorchk				%  Don't estimate error bars
   	ftmp = dmtspec(tmp, tapers, sampling, fk, pad, pval, flag);
   	spec(win,:) = ftmp;
else					%  Estimate error bars
   [ftmp, dum, err_tmp] = dmtspec(tmp, tapers, sampling, fk, pad, pval,flag); 	
        spec(win,:) = ftmp; 	
        err(1,win,:) = err_tmp(1,:);
	err(2,win,:) = err_tmp(2,:);
end
     end
end







