function [yo, fo, to]=mtcsg(varargin);
%function [yo, fo, to]=mtcsg(x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers);
% Multitaper Time-Frequency Cross-Spectrum (cross spectrogram)
% function A=mtcsg(x,nFFT,Fs,WinLength,nOverlap,NW,nTapers)
% x : input time series
% nFFT = number of points of FFT to calculate (default 1024)
% Fs = sampling frequency (default 2)
% WinLength = length of moving window (default is nFFT)
% nOverlap = overlap between successive windows (default is WinLength/2)
% NW = time bandwidth parameter (e.g. 3 or 4), default 3
% nTapers = number of data tapers kept, default 2*NW -1
%
% output yo is yo(f, t)
%
% If x is a multicolumn matrix, each column will be treated as a time
% series and you'll get a matrix of cross-spectra out yo(f, t, Ch1, Ch2)
% NB they are cross-spectra not coherences. If you want coherences use
% mtcohere

% Original code by Partha Mitra - modified by Ken Harris
% Also containing elements from specgram.m

% default arguments and that
[x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers] = mtparam(varargin);
winstep = WinLength - nOverlap;


nChannels = size(x, 2);
nSamples = size(x,1);

% check for column vector input
if nSamples == 1 
	x = x';
	nSamples = size(x,1);
	nChannels = 1;
end;

% calculate number of FFTChunks per channel
nFFTChunks = round(((nSamples-WinLength)/winstep));
% turn this into time, using the sample frequency
t = winstep*(0:(nFFTChunks-1))'/Fs;

% allocate memory now to avoid nasty surprises later
y=complex(zeros(nFFT, nFFTChunks, nChannels, nChannels)); % output array
Periodogram = complex(zeros(nFFT, nTapers, nChannels, nFFTChunks)); % intermediate FFTs
Temp1 = complex(zeros(nFFT, nTapers, nFFTChunks));
Temp2 = complex(zeros(nFFT, nTapers, nFFTChunks));
Temp3 = complex(zeros(nFFT, nTapers, nFFTChunks));
eJ = complex(zeros(nFFT, nFFTChunks));

% calculate Slepian sequences.  Tapers is a matrix of size [WinLength, nTapers]
[Tapers V]=dpss(WinLength,NW,nTapers, 'calc');

% New super duper vectorized alogirthm
% compute tapered periodogram with FFT 
% This involves lots of wrangling with multidimensional arrays.

TaperingArray = repmat(Tapers, [1 1 nChannels]);
for j=1:nFFTChunks
	Segment = x((j-1)*winstep+[1:WinLength], :);
	if (~isempty(Detrend))
		Segment = detrend(Segment, Detrend);
	end;
	SegmentsArray = permute(repmat(Segment, [1 1 nTapers]), [1 3 2]);
	TaperedSegments = TaperingArray .* SegmentsArray;
						
	Periodogram(:,:,:,j) = fft(TaperedSegments,nFFT);
end	
	
% Now make cross-products of them to fill cross-spectrum matrix
for Ch1 = 1:nChannels
	for Ch2 = Ch1:nChannels % don't compute cross-spectra twice
		Temp1 = reshape(Periodogram(:,:,Ch1,:), [nFFT,nTapers,nFFTChunks]);
		Temp2 = reshape(Periodogram(:,:,Ch2,:), [nFFT,nTapers,nFFTChunks]);
		Temp2 = conj(Temp2);
		Temp3 = Temp1 .* Temp2;
		eJ=sum(Temp3, 2);
		y(:,:, Ch1, Ch2)= eJ/nTapers;
		
		% for off-diagonal elements copy into bottom half of matrix
		if (Ch1 ~= Ch2)
			y(:,:, Ch2, Ch1) = conj(eJ) / nTapers;
		end
	end
end

% set up f and t arrays
if ~any(any(imag(x)))    % x purely real
	if rem(nFFT,2),    % nfft odd
		select = [1:(nFFT+1)/2];
	else
		select = [1:nFFT/2+1];
	end
	y = y(select,:,:,:);
else
	select = 1:nFFT;
end

f = (select - 1)'*Fs/nFFT;

% we've now done the computation.  the rest of this code is stolen from
% specgram and just deals with the output stage

if nargout == 0
	% take abs, and use image to display results
    newplot;
    for Ch1=1:nChannels, for Ch2 = 1:nChannels
    	subplot(nChannels, nChannels, Ch1 + (Ch2-1)*nChannels);
	    if length(t)==1
	        imagesc([0 1/f(2)],f,20*log10(abs(y(:,:,Ch1,Ch2))+eps));axis xy; colormap(jet)
	    else
	        imagesc(t,f,20*log10(abs(y(:,:,Ch1,Ch2))+eps));axis xy; colormap(jet)
	    end
	end; end;
    xlabel('Time')
    ylabel('Frequency')
elseif nargout == 1,
    yo = y;
elseif nargout == 2,
    yo = y;
    fo = f;
elseif nargout == 3,
    yo = y;
    fo = f;
    to = t;
end