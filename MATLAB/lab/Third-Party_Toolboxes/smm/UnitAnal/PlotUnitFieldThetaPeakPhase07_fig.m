function PlotUnitFieldPhase02(analDirs,fileExt,spectAnalDir,statsAnalFunc,...
    analRoutine,freqLim,trialRateMin,cellRateMin,ntapers,varargin)
[freqRangeCell reportFigBool saveDir] = ...
    DefaultArgs(varargin,{{[4 12],[40 120]},...
    1,'/u12/smm/public_html/NewFigs/REMPaper/UnitAnal05/'});

prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound';...
   'off', 'MATLAB:divideByZero'});

cwd = pwd;

rates = [];
acgs = [];
ccgs = [];
animalID = [];
cellID = [];
for j=1:length(analDirs)
    cd(analDirs{j})
    load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])
    selChanCell = Struct2CellArray(LoadVar(['ChanInfo/SelChan' fileExt '.mat']));
    
%     [tempCCG keptIndexes] = LoadDesigUnitPhaseThresh(fileBaseCell,spectAnalDir,...
%         ['unitFieldPhase'  '_tapers' num2str(ntapers) '.yo'],...
%         ['unitRate'],trialRateMin,trialDesig);
%     tempCCG = Struct2CellArray(tempCCG,[],1);
    
    [tempCCG keptIndexes] = LoadDesigUnitThetaPeakPhaseThresh(fileBaseCell,spectAnalDir,...
        ['unitFieldPhase'  '_tapers' num2str(ntapers)],'thetaFreqLM6-12Hz',...
        ['unitRate'],trialRateMin,trialDesig);
    tempCCG = Struct2CellArray(tempCCG,[],1);
   
    tempRate = Struct2CellArray(MeanDesigUnitIndexes(fileBaseCell,spectAnalDir,...
        ['unitRate'],keptIndexes,trialDesig),[],1);

    keepInd = ones(size(tempRate{1,end}));
    for k=1:size(tempCCG,1)
%         size(tempCCG{k,end})
        % calculate cells with rate < cellRateMin (in any condition)
        keepInd = keepInd & tempRate{k,end} >= cellRateMin;
%          size(find(keepInd))
        %keepInd
    end
    for k=1:size(tempCCG,1)
        % remove cells with rate < cellRateMin
%         keepInd = tempRate{k,end} >= cellRateMin;
        tempRate{k,end} = tempRate{k,end}(1,keepInd);
        tempCCG{k,end} = tempCCG{k,end}(keepInd);
        cellLayers = LoadCellLayers([fileBaseCell{1} '/' fileBaseCell{1} '.cellLayer']);
        cellTypes = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
        cellLayers = cellLayers(keepInd,:);
        cellTypes = cellTypes(keepInd,:);
        
        %%%% code to id cells %%%%
        tempAnimalID = tempRate;
        tempCellID = tempRate;
        idText = 'sm96';
        idLoc = strfind(analDirs{j},idText);
        if ~isempty(idLoc)
            tempAnimalID{k,end} = repmat(str2num(analDirs{j}...
                ([idLoc+length(idText):idLoc+length(idText)+1])),1,size(cellLayers,1));
        else
            tempAnimalID{k,end} = zeros(1,size(cellLayers,1));    
        end
        tempCellID{k,end} = find(keepInd);
        
%         % sort cells by layer/type
        if isempty(ccgs)
            rates = tempRate;
            acgs = tempCCG;
            ccgs = tempCCG;
            animalID = tempAnimalID;
            cellID = tempCellID;
        end
        if ~isstruct(ccgs{k,end})
            rates{k,end} = struct([]);
            acgs{k,end} = struct([]);
            ccgs{k,end} = struct([]);
            animalID{k,end} = struct([]);
            cellID{k,end} = struct([]);
        end
%         if ~isempty(tempCCG{k,end})
            animalID{k,end} = UnionStructMatCat(1,animalID{k,end},SortRates2LayerTypes(squeeze(tempAnimalID{k,end}),cellLayers,cellTypes));
            cellID{k,end} = UnionStructMatCat(1,cellID{k,end},SortRates2LayerTypes(squeeze(tempCellID{k,end}),cellLayers,cellTypes));
            rates{k,end} = UnionStructMatCat(1,rates{k,end},SortRates2LayerTypes(squeeze(tempRate{k,end}),cellLayers,cellTypes));
            %         acgs{k,end} = UnionStructMatCat(1,acgs{k,end},SortACG2LayerTypes(squeeze(tempCCG{k,end}),cellLayers,cellTypes));
            ccgs{k,end} = UnionStructMatCat(1,ccgs{k,end},SortUnitFieldPhase2LayerTypes(squeeze(tempCCG{k,end}),cellLayers,cellTypes,selChanCell));
%         end
    end
    size(tempCCG{1,2})
end
fo = LoadField([fileBaseCell{1} '/' spectAnalDir '/' 'unitFieldPhase'  '_tapers' num2str(ntapers) '.fo']);
cd(cwd)
cellLayers = {'or','ca1Pyr','rad','mol','gran','hil','ca3Pyr'};
cellTypes = {'w' 'n'};
plotColors = 'rgbkcym';




fo = [1];
freqRangeCell = {[1 1]};

% keyboard



if reportFigBool
    close all
end

%%%%%%%%%%%% plot phase hist over all trials (normalize total by number of trials) %%%%%%%%%%%
nBins = 10;
xLimits = [-pi pi];
bins = HistBins(nBins,xLimits);
for q=1:length(freqRangeCell)
    freqRange = freqRangeCell{q};
    for k=1:length(cellTypes)
        figure
        figTitle = ['unitFieldPhase_normByTrial' ...
            '_tMin' num2str(trialRateMin) '_cMin'...
            num2str(cellRateMin) '_' ...
            'tapers' num2str(ntapers)];
        title(figTitle)
        screenHeight = 8;
        xyFactor = 1.5;
        set(gcf,'units','inches')
        set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*length(cellLayers)*xyFactor,screenHeight])
        set(gcf,'paperposition',get(gcf,'position'))
        for j=1:length(cellLayers)

            for m=1:size(selChanCell,1)
                subplot(size(selChanCell,1),length(cellLayers),j+length(cellLayers)*(m-1))
                hold on
                titleText = {};
                nText = ['n='];
                for p=1:size(ccgs,1)
                    if m==1 & p==1 & j==1
                        titleText = cat(1,titleText,...
                            {...
                            ['Unit Theta Peak Phase ' ...
                            fileExt];...
                            ['tapers=' num2str(ntapers) ' trialMinRate=' num2str(trialRateMin)...
                            ' cellMinRate=' num2str(cellRateMin)]});
                    end
                    if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
                            & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1}))
                        
                        temp1 = cat(1,ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){:});
                        [num,xPos] = hist(angle(mean(Angle2Complex(temp1...
                            (:,fo>=freqRange(1) & fo<=freqRange(2))),2)),bins);
                        [bsErrors] = BsErrBars(@median,95,1000,@hist,1,angle(mean(Angle2Complex(temp1...
                            (:,fo>=freqRange(1) & fo<=freqRange(2))),2)),bins);
                        normFactor = size(temp1,1);
                        
                        PhasePlot(repmat(xPos,[size(bsErrors,1) 1])',bsErrors'/normFactor,[plotColors(p) ':'])
                        PhasePlot(xPos',num'/normFactor,plotColors(p))
                        
                        nText = cat(2,nText,...
                            num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1)),',');
                    end
                    title(SaveTheUnderscores(cat(1,titleText,nText)))
                    if p==m & j==length(cellLayers)
                        text(xLimits(2)+0.1*xLimits(2),0,[ccgs{p,1:end-1}],'color',plotColors(p))
                    end
                end
                yLimits = get(gca,'ylim');
                if j==1
                    ylabel({selChanCell{m,1}})
                end
                if m==size(selChanCell,1)
                    xlabel([cellLayers{j} ',' cellTypes{k}])
                end
                set(gca,'xlim',xLimits)
%                 yLimits = [max([yLimits(1) 0]) min([yLimits(2) 1])];
                yLimits = [0 0.5];
                set(gca,'ylim',yLimits)
            end
        end
    end
if reportFigBool
    numFigs = length(cellTypes);
    ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldThetaPeakPhase') SC(Dot2Underscore(fileExt))],...
        repmat({figTitle},[numFigs 1]));
    close all
end
end


%%%%%%%%%%%% plot phase hist over all trials (average hists norm by trials) %%%%%%%%%%%
nBins = 10;
xLimits = [-pi pi];
bins = HistBins(nBins,xLimits);
for q=1:length(freqRangeCell)
    freqRange = freqRangeCell{q};
    for k=1:length(cellTypes)
        figure
        figTitle = ['unitFieldPhase_aveCellNormByTrial' ...
            '_tMin' num2str(trialRateMin) '_cMin'...
            num2str(cellRateMin) '_' ...
            'tapers' num2str(ntapers)];
        title(figTitle)
        screenHeight = 8;
        xyFactor = 1.5;
        set(gcf,'units','inches')
        set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*length(cellLayers)*xyFactor,screenHeight])
        set(gcf,'paperposition',get(gcf,'position'))
        for j=1:length(cellLayers)

            for m=1:size(selChanCell,1)
                subplot(size(selChanCell,1),length(cellLayers),j+length(cellLayers)*(m-1))
                hold on
                titleText = {};
                nText = ['n='];
                for p=1:size(ccgs,1)
                    if m==1 & p==1 & j==1
                        titleText = cat(1,titleText,...
                            {...
                            ['Unit Theta Peak Phase ' ...
                            fileExt];...
                            ['tapers=' num2str(ntapers) ' trialMinRate=' num2str(trialRateMin)...
                            ' cellMinRate=' num2str(cellRateMin)]});
                    end
                     if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
                            & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1}))
                                                catHist = [];
                        for r=1:length(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}))
                            temp1 = ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){r};
                            [num,xPos] = hist(angle(mean(Angle2Complex(temp1...
                                (:,fo>=freqRange(1) & fo<=freqRange(2))),2)),bins);
                            normFactor = size(temp1,1);
                            catHist = cat(1,catHist,num/normFactor);
                        end
                        if ~isempty(catHist)
%                             PhasePlot([xPos;xPos]',...
%                                 [mean(catHist,1)+std(catHist,[],1);...
%                                 mean(catHist,1)-std(catHist,[],1)]',...
%                                 [plotColors(p) ':'])
                            PhasePlot(xPos',mean(catHist,1)',plotColors(p))
                         nText = cat(2,nText,...
                            num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1)),',');
                       end
                    end
                    title(SaveTheUnderscores(cat(1,titleText,nText)))
                    if p==m & j==length(cellLayers)
                        text(xLimits(2)+0.1*xLimits(2),0,[ccgs{p,1:end-1}],'color',plotColors(p))
                    end
                end
                yLimits = get(gca,'ylim');
                if j==1
                    ylabel({selChanCell{m,1}})
                end
                if m==size(selChanCell,1)
                    xlabel([cellLayers{j} ',' cellTypes{k}])
                end
                set(gca,'xlim',xLimits)
%                 yLimits = [max([yLimits(1) 0]) min([yLimits(2) 1])];
                yLimits = [0 0.5];
                set(gca,'ylim',yLimits)
            end
        end
    end
if reportFigBool
    numFigs = length(cellTypes);
    ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldThetaPeakPhase') SC(Dot2Underscore(fileExt))],...
        repmat({figTitle},[numFigs 1]));
    close all
end
end



%%% testing %%%
%%%%%%%%%%%% plot phase hist over cells %%%%%%%%%%%

nBins = 10;
xLimits = [-pi pi];
bins = HistBins(nBins,xLimits);
for q=1:length(freqRangeCell)
    freqRange = freqRangeCell{q};
    for k=1:length(cellTypes)
        figure
        figTitle = ['unitFieldPhase_normByCell' ...
            '_tMin' num2str(trialRateMin) '_cMin'...
            num2str(cellRateMin) '_' ...
            'tapers' num2str(ntapers)];
        title(figTitle)
        screenHeight = 8;
        xyFactor = 1.5;
        set(gcf,'units','inches')
        set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*length(cellLayers)*xyFactor,screenHeight])
        set(gcf,'paperposition',get(gcf,'position'))
        for j=1:length(cellLayers)

            for m=1:size(selChanCell,1)
                subplot(size(selChanCell,1),length(cellLayers),j+length(cellLayers)*(m-1))
                hold on
                titleText = {};
                nText = ['n='];
                for p=1:size(ccgs,1)
                    if m==1 & p==1 & j==1
                        titleText = cat(1,titleText,...
                            {...
                            ['Unit Theta Peak Phase ' ...
                            fileExt];...
                            ['tapers=' num2str(ntapers) ' trialMinRate=' num2str(trialRateMin)...
                            ' cellMinRate=' num2str(cellRateMin)]});
                    end
                     if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
                            & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1}))
                        temp1 = [];
                        for r=1:length(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}))
                            temp1(r) = angle(mean(mean(Angle2Complex(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){r}...
                                (:,fo>=freqRange(1) & fo<=freqRange(2))),2),1));
                        end
                        [num,xPos] = hist(temp1,bins);
                        normFactor = size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1);
%                         polar([xPos' xPos+2*pi],[n n]/sum(n),plotColors(m))
%                         polar([xPos xPos+2*pi] ,[num num]/normFactor,plotColors(p))
                        PhasePlot(xPos',num'/normFactor,plotColors(p))
                        hold on
%                         PhasePlot(xPos',num'/normFactor,plotColors(p))
                         nText = cat(2,nText,...
                            num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1)),',');
                    end
                    title(SaveTheUnderscores(cat(1,titleText,nText)))
                    if p==m & j==length(cellLayers)
                        text(xLimits(2)+0.1*xLimits(2),0,[ccgs{p,1:end-1}],'color',plotColors(p))
                    end
                end
                yLimits = get(gca,'ylim');
                if j==1
                    ylabel({selChanCell{m,1}})
                end
                if m==size(selChanCell,1)
                    xlabel([cellLayers{j} ',' cellTypes{k}])
                end
                set(gca,'xlim',xLimits)
%                 yLimits = [max([yLimits(1) 0]) min([yLimits(2) 1])];
                yLimits = [0 0.5];
                set(gca,'ylim',yLimits)
            end
        end
    end
if reportFigBool
    numFigs = length(cellTypes);
    ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldThetaPeakPhase') SC(Dot2Underscore(fileExt))],...
        repmat({figTitle},[numFigs 1]));
    close all
end
end


%%%%%%%%%%%% plot phase hist for each cell norm by trial %%%%%%%%%%%
nBins = 24;
xLimits = [-360 360];
histLim = [-180 180];
bins = HistBins(nBins,histLim);
for q=1:length(freqRangeCell)
    freqRange = freqRangeCell{q};
    figTitle = ['unitFieldPhase_eachCellNormByTrial' ...
        '_tMin' num2str(trialRateMin) '_cMin'...
        num2str(cellRateMin) '_' ...
        'tapers' num2str(ntapers)];
    for j=1:length(cellLayers)
        for k=1:length(cellTypes)
            figure
            title(figTitle)
            for m=1:size(selChanCell,1)
                subplot(size(selChanCell,1),1,m)
                hold on
%                 titleText = {};
                for p=1:size(ccgs,1)
                    numCells = 0;
                    if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
                            & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1}))
                        numCells = length(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}));
                        for r=1:numCells
                            titleText = {};
                            if m==1 & p==size(ccgs,1) & r==1
                                titleText = cat(1,titleText,...
                                    {[cellLayers{j} ',' cellTypes{k}];...
                                    ['Unit Field Phase ' ...
                                    fileExt];...
                                    ['tapers=' num2str(ntapers) ' trialMinRate=' num2str(trialRateMin)...
                                    ' cellMinRate=' num2str(cellRateMin)]});
                            end

                            nText = ['n='];
                            subplot(size(selChanCell,1),numCells,r+(m-1)*numCells)
                            hold on
                            catHist = [];
                            temp1 = ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){r};
                            [num,xPos] = hist(180/pi*angle(mean(Angle2Complex(temp1...
                                (:,fo>=freqRange(1) & fo<=freqRange(2))),2)),bins);
                            normFactor = size(temp1,1);
                            catHist = cat(1,catHist,num/normFactor);

                            if ~isempty(catHist)
                                %                             PhasePlot([xPos;xPos]',...
                                %                                 [mean(catHist,1)+std(catHist,[],1);...
                                %                                 mean(catHist,1)-std(catHist,[],1)]',...
                                %                                 [plotColors(p) ':'])
                                PhasePlot2(xPos',mean(catHist,1)',plotColors(p))
%                                 keyboard
                                nText = cat(2,nText,...
                                    num2str(normFactor));
                                %                                   nText = cat(2,nText,...
                                %                                     num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1)),',');
                            end
                            yLimits = get(gca,'ylim');
                            if r==1
                                ylabel({selChanCell{m,1},ccgs{1,1}})
                            end
                            set(gca,'xlim',xLimits)
                            set(gca,'xtick',[xLimits(1):90:xLimits(2)]);
                            yLimits = [max([yLimits(1) 0]) min([yLimits(2) 1])];
                            yLimits = [0 0.4];
                            set(gca,'ylim',yLimits)
                            if m==1
                                title(SaveTheUnderscores(cat(1,titleText,cat(2,nText,...
                                    ',a=',num2str(animalID{p,end}.(cellLayers{j}).(cellTypes{k})(r)),...
                                    ',id=',num2str(cellID{p,end}.(cellLayers{j}).(cellTypes{k})(r))))))
                            end
                        end
                    end
                    if p==m
                        text(xLimits(2)+0.1*xLimits(2),0,[ccgs{p,1:end-1}],'color',plotColors(p))
                    end
                end
            end
            screenHeight = 8;
            xyFactor = 1.5;
            set(gcf,'units','inches')
            set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*xyFactor*max([numCells 1]),screenHeight])
            set(gcf,'paperposition',get(gcf,'position'))            
        end
    end
if reportFigBool
    numFigs = length(cellLayers)*length(cellTypes);
    ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldThetaPeakPhase') SC(Dot2Underscore(fileExt))],...
        repmat({figTitle},[numFigs 1]));
    close all
end
end

return




% 
% %%%%%%%%%%%% plot phase hist over all trials (normalize total by number of trials) %%%%%%%%%%%
% nBins = 10;
% xLimits = [-pi pi];
% bins = HistBins(nBins,xLimits);
% for q=1:length(freqRangeCell)
%     freqRange = freqRangeCell{q};
%     for k=1:length(cellTypes)
%         figure
%         figTitle = ['unitFieldPhase_normByTrial' ...
%             '_tMin' num2str(trialRateMin) '_cMin'...
%             num2str(cellRateMin) '_' ...
%             'tapers' num2str(ntapers)];
%         title(figTitle)
%         screenHeight = 8;
%         xyFactor = 1.5;
%         set(gcf,'units','inches')
%         set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*length(cellLayers)*xyFactor,screenHeight])
%         set(gcf,'paperposition',get(gcf,'position'))
%         for j=1:length(cellLayers)
% 
%             for m=1:size(selChanCell,1)
%                 subplot(size(selChanCell,1),length(cellLayers),j+length(cellLayers)*(m-1))
%                 hold on
%                 titleText = {};
%                 nText = ['n='];
%                 for p=1:size(ccgs,1)
%                     if m==1 & p==1 & j==1
%                         titleText = cat(1,titleText,...
%                             {...
%                             ['Unit Theta Peak Phase ' ...
%                             fileExt];...
%                             ['tapers=' num2str(ntapers) ' trialMinRate=' num2str(trialRateMin)...
%                             ' cellMinRate=' num2str(cellRateMin)]});
%                     end
%                     if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
%                             & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1}))
%                         
%                         temp1 = cat(1,ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){:});
%                         [num,xPos] = hist(angle(mean(Angle2Complex(temp1...
%                             (:,fo>=freqRange(1) & fo<=freqRange(2))),2)),bins);
%                         [bsErrors] = BsErrBars(@median,95,1000,@hist,1,angle(mean(Angle2Complex(temp1...
%                             (:,fo>=freqRange(1) & fo<=freqRange(2))),2)),bins);
%                         normFactor = size(temp1,1);
%                         
%                         PhasePlot(repmat(xPos,[size(bsErrors,1) 1])',bsErrors'/normFactor,[plotColors(p) ':'])
%                         PhasePlot(xPos',num'/normFactor,plotColors(p))
%                         
%                         nText = cat(2,nText,...
%                             num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1)),',');
%                     end
%                     title(SaveTheUnderscores(cat(1,titleText,nText)))
%                     if p==m & j==length(cellLayers)
%                         text(xLimits(2)+0.1*xLimits(2),0,[ccgs{p,1:end-1}],'color',plotColors(p))
%                     end
%                 end
%                 yLimits = get(gca,'ylim');
%                 if j==1
%                     ylabel({selChanCell{m,1}})
%                 end
%                 if m==size(selChanCell,1)
%                     xlabel([cellLayers{j} ',' cellTypes{k}])
%                 end
%                 set(gca,'xlim',xLimits)
%                 yLimits = [max([yLimits(1) 0]) min([yLimits(2) 1])];
%                 set(gca,'ylim',yLimits)
%             end
%         end
%     end
% if reportFigBool
%     numFigs = length(cellLayers)*length(cellTypes);
%     ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldThetaPeakPhase') SC(Dot2Underscore(fileExt))],...
%         repmat({figTitle},[numFigs 1]));
%     close all
% end
% end
% 
% %%%%%%%%%%%% plot phase hist over all trials (average hists norm by trials) %%%%%%%%%%%
% nBins = 10;
% xLimits = [-pi pi];
% bins = HistBins(nBins,xLimits);
% for q=1:length(freqRangeCell)
%     freqRange = freqRangeCell{q};
%     figTitle = ['unitFieldPhase_aveCellNormByTrial' ...
%         '_tMin' num2str(trialRateMin) '_cMin'...
%         num2str(cellRateMin) '_' ...
%         'tapers' num2str(ntapers)];
%     for j=1:length(cellLayers)
%         for k=1:length(cellTypes)
%             figure
%             title(figTitle)
%             screenHeight = 8;
%             xyFactor = 1.5;
%             set(gcf,'units','inches')
%             set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*xyFactor,screenHeight])
%             set(gcf,'paperposition',get(gcf,'position'))
% 
%             for m=1:size(selChanCell,1)
%                 subplot(size(selChanCell,1),1,m)
%                 hold on
%                 titleText = {};
%                 nText = ['n='];
%                 for p=1:size(ccgs,1)
%                     if m==1 & p==1
%                         titleText = cat(1,titleText,...
%                             {[cellLayers{j} ',' cellTypes{k}];...
%                             ['Unit Theta Peak Phase ' ...
%                             num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz ' ...
%                             fileExt];...
%                             ['tapers=' num2str(ntapers) ' trialMinRate=' num2str(trialRateMin)...
%                             ' cellMinRate=' num2str(cellRateMin)]});
%                     end
%                     if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
%                             & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1}))
%                                                 catHist = [];
%                         for r=1:length(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}))
%                             temp1 = ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){r};
%                             [num,xPos] = hist(angle(mean(Angle2Complex(temp1...
%                                 (:,fo>=freqRange(1) & fo<=freqRange(2))),2)),bins);
%                             normFactor = size(temp1,1);
%                             catHist = cat(1,catHist,num/normFactor);
%                         end
%                         if ~isempty(catHist)
% %                             PhasePlot([xPos;xPos]',...
% %                                 [mean(catHist,1)+std(catHist,[],1);...
% %                                 mean(catHist,1)-std(catHist,[],1)]',...
% %                                 [plotColors(p) ':'])
%                             PhasePlot(xPos',mean(catHist,1)',plotColors(p))
%                          nText = cat(2,nText,...
%                             num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1)),',');
%                        end
%                     end
%                     title(SaveTheUnderscores(cat(1,titleText,nText)))
%                     if p==m
%                         text(xLimits(2)+0.1*xLimits(2),0,[ccgs{p,1:end-1}],'color',plotColors(p))
%                     end
%                 end
%                 yLimits = get(gca,'ylim');
%                 ylabel({selChanCell{m,1},ccgs{1,1}})
%                 set(gca,'xlim',xLimits)
%                 yLimits = [max([yLimits(1) 0]) min([yLimits(2) 1])];
%                 set(gca,'ylim',yLimits)
%             end
%         end
%     end
% if reportFigBool
%     numFigs = length(cellLayers)*length(cellTypes);
%     ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldThetaPeakPhase') SC(Dot2Underscore(fileExt))],...
%         repmat({figTitle},[numFigs 1]));
%     close all
% end
% end
% 
% %%%%%%%%%%%% plot phase hist over cells %%%%%%%%%%%
% nBins = 15;
% xLimits = [-pi pi];
% bins = HistBins(nBins,xLimits);
% for q=1:length(freqRangeCell)
%     freqRange = freqRangeCell{q};
%     figTitle = ['unitFieldPhase_normByCell' ...
%         '_tMin' num2str(trialRateMin) '_cMin'...
%         num2str(cellRateMin) '_' ...
%         'tapers' num2str(ntapers)];
%     for j=1:length(cellLayers)
%         for k=1:length(cellTypes)
%             figure
%             title(figTitle)
%             screenHeight = 8;
%             xyFactor = 1.5;
%             set(gcf,'units','inches')
%             set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*xyFactor,screenHeight])
%             set(gcf,'paperposition',get(gcf,'position'))
% 
%             for m=1:size(selChanCell,1)
%                 subplot(size(selChanCell,1),1,m)
% %                 hold on
%                 titleText = {};
%                 nText = ['n='];
%                 for p=1:size(ccgs,1)
%                     if m==1 & p==1
%                         titleText = cat(1,titleText,...
%                             {[cellLayers{j} ',' cellTypes{k}];...
%                             ['Unit Field Phase ' ...
%                             num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz ' ...
%                             fileExt];...
%                             ['tapers=' num2str(ntapers) ' trialMinRate=' num2str(trialRateMin)...
%                             ' cellMinRate=' num2str(cellRateMin)]});
%                     end
%                     if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
%                             & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1}))
%                         temp1 = [];
%                         for r=1:length(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}))
%                             temp1(r) = angle(mean(mean(Angle2Complex(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){r}...
%                                 (:,fo>=freqRange(1) & fo<=freqRange(2))),2),1));
%                         end
%                         [num,xPos] = hist(temp1,bins);
%                         normFactor = size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1);
% %                         polar([xPos' xPos+2*pi],[n n]/sum(n),plotColors(m))
% %                         polar([xPos xPos+2*pi] ,[num num]/normFactor,plotColors(p))
%                         PhasePlot(xPos',num'/normFactor,plotColors(p))
%                         hold on
% %                         PhasePlot(xPos',num'/normFactor,plotColors(p))
%                          nText = cat(2,nText,...
%                             num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1)),',');
%                     end
%                     title(SaveTheUnderscores(cat(1,titleText,nText)))
%                     if p==m
%                         text(xLimits(2)+0.1*xLimits(2),0,[ccgs{p,1:end-1}],'color',plotColors(p))
%                     end
%                 end
%                 yLimits = get(gca,'ylim');
%                 ylabel({selChanCell{m,1},ccgs{1,1}})
%                 set(gca,'xlim',xLimits)
%                 yLimits = [max([yLimits(1) 0]) min([yLimits(2) 1])];
%                 yLimits = [0 1];
%                 set(gca,'ylim',yLimits)
% % %                 yLimits = get(gca,'ylim');
% %                 ylabel({selChanCell{m,1},ccgs{1,1}})
% % %                  set(gca,'xlim',xLimits)
% % %                 yLimits = [max([yLimits(1) 0]) min([yLimits(2) 1])];
% % %                 set(gca,'ylim',yLimits)
%             end
%         end
%     end
% if reportFigBool
%     numFigs = length(cellLayers)*length(cellTypes);
%     ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldThetaPeakPhase') SC(Dot2Underscore(fileExt))],...
%         repmat({figTitle},[numFigs 1]));
%     close all
% end
% end


% %%%%%%%%%%%% plot average phase spectrum for all cells %%%%%%%%%%%
% plotColors = 'rgbkcym';
% for j=1:length(cellLayers)
%     for k=1:length(cellTypes)
%         figure
%         screenHeight = 11;
%         xyFactor = 2;
%         set(gcf,'units','inches')
%         set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*xyFactor,screenHeight])
%         set(gcf,'paperposition',get(gcf,'position'))
%         figTitle = ['unitFieldPhase_spect' ...
%             num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'...
%             '_tMin' num2str(trialRateMin) '_cMin'...
%             num2str(cellRateMin) '_' ...
%             'tapers' num2str(ntapers)];
% 
%         for m=1:size(selChanCell,1)
%                 subplot(size(selChanCell,1),1,m)
%                 hold on
%                 titleText = {};
%                 nText = 'n=';
%                 for p=1:size(ccgs,1)
%                     if m==1 & p==1
%                         titleText = cat(1,titleText,{[cellLayers{j} ',' cellTypes{k}];...
%                             ['Unit Field Phase ' fileExt];...
%                             ['tapers=' num2str(ntapers) ' trialMinRate=' num2str(trialRateMin)...
%                             ' cellMinRate=' num2str(cellRateMin)]});
%                     end
%                     if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
%                             & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1})) 
%                         temp1 = cat(1,ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){:});
%                         plot(fo,angle(mean(Angle2Complex(temp1),1)),['.' plotColors(p)])
%                             nText = cat(2,nText,...
%                             [num2str(size(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}),1)) ',']);
%                     end
%                     title(SaveTheUnderscores(cat(1,titleText,nText)))
%                     if p==m 
%                         text(freqLim+0.1*freqLim,0,[ccgs{p,1:end-1}],'color',plotColors(p))
%                     end
%                         ylabel({selChanCell{m,1}})
%                     set(gca,'xlim',[0 freqLim])
%                     set(gca,'ylim',[-pi pi])
%                 end
%             end
%     end
% end
% if reportFigBool
%     numFigs = length(cellLayers)*length(cellTypes);
%     ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldThetaPeakPhase') SC(Dot2Underscore(fileExt))],...
%         repmat({figTitle},[numFigs 1]));
%     close all
% end


%%%%%%%%%%%% plot phase hist for each cell norm by trial %%%%%%%%%%%
nBins = 10;
xLimits = [-pi pi];
bins = HistBins(nBins,xLimits);
for q=1:length(freqRangeCell)
    freqRange = freqRangeCell{q};
    figTitle = ['unitFieldPhase_eachCellNormByTrial' ...
        num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'...
        '_tMin' num2str(trialRateMin) '_cMin'...
        num2str(cellRateMin) '_' ...
        'tapers' num2str(ntapers)];
    for j=2:2%1:length(cellLayers)
        for k=1:1%:length(cellTypes)
            for m=2:2%1:size(selChanCell,1)


                for p=1:size(ccgs,1)
                    %                     if m==1 & p==1
                    %                         titleText = cat(1,titleText,...
                    %                             {[cellLayers{j} ',' cellTypes{k}];...
                    %                             ['Unit Field Phase ' ...
                    %                             num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz ' ...
                    %                             fileExt];...
                    %                             ['tapers=' num2str(ntapers) ' trialMinRate=' num2str(trialRateMin)...
                    %                             ' cellMinRate=' num2str(cellRateMin)]});
                    %                     end
                    if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
                            & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1}))
                        figure
                        title(figTitle)
                        nCells = length(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}));
                        screenHeight = 1.5;
                        xyFactor = 2;
                        set(gcf,'units','inches')
                        set(gcf,'position',[0.5,0.5,screenHeight*nCells*xyFactor,screenHeight])
                        set(gcf,'paperposition',get(gcf,'position'))
                        for r=1:nCells
                         titleText = {};
                        nText = ['n='];
                            if p==1
                                subplot(1,nCells,r)
                            end
                            temp1 = ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){r};
                            [num,xPos] = hist(angle(mean(Angle2Complex(temp1...
                                (:,fo>=freqRange(1) & fo<=freqRange(2))),2)),bins);
                            normFactor = size(temp1,1);
                            PhasePlot(xPos',num'/normFactor,plotColors(p))
%                             polar([xPos xPos+2*pi],[num num]/normFactor,plotColors(p))
                            %                             catHist = cat(1,catHist,num/normFactor);
                            %                         if ~isempty(catHist)
                            %                             PhasePlot([xPos;xPos]',...
                            %                                 [mean(catHist,1)+std(catHist,[],1);...
                            %                                 mean(catHist,1)-std(catHist,[],1)]',...
                            %                                 [plotColors(p) ':'])
                            %                             PhasePlot(xPos',mean(catHist,1)',plotColors(p))
                            nText = cat(2,nText,...
                                num2str(normFactor),',');
                            title(SaveTheUnderscores(cat(1,titleText,nText)))
                            if p==m
                                text(xLimits(2)+0.1*xLimits(2),0,[ccgs{p,1:end-1}],'color',plotColors(p))
                            end
                        end
%                         yLimits = get(gca,'ylim');
%                         ylabel({selChanCell{m,1},ccgs{1,1}})
%                         set(gca,'xlim',xLimits)
%                         yLimits = [max([yLimits(1) 0]) min([yLimits(2) 1])];
%                         set(gca,'ylim',yLimits)
                        set(gca,'xlim',xLimits)
                        yLimits = [0 1];
                        set(gca,'ylim',yLimits)
                    end
                end
            end
        end
    end
if reportFigBool
    numFigs = length(cellLayers)*length(cellTypes);
    ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldThetaPeakPhase') SC(Dot2Underscore(fileExt))],...
        repmat({figTitle},[numFigs 1]));
    close all
end
end

% nBins = 10;
% xLimits = [-pi pi];
% screenHeight = 10;
% xyFactor = 1.5;
% bins = HistBins(nBins,xLimits);
% for q=1:length(freqRangeCell)
%     freqRange = freqRangeCell{q};
% for j=1:length(cellLayers)
%     for k=1:length(cellTypes)
%         figure
%         titleText = {};
%         for m=1:size(selChanCell,1)
%             for p=1:size(ccgs,1)
%                 if isfield(ccgs{p,end},cellLayers{j}) & isfield(ccgs{p,end}.(cellLayers{j}),cellTypes{k})...
%                         & isfield(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}),(selChanCell{m,1}))
% 
%                     numCell = length(ccgs{1,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}));
%                     nText = 'n=';
%                     for r=1:numCell
%                         subplot(size(selChanCell,1),numCell,(m-1)*numCell+r)
%                         hold on
% 
%                         temp1 = angle(mean(Angle2Complex(ccgs{p,end}.(cellLayers{j}).(cellTypes{k}).(selChanCell{m,1}){r}...
%                             (:,fo>=freqRange(1) & fo<=freqRange(2))),2));
%                         [num,xPos] = hist(temp1,bins);
%                         normFactor = length(temp1);
%                         PhasePlot(xPos',num'/normFactor,plotColors(p))
%                         if m==1
%                             nText = cat(2,nText,[num2str(length(temp1)),',']);
%                             if p==length(selChanCell{m,1})
%                             xlabel(nText)
%                             end
%                         end
%                         if r==1
%                             ylabel({selChanCell{m,1}})
%                             if m==1 & p==1
%                                 titleText = cat(1,titleText,{[cellLayers{j} ',' cellTypes{k}];...
%                                     ['Unit Field Phase ' fileExt];...
%                                     [' trialMinRate=' num2str(trialRateMin)...
%                                     ' cellMinRate=' num2str(cellRateMin)]});
%                                 title(SaveTheUnderscores(titleText))
% %                                 title(SaveTheUnderscores(cat(1,titleText,nText)))
%                                                     
%                             end
%                         end
%                         set(gca,'xlim',xLimits)
%                     end
%                     set(gcf,'units','inches')
%                     set(gcf,'position',[0.5,0.5,screenHeight/size(selChanCell,1)*numCell*xyFactor,screenHeight])
%                     set(gcf,'paperposition',get(gcf,'position'))
% 
% 
%                     if p==m
%                         text(freqLim+0.1*freqLim,0,[ccgs{p,1:end-1}],'color',plotColors(p))
%                     end
%                     
%                 end
%             end
%         end
%     end
% end
% if reportFigBool
%     numFigs = length(cellLayers)*length(cellTypes);
%     ReportFigSM(1:numFigs,[saveDir SC(analRoutine) SC('UnitFieldThetaPeakPhase') SC(Dot2Underscore(fileExt))],...
%         repmat({['unitFieldPhase_eachCell' ...
%         num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz'...
%         '_tMin' num2str(trialRateMin) '_cMin'...
%         num2str(cellRateMin) '_' ...
%         'tapers' num2str(ntapers)]},[numFigs 1]));
%     close all
% end
% end





