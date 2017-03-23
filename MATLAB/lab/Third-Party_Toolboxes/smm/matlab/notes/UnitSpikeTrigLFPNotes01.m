badChan = load('../ChanInfo/BadChan.eeg.txt')
clu = load('sm9608_191.clu.4');
res = load('sm9608_191.res.4');
eeg = readmulti('sm9608_191_LinNearCSD121.csd',72);
clu = load('sm9608_197.clu.4');
res = load('sm9608_197.res.4');
badChan = load('../ChanInfo/BadChan_LinNearCSD121.csd.txt')
eeg = readmulti('sm9608_197_LinNearCSD121.csd',72);
chanMat = LoadVar('../ChanInfo/ChanMat_LinNearCSD121.csd')
% LoadVar('../ChanInfo/ChanMat.eeg')
chanMat  = chanMat(:,[3,4])

datSamp = 20000;
eegSamp = 1250;
winLen = 250;
selRes = res(clu(2:end)==2);
selRes = res(clu(2:end)==2 & res>30*datSamp & res<180*datSamp);
eegMeanSeg = cell(size(chanMat));
eegCount = zeros(size(chanMat));
for j=1:size(chanMat,1)
    for k=1:size(chanMat,2)
        for m=1:length(selRes)
            win = [ceil(selRes(m)/datSamp*eegSamp - winLen*eegSamp/1000/2):...
                floor(selRes(m)/datSamp*eegSamp + winLen*eegSamp/1000/2)];
            if all(win>0) & all(win<size(eeg,1))
                if isempty(eegMeanSeg{j,k})
                    eegMeanSeg{j,k} = zeros(size(win'));
                end
                eegMeanSeg{j,k} = eegMeanSeg{j,k} + ...
                    eeg(win(1:floor(winLen*eegSamp/1000)),chanMat(j,k));
                eegCount(j,k) = eegCount(j,k) + 1;
            end
        end
    end
end
figure
for j=1:size(chanMat,1)
    for k=1:size(chanMat,2)
        if isempty(find(chanMat(j,k)==badChan))
        subplot(size(chanMat,1),size(chanMat,2),(j-1)*size(chanMat,2)+k);
        plot(([1:length(eegMeanSeg{j,k})]-length(eegMeanSeg{j,k})/2)/1250*1000,...
            eegMeanSeg{j,k}/eegCount(j,k))
        title(num2str(chanMat(j,k)));
        set(gca,'xlim',[-length(eegMeanSeg{j,k})/2/1250*1000 length(eegMeanSeg{j,k})/2/1250*1000])
        set(gca,'ylim',[-1000 1000])
        if chanMat(j,k) ==30
            hold on
            plot(0,500,'r*')
        end
        end
    end
end
