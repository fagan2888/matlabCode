function  ExampleSpectSel11(fileBaseCell,fileext,nchannels,chans,lowband,highband)
%Fs = 1250;
% lowband = 40;
% highband = 120;
forder = 312;
winLength = 626;
wavParam = 8;
eegSamp = 1250;
whlSamp = 39.065;
posLim = [368 240];
amp = 1000;
vRange = [-10 10];
bitDepth = 16;
analRoutine = 'AlterGood_S0_A0_MR';
numfiles = length(fileBaseCell);
load(['TrialDesig/' 'GlmWholeModel05' '/' analRoutine '.mat'])
chanInfoDir = 'ChanInfo/';
if isempty(chans)
selChanCell = Struct2CellArray(LoadVar([chanInfoDir 'SelChan' fileext '.mat']));
selChanCell = selChanCell([3,5],:);
chans = [selChanCell{:,end}];
selChanNames = selChanCell(:,1);
else
    for j=1:length(chans)
        selChanNames{j} = ['ch' num2str(chans(j))];
    end
end
%filtExt = '_40-120Hz.eeg.filt';
mazePlotSize = 3;
tracePlotWidth = 5;
nHorzSubplots = tracePlotWidth+1;
nSubplots = length(chans)+mazePlotSize;
defaultAxesPosition = [0.1,0.05,0.80,0.90];
firfiltb = fir1(forder,[lowband/eegSamp*2,highband/eegSamp*2]); % band-pass filter
analDir = ['CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win' num2str(winLength) ...
    'wavParam' num2str(wavParam) fileext];

N = winLength;
DJ = 1/18;
S0 = 4;
J1 = round(log2(N/S0)/(DJ)-1.3/DJ);
files = [2];
trials = {2};
% files = [1 2 3 4 5 6 8 9 ];
% trials = {[2 5];...
%          [2 3 7 8];...
%          [1 2 5];...
%          [1];...
%          [1 2];...
%          [1];...
%          [];...
%          [1 4];...
%          [1 2];...
%          };
figure(1)
set(gcf,'name',['GammaSpectExamplesSelected_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '_06'])
set(gcf,'DefaultAxesPosition',defaultAxesPosition);
%for i=files%1:numfiles
for i=1:numfiles
    fileBase = fileBaseCell{i};
    fprintf([fileBase '\n'])
    eegTime = LoadDesigVar(fileBase,analDir,'eegSegTime',trialDesig);
    cwd = pwd;
    cd(fileBase);
    whl = LoadMazeTrialTypes([fileBase ],[1 0 1 0 0 0 0 0 0 0 0 0 0],[1 1 1 1 1 1 1 1 1]);
    cd(cwd);
    eeg = readmulti([fileBase '/' fileBase fileext],nchannels,chans);
    %filt = readmulti([fileBase '/' fileBase filtExt],nchannels,chans);
    %rawTrace = LoadDesigVar(fileBase,analDir,'rawTrace',trialDesig);
    filt = Filter0(firfiltb, eeg); % filter

    fields = fieldnames(eegTime);
    for j=trials{i}
    %for j=1:size(eegTime.(fields{1}),1)
        figure(1)
        clf
        %subplot(nSubplots,1,1:mazePlotSize)
        %plot(whl(:,1),whl(:,2),'color',[0.5 0.5 0.5])
        hold on
        %plotColors = [1 0 0;0 1 0;0 0 1;0 0 0];
        for k=1:length(fields)
            rawEegTimes(k) = eegTime.(fields{k})(j);
        end
        beginRawEEG = min(rawEegTimes);
        endRawEEG = max(rawEegTimes)+winLength;
       
        beginRawWhl = round(beginRawEEG/eegSamp*whlSamp);
        endRawWhl = round(endRawEEG/eegSamp*whlSamp);
        [whlTrialTypes whlMazeLoc] = GetWhlInfoMat([fileBase '/' fileBase]);
        enterDelayWhl = beginRawWhl-1+find(whlMazeLoc(beginRawWhl:endRawWhl,3)==1,1,'first');
        exitDelayWhl = beginRawWhl-1+round(find(whlMazeLoc(beginRawWhl:endRawWhl,5)==1,1,'first')-whlSamp/10);
        goodWhlInd = [beginRawWhl:enterDelayWhl-1 exitDelayWhl:endRawWhl];
                
        enterDelayEEG = round(enterDelayWhl*eegSamp/whlSamp);
        exitDelayEEG = min([rawEegTimes(2) round(exitDelayWhl*eegSamp/whlSamp)]);
        goodEEGInd = [beginRawEEG:enterDelayEEG-1 exitDelayEEG:endRawEEG];
        
        plot(whl(goodWhlInd,1),whl(goodWhlInd,2),'.','color',[0.75 0.75 0.75])

% plan:
% wavlet/log/smooth on full 15 seconds
% chop
% normalize
% plot
% plot limits
        colormap(LoadVar('ColorMapSean6.mat'));
        saveCutWave = [];
        saveWave = [];
        saveCutFilt = [];
        for m=1:length(chans)
                [wave period scale coi] = xwt(eeg(beginRawEEG-winLength:endRawEEG+winLength,m),eeg(beginRawEEG-winLength:endRawEEG+winLength,m),'Pad',1,'DJ',DJ,'S0',S0,'J1',J1);
                fo = 1./period.*eegSamp;
                freqLim = [fo(find(fo>=lowband,1,'last')) fo(find(fo<=highband,1,'first'))];
                %logWave = wave(fo>=lowband & fo<=highband,:);
                smoothWave = [];
                smoothXlen = winLength/3;
                smoothYlen = length(find(fo>=lowband & fo<=highband));
                gaussianX = gausswin(smoothXlen)/sum(gausswin(smoothXlen));
                gaussianY = gausswin(smoothYlen)/sum(gausswin(smoothYlen));

%                 cutWave = wave(:,goodEEGInd-beginRawEEG+1+winLength);
%                 cutWave = 10.*log10(Conv2Trim(gaussianX,gaussianY,cutWave(fo>=lowband & fo<=highband,:)'))';
                
                smoothWave = 10.*log10(Conv2Trim(gaussianX,gaussianY,wave(fo>=lowband & fo<=highband,:)'))';
                cutWave = smoothWave(:,goodEEGInd-beginRawEEG+1+winLength);
                %cutWave = smoothWave(find(fo>=lowband & fo<=highband)+floor(length(gaussianY)/2),goodEEGInd-beginRawEEG+1+winLength+floor(length(gaussianX)/2));
                %cutWave = smoothWave(floor(length(gaussianY)/2)+1:end-floor(length(gaussianY)/2),goodEEGInd-beginRawEEG+1+winLength+floor(length(gaussianX)/2));
                tempFilt = filt(beginRawEEG-winLength:endRawEEG+winLength,m);
                saveCutFilt(m,:) = tempFilt(goodEEGInd-beginRawEEG+1+winLength,:)';
                saveCutWave(m,:,:) = cutWave;
                saveWave(m,:,:) = wave(fo>=lowband & fo<=highband,:);
                subplot(nSubplots,nHorzSubplots,(mazePlotSize+m)*nHorzSubplots-tracePlotWidth:(mazePlotSize+m)*nHorzSubplots-1)
                hold on
                %pcolor(1:size(cutWave,2),fo(fo>=lowband & fo<=highband),cutWave-repmat(mean(cutWave,2),1,size(cutWave,2)));
                %pcolor(1:size(cutWave,2),fo(fo>=lowband & fo<=highband),cutWave-repmat(mean(cutWave,2),1,size(cutWave,2))./repmat(std(cutWave,[],2),1,size(cutWave,2)))
                %pcolor(1:size(cutWave,2),fo(fo>=lowband & fo<=highband),cutWave)
%                 cutWaveOld = cutWave;
% 
                 %cutWave = cutWaveOld;
                 cutWave = cutWave.*repmat(fo(fo>=lowband & fo<=highband)'.^0.15,1,size(cutWave,2));
%                  cla
                pcolor(1:size(cutWave,2),fo(fo>=lowband & fo<=highband),(cutWave...
                    -repmat(mean(cutWave(:)),size(cutWave,1),size(cutWave,2)))...
                    ./repmat(std(cutWave(:)),size(cutWave,1),size(cutWave,2))...
                    );
                shading interp
                set(gca,'clim',[-3 3])
                plot((saveCutFilt(m,:)-mean(saveCutFilt(m,:)))/std(saveCutFilt(m,:))*8+mean([lowband highband]),'color',[0.35 0.35 0.35],'linewidth',1)
                set(gca,'ylim',freqLim,'xlim',[1 size(cutWave,2)])
                text(size(cutWave,2) + 850,mean(freqLim),[num2str(std(saveCutFilt(m,:))/8) ' bits'])
                colorbar
        end
keyboard
        plotColors = 'rrrr';
        yLimits = [-500 500;-1000 1000;-1000 1000;-1500 1500;-1500 1500;-1500 1500];
        for k=1:length(fields)
            %fprintf([fields{k} '\n'])
            figure(1)
            subplot(nSubplots,nHorzSubplots,[k k+nHorzSubplots])
            cla
            hold on
            plot(whl(whl(:,1)>0,1),whl(whl(:,1)>0,2),'.','color',[0 0 0],'markersize',20)
            plot(whl(goodWhlInd,1),whl(goodWhlInd,2),'.','color',[0.5 0.5 0.5],'markersize',20)
            set(gca,'xlim',[0 posLim(1)],'ylim',[0 posLim(2)]);
            beginWhl = round((eegTime.(fields{k})(j))/eegSamp*whlSamp);
            endWhl = round((eegTime.(fields{k})(j)+winLength)/eegSamp*whlSamp);
            plot(whl(beginWhl:endWhl,1),whl(beginWhl:endWhl,2),[plotColors(k) '.'],'markersize',20);

            beginEEG = round(eegTime.(fields{k})(j));
            endEEG = round(eegTime.(fields{k})(j)+winLength-1);

            if k==1
                time = round((eegTime.(fields{k})(j))/eegSamp);
                %fprintf([num2str(time) '\n'])
            end
%             integPow(k,:) = 10*log10(sum(filt(beginEEG:endEEG,:).^2));
            for m=1:length(chans)
               figure(1)
                subplot(nSubplots,nHorzSubplots,(mazePlotSize+m)*nHorzSubplots-tracePlotWidth:(mazePlotSize+m)*nHorzSubplots-1)
                hold on
                if k==1
                    plot([beginEEG-beginRawEEG+1],freqLim(2),['.' plotColors(k)],'markersize',3)
                    plot(endEEG-beginRawEEG+1,freqLim(2),['.' plotColors(k)],'markersize',3)
%                     plot([beginEEG-beginRawEEG+1 beginEEG-beginRawEEG+1],freqLim,['--' plotColors(k)],'linewidth',4)
%                     plot([endEEG-beginRawEEG+1 endEEG-beginRawEEG+1],freqLim,['--' plotColors(k)],'linewidth',4)
                    integPow(k,m) = 10*log10(sum(sum(10.^(saveCutWave(m,:,beginEEG-beginRawEEG+1:endEEG-beginRawEEG+1)/10),3),2));
                    %integPow2(k,m) = 10*log10(sum(sum(saveWave(m,:,beginEEG-beginRawEEG+1:endEEG-beginRawEEG+1),3),2));
                    integPow2(k,m) = 25+10*log10(sum(saveCutFilt(m,beginEEG-beginRawEEG+1:endEEG-beginRawEEG+1).^2));
               else
                    plot(beginEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG,freqLim(2),['.' plotColors(k)],'markersize',3)
                    plot(endEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG,freqLim(2),['.' plotColors(k)],'markersize',3)
%                     plot([beginEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG  beginEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG],freqLim,['--' plotColors(k)],'linewidth',4)
%                     plot([endEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG  endEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG],freqLim,['--' plotColors(k)],'linewidth',4)
                    integPow(k,m) = 10*log10(sum(sum(10.^(saveCutWave(m,:,beginEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG:endEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG)/10),3),2));
                    %integPow2(k,m) = 10*log10(sum(sum(saveWave(m,:,beginEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG:endEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG),3),2));
                    integPow2(k,m) = 25+10*log10(sum(saveCutFilt(m,beginEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG:endEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG).^2));
                end                
%                 plot([plotStart plotStart],freqLim,['--' plotColors(k)])
%                 plot([plotStart+endEEG-beginEEG plotStart+endEEG-beginEEG],freqLim,['--' plotColors(k)])
                set(gca,'ylim',freqLim)
                % set(gca,'ytick',[freqLim(1) mean(freqLim) freqLim(end)]);
                if m==length(chans)
                    xlabel('time');
                end
                if k==length(fields)
                    text(endEEG-exitDelayEEG+2+enterDelayEEG-beginRawEEG + 525,mean(freqLim),selChanNames{m});
                end
                ylabel('Freq');
%                 shading interp
                %subplot(nSubplots,nHorzSubplots,(mazePlotSize+m)*nHorzSubplots)
                %hold on
                %bar([k k+length(fields)+1],[integPow(k,m) integPow2(k,m)],0.2,[plotColors(k)])
                %set(gca,'ylim',[85 110],'xlim',[0 (length(fields)+1)*3])
             end
%                 keyboard
        end
%          keyboard
        reportFigBool = 0;
%         if      (integPow(2,2) > integPow(1,2)) &...
%                 (integPow(2,2) > integPow(3,2)) &...
%                 (integPow(2,2) > integPow(4,2))
%             reportFigBool = [reportFigBool 1];
%         else
%             reportFigBool = [reportFigBool 0];
%         end
%         if      (integPow(4,4) > integPow(1,4)) &...
%                 (integPow(4,4) > integPow(2,4)) &...
%                 (integPow(4,4) > integPow(3,4))
%             reportFigBool = [reportFigBool 1];
%         else
%             reportFigBool = [reportFigBool 0];
%         end
%         if      (integPow(3,5) < integPow(1,5)) &...
%                 (integPow(3,5) < integPow(2,5))
%             reportFigBool = [reportFigBool 1];
%         else
%             reportFigBool = [reportFigBool 0];
%         end
%         if      (integPow(3,6) < integPow(1,6)) &...
%                 (integPow(3,6) < integPow(2,6))
%             reportFigBool = [reportFigBool 1];
%         else
%             reportFigBool = [reportFigBool 0];
%         end
%         if      (integPow(4,6) < integPow(1,6)) &...
%                 (integPow(4,6) < integPow(2,6))
%             reportFigBool = [reportFigBool 1];
%         else
%             reportFigBool = [reportFigBool 0];
%         end
        fprintf([num2str(reportFigBool) ' ' num2str(time) '\n'])
        if reportFigBool(1) %& sum(reportFigBool)>=3
          ReportFigSM(1,[pwd '/NewFigs/GammaTrialExamples3/'],[],[],{{[fileBase], ['time=' num2str(time)],num2str(reportFigBool)}});
        end
%            ReportFigSM(1,[pwd '/NewFigs/GammaTrialExamples/'],[],[],{[fileBase], ['time=' num2str(time)]});
%             keyboard
    end
end

return


    
    dspowname = [fileBaseCell{i} '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBdspow'];
    dspow = ((bload(dspowname,[nchannels inf],0,'int16')')/100);
    [dspm n] = size(dspow);
    eegdat = readmulti([fileBaseCell{i} '.eeg'],nchannels,channel);
    filtname = [fileBaseCell{i} '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.filt'];
    filtdat = readmulti(filtname,nchannels,channel);
    powname = [fileBaseCell{i} '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBpow'];
    powdat = readmulti(powname,nchannels,channel)/100;
