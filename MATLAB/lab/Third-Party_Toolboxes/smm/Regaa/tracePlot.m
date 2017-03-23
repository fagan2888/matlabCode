function tracePlot(fileName,time,timewindow,numChan,chanMat,figNum,winHeight)

videoLimits = [368 240];

if ~exist('timewindow', 'var') | isempty(timewindow),
    timewindow = 1; % in seconds
end

eegsamp = 1250; % samples/sec

step = 1;

bps=2;
infoStruct = dir(fileName);
numSamples = infoStruct.bytes/numChan/bps;

figure(figNum)
time = time-timewindow/2; % in second
for i=1:size(chanMat,1)
    for j=1:size(chanMat,2)
        if time+timewindow < numSamples/eegsamp & time> 0
            %fprintf('%i %i %i %i %i\n',i,j,size(chanMat,1),size(chanMat,2),(i-1)*size(chanMat,2) + j)
            subplot(size(chanMat,1),size(chanMat,2),(i-1)*size(chanMat,2) + j)
            
            eeg = bload(fileName,[numChan timewindow*eegsamp], round(time*eegsamp)*numChan*bps,'int16');
            kloogFactor = mod(floor((time+timewindow)*eegsamp)-floor(time*eegsamp),eegsamp-1);
            plot([floor(time*eegsamp)+kloogFactor:floor((time+timewindow)*eegsamp)]./eegsamp, eeg(chanMat(i,j),:));
            hold on;

            if ~exist('winHeight','var') | isempty(winHeight)
                winHeight = get(gca,'ylim');
                winHeight = [winHeight(1)-abs(winHeight(1)*0.05) winHeight(2)+abs(winHeight(2)*0.05)];
            end

            for k=1:9
                plot(([time time]+k*timewindow/5), winHeight,':', 'color' , [0 0 0]);
            end
            plot([time+timewindow/2 time+timewindow/2],winHeight,'color',[1 0 0]);
            set(gca, 'xlim',[time time+timewindow], 'ylim', winHeight);
            if i~=size(chanMat,1)
                set(gca, 'xtick',[])
            end
            title(['Channel ' num2str(chanMat(i,j))])
        else
            fprintf('INVALID TIME\n')
        end
    end
end
