function [S,f,Serr]=mtspectrumc(data,params)
% Multi-taper spectrum - continuous process
%
% Usage:
%
% [S,f,Serr]=mtspectrumc(data,params)
% Input: 
% Note units have to be consistent. See chronux.m for more information.
%       data (in form samples x channels/trials) -- required
%       params: structure with fields tapers, pad, Fs, fpass, err, trialave
%       -optional
%           tapers (precalculated tapers from dpss, or in the form [NW K] e.g [3 5]) -- optional. If not 
%                                                 specified, use [NW K]=[3 5]
%	        pad		    (padding factor for the FFT) - optional (can take values -1,0,1,2...). 
%                    -1 corresponds to no padding, 0 corresponds to padding
%                    to the next highest power of 2 etc.
%			      	 e.g. For N = 500, if PAD = -1, we do not pad; if PAD = 0, we pad the FFT
%			      	 to 512 points, if pad=1, we pad to 1024 points etc.
%			      	 Defaults to 0.
%           Fs   (sampling frequency) - optional. Default 1.
%           fpass    (frequency band to be used in the calculation in the form
%                                   [fmin fmax])- optional. 
%                                   Default all frequencies between 0 and Fs/2
%           err  (error calculation [1 p] - Theoretical error bars; [2 p] - Jackknife error bars
%                                   [0 p] or 0 - no error bars) - optional. Default 0.
%           trialave (average over trials/channels when 1, don't average when 0) - optional. Default 0
% Output:
%       S       (spectrum in form frequency x channels/trials if trialave=0; in the form frequency if trialave=1)
%       f       (frequencies)
%       Serr    (error bars) only for err(1)>=1

if nargin < 1; error('Need data'); end;
if nargin < 2; params=[]; end;
[tapers,pad,Fs,fpass,err,trialave,params]=getparams(params);
if nargout > 2 && err(1)==0; 
%   Cannot compute error bars with err(1)=0. Change params and run again. 
    error('When Serr is desired, err(1) has to be non-zero.');
end;
data=change_row_to_column(data);
N=size(data,1);
nfft=max(2^(nextpow2(N)+pad),N);
[f,findx]=getfgrid(Fs,nfft,fpass); 
tapers=dpsschk(tapers,N,Fs); % check tapers
J=mtfftc(data,tapers,nfft,Fs);
J=J(findx,:,:);
S=squeeze(mean(conj(J).*J,2));
if trialave; S=squeeze(mean(S,2));end;
if nargout==3; 
   Serr=specerr(S,J,err,trialave);
end;
