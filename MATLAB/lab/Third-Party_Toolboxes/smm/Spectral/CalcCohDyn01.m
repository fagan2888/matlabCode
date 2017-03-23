function CalcCohDyn01(fileBaseCell,fileExt,nChan,refChan,freqRange,winLength,aveLength,varargin)
plotChan = DefaultArgs(varargin,{27});

whlSamp = 39.065;
eegSamp = 1250;
bps = 2;


params.tapers = [1.5 2];
params.Fs = eegSamp;
params.fpass = freqRange;

avgfilorder = odd(aveLength*whlSamp);
avgfiltb = ones(avgfilorder,1)/avgfilorder;

for k=1:length(fileBaseCell)
    fileBase = fileBaseCell{k};
    temp = dir([fileBase '/' fileBase fileExt]);
    numSamp = temp.bytes/nChan/bps;

    whl = load([fileBase '/' fileBase '.whl']);
    gammaCoh = [];
    cohSave = [];
    n=0;
    for j=1:size(whl,1)
        time = (j-1)/whlSamp;
        eegTime = clip(round((time-winLength/2)*eegSamp),0,numSamp-round(eegSamp*winLength));
        eeg = bload([fileBase '/' fileBase fileExt],[nChan round(eegSamp*winLength)],eegTime*nChan*bps);
        %             [coh junk1 junk2 junk3 junk4 fo] = coherencyc(repmat(eeg(refChan,:),size(eeg,1),1),eeg,params);
        [coh junk1 junk2 junk3 junk4 fo] = coherencyc(repmat(eeg(refChan,:)',1,size(eeg,1)),eeg',params);
        coh = ATanCoh(coh);

        if ~isempty(cohSave)
            cohSave = cohSave+coh;
        else cohSave = coh;
        end
        n = n+1;

        gammaCoh(j,:) = mean(coh);
    end

    figure
    subplot(1,2,1)
    plot(fo,UnATanCoh(cohSave(:,plotChan)/n))
    set(gca,'ylim',[0 1]);
    
    try
        subplot(1,2,2)
        chanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
        badChan = load(['ChanInfo/BadChan' fileExt '.txt']);
        eegChanMat = LoadVar(['ChanInfo/ChanMat.eeg.mat']);
        plotSize = size(eegChanMat);
        plotOffset = load(['ChanInfo/Offset' fileExt '.txt']);

        imagesc(Make2DPlotMat(UnATanCoh(mean(gammaCoh)),chanMat,badChan,'linear'));
        PlotAnatCurves('ChanInfo/AnatCurves.mat',plotSize,0.5-plotOffset);
        set(gca,'clim',[0.5 1])
        colorbar
    catch
            fprintf('color plot failed\n')
    end
    
    
    smoothGammaCoh = UnATanCoh(Filter0(avgfiltb,gammaCoh));
    outCohFileName = [fileBase '/' fileBase '_' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'...
        '_Win' num2str(winLength) '_Ave' num2str(aveLength) fileExt '_ref' num2str(refChan) '.10000coh'];
    fprintf('\nSaving %s\n', outCohFileName);
    bsave(outCohFileName,10000*smoothGammaCoh','int16');
end
return

    for j=2200:2400
        subplot(1,2,1)
        imagesc(Make2DPlotMat(UnATanCoh(gammaCoh(j,:)),chanMat,badChan,'linear'));
        PlotAnatCurves('ChanInfo/AnatCurves.mat',plotSize,0.5-plotOffset);
        set(gca,'clim',[0.5 1])
        colorbar
        subplot(1,2,2)
        imagesc(Make2DPlotMat(smoothGammaCoh(j,:),chanMat,badChan,'linear'));
         PlotAnatCurves('ChanInfo/AnatCurves.mat',plotSize,0.5-plotOffset);
        set(gca,'clim',[0.5 1])
        colorbar
       pause
    end
    fileBase = 'sm9603m2_237_s1_281';
    coh2 = ATanCoh(coh);
    cd(fileBase)
    goodWhl = LoadMazeTrialTypes(fileBase);
    cd ..
    goodInd = goodWhl(:,1)~=-1;
gammaCoh = (coh2-repmat(mean(coh2(:,goodInd),2),1,size(coh2,2)))...
    ./repmat(std(coh2(:,goodInd),[],2),1,size(coh2,2));
    for j=2000:length(gammaCoh)
        imagesc(Make2DPlotMat(gammaCoh(:,j),chanMat,badChan,'linear'));
        PlotAnatCurves('ChanInfo/AnatCurves.mat',plotSize,0.5-plotOffset);
        set(gca,'clim',[-3 3])
        colorbar
       pause
    end

    gammaCoh = UnATanCoh(coh2)-UnATanCoh(repmat(mean(coh2(:,goodInd),2),1,size(coh2,2)));

    for j=2000:length(gammaCoh)
        imagesc(Make2DPlotMat(gammaCoh(:,j),chanMat,badChan,'linear'));
        PlotAnatCurves('ChanInfo/AnatCurves.mat',plotSize,0.5-plotOffset);
        set(gca,'clim',[-0.1 0.1])
        set(gca,'clim',[-0.1 0.1])
        colorbar
       pause
    end