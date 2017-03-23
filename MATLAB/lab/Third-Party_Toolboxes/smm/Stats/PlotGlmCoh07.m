function PlotGlmCoh07(chanLocVersion,depVarCell,fileExt,inNameNote,animalDirs,varargin)
[dirname saveDir reportFigBool] = DefaultArgs(varargin,{'GlmWholeModel05/','MazePaper/new/',1});
chanInfoDir = 'ChanInfo/';
depVarType = 'coh';
%saveDir = [];

origDir = pwd;

plotColors = [1 0 0;0 0 1;0 1 0;0 0 0];
depVarPoss = {...
                'gammaCohMean60-120Hz',...
                'gammaCohMean40-100Hz',...
                'gammaCohMean40-120Hz',...
                'gammaCohMean50-100Hz',...
                'gammaCohMean50-120Hz',...
                'thetaCohMean6-12Hz',...
                'thetaCohPeakSelChF6-12Hz',...
                'thetaCohMedian6-12Hz',...
                'gammaCohMedian60-120Hz',...
                'thetaCohPeakLMF6-12Hz',...
                };


depVarCell = intersect(depVarCell,depVarPoss);

selChanNums = 1:6
%selChanNames = {'pyr1','rad','lm','mol','gran','pyr3'};
emptyCell = cell(8);
vertOffset = 0;
horzOffset = 1;
for a=1:length(depVarCell)
%for a=1:1
    depVar = depVarCell{a};
    for k=1:length(animalDirs)
        for j=1:length(selChanNums)
            fprintf('\ncd %s',animalDirs{k})
            cd(animalDirs{k})
            if selChanNums
                selChans = load([chanInfoDir 'SelectedChannels' fileExt '.txt']);
                selChanField = ['.ch' num2str(selChans(selChanNums(j)))];
            else
                selChanField = '';
            end
            fprintf('\nLoading %s',[dirname '/' inNameNote '/' fileExt '/' depVar selChanField '.mat'])
            load([dirname '/' inNameNote '/' fileExt '/' depVar selChanField '.mat']);
            chanMat = LoadVar([chanInfoDir 'ChanMat' fileExt '.mat']);
            chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
            badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);

            anatFields = fieldnames(chanLoc);
            
            for n=1:length(anatFields)
                goodChans = setdiff(chanLoc.(anatFields{n}),union(badChans,selChans(selChanNums<=j)));
                %%%%%%% Betas %%%%%%%%
                varNames = model.coeffNames;
                for m=1:length(varNames);
                    if j==1 & n==1
                        coeffs.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)) = emptyCell;
                    end
                    coeffs.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)){n+vertOffset,j+horzOffset} = ...
                            model.coeffs(m,goodChans)';
                    if strcmp(varNames{m},'Constant')
                        constantCoeff.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)){n+vertOffset,j+horzOffset} = ...
                            model.coeffs(m,goodChans)';
                    end
                end
                %%%%%% categMeans %%%%%%%%
                if ~isempty(model.categMeans)
                    for q = 1:length(model.categMeans)
                        varNames = model.categNames{q};
                        for m=1:length(varNames);
                            %                             categMeans{q}.(GenFieldName(varNames{m})).(anatFields{n}).(animalDirs{k}(13:18)) = ...
                            %                                 squeeze(model.categMeans{q}(m,1,goodChans)-...
                            %                                 mean(model.categMeans{q}(:,1,goodChans)));
                            if j==1 & n==1
                                categMeans{q}.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)) = emptyCell;
                            end
                            categMeans{q}.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)){n+vertOffset,j+horzOffset} = ...
                                squeeze(model.categMeans{q}(m,1,goodChans));
                            %- mean(model.categMeans{q}(:,1,goodChans)));
                        end
                    end
                end
                %%%% residNormPs %%%%%
                tempData = MatStruct2StructMat2(assumTest.residNormPs);
                cellData = Struct2CellArray(tempData,[],1);
                tempData = cat(1,cellData{:,end});
                clear varNames;
                for m=1:size(cellData,1)
                    varNames{m,1} = cat(2,cellData{m,1:end-1});
                end
                for m=1:length(varNames);
                    if j==1 & n==1
                        assumPlot.residNormPs.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)) = emptyCell;
                    end
                    assumPlot.residNormPs.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)){n+vertOffset,j+horzOffset} = ...
                        tempData(m,goodChans)';
                    %                 if m==1
                    %                 size(tempData(m,goodChans)')
                    %                 j
                    %                 end
                end
                %%%% residMeanPs %%%%%
                tempData = MatStruct2StructMat2(assumTest.residMeanPs);
                cellData = Struct2CellArray(tempData,[],1);
                tempData = cat(1,cellData{:,end});
                clear varNames;
                for m=1:size(cellData,1)
                    varNames{m,1} = cat(2,cellData{m,1:end-1});
                end
                for m=1:length(varNames);
                    if j==1 & n==1
                        assumPlot.residMeanPs.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)) = emptyCell;
                    end
                    assumPlot.residMeanPs.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)){n+vertOffset,j+horzOffset} = ...
                        tempData(m,goodChans)';
                end
                %                 %%%%%% residNormPs %%%%%%%%
                %                 varNames = fieldnames(assumTest.residNormPs);
                %                 for m=1:length(varNames);
                %                     temp = MatStruct2StructMat2(assumTest.residNormPs);
                %                     residNormPs.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)){n+vertOffset,j+horzOffset} = ...
                %                         temp.(varNames{m})(goodChans);
                %                 end
                %                 %%%%%% residMeanPs %%%%%%%%
                %                 varNames = fieldnames(assumTest.residMeanPs);
                %                 for m=1:length(varNames);
                %                     temp = MatStruct2StructMat2(assumTest.residMeanPs);
                %                     residMeanPs.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)){n+vertOffset,j+horzOffset} = ...
                %                         temp.(varNames{m})(goodChans);
                %                end
                %%%% contDwPvals %%%%%
                tempData = MatStruct2StructMat2(assumTest.contDwPvals);
                cellData = Struct2CellArray(tempData,[],1);
                tempData = cat(1,cellData{:,end});
                clear varNames;
                if size(cellData,1)>1
                    for m=1:size(cellData,1)
                        varNames{m,1} = cat(2,cellData{m,1:end-1});
                    end
                else
                    varNames{1,1} = 'none';
                end
                for m=1:length(varNames);
                    if j==1 & n==1
                        assumPlot.contDwPvals.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)) = emptyCell;
                    end
                    assumPlot.contDwPvals.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)){n+vertOffset,j+horzOffset} = ...
                        tempData(m,goodChans)';
                end
                %%%% categDwPvals %%%%%
                tempData = MatStruct2StructMat2(assumTest.categDwPvals);
                cellData = Struct2CellArray(tempData,[],1);
                tempData = cat(1,cellData{:,end});
                clear varNames;
                for m=1:size(cellData,1)
                    varNames{m,1} = cat(2,cellData{m,1:end-1});
                end
                for m=1:length(varNames);
                    if j==1 & n==1
                        assumPlot.categDwPvals.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)) = emptyCell;
                    end
                    assumPlot.categDwPvals.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)){n+vertOffset,j+horzOffset} = ...
                        tempData(m,goodChans)';
                end
                %%%% prllPvals %%%%%
                tempData = MatStruct2StructMat2(assumTest.prllPvals);
                cellData = Struct2CellArray(tempData,[],1);
                tempData = cat(1,cellData{:,end});
                clear varNames;
                if size(cellData,1)>1
                    for m=1:size(cellData,1)
                        varNames{m,1} = cat(2,cellData{m,1:end-1});
                    end
                else
                    varNames{1,1} = 'none';
                end
                for m=1:length(varNames);
                    if j==1 & n==1
                        assumPlot.prllPvals.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)) = emptyCell;
                    end
                    assumPlot.prllPvals.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)){n+vertOffset,j+horzOffset} = ...
                        tempData(m,goodChans)';
                end
                %%%%%% prllPvals %%%%%%%%
                %                         if isstruct(assumTest.prllPvals)
                %                             varNames = fieldnames(assumTest.prllPvals);
                %                             for m=1:length(varNames);
                %                                 temp = MatStruct2StructMat2(assumTest.prllPvals);
                %                                 assumPlot.prllPvals.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)){n+vertOffset,j+horzOffset} = ...
                %                                     temp.(varNames{m})(goodChans);
                %
                %                             end
                %                         else
                %                             assumPlot.prllPvals.(GenFieldName(varNames{m})).(animalDirs{k}(13:18)){n+vertOffset,j+horzOffset} = ...
                %                                 assumTest.prllPvals(goodChans);
                %                         end
            end
        end
    end
    [mu.coeffs p.coeffs] = CalcMuP(coeffs,0,0,depVarType);
    if ~isempty(model.categMeans)
        for q = 1:length(model.categMeans)
            [mu.categMeans{q}] = CalcMuP(categMeans{q},1,0,depVarType,constantCoeff.Constant);
        end
    end
%     [subtjunk] = CalcMuP(categMeans{1},1,0,depVarType,constantCoeff.Constant);
%     [junk] = CalcMuP(categMeans{1},1,0,depVarType);
%     keyboard
%    % function [mu p] = CalcMuP(analData,transMuBool,log10Bool,depVarType,constantCoeff)
% junkConst = CalcMuP(constantCoeff,1,0,depVarType);

    coeffNormP = CalcNormP(coeffs);
    mu.residNormPs = CalcMuP(assumPlot.residNormPs,0,1,depVarType);
    mu.residMeanPs = CalcMuP(assumPlot.residMeanPs,0,1,depVarType);
    mu.contDwPvals = CalcMuP(assumPlot.contDwPvals,0,1,depVarType);
    mu.categDwPvals = CalcMuP(assumPlot.categDwPvals,0,1,depVarType);
    mu.prllPvals = CalcMuP(assumPlot.prllPvals,0,1,depVarType);
    
    nextFig = 1;
    %%%%%%% Betas %%%%%%%%
    plotData = mu.coeffs;
    valueData = p.coeffs;
    log10Bool = 0;
    commonCLim = 1;
    colorLimits = [];
    titleBase = 'Beta';
    nextFig = LocalPlotHelper2(nextFig,plotData,valueData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,anatFields);
%     plotData = p.coeffs;
%     log10Bool = 1;
%     commonCLim = 1;
%     colorLimits = [0 -5];
%     titleBase = 'pVal';
%     nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,anatFields);
    %%%%%%% categMeans %%%%%%%%
    for q = 1:length(model.categMeans)
        plotData = mu.categMeans{q};
        log10Bool = 0;
        commonCLim = 1;
        colorLimits = [];
        titleBase = 'categMeans';
        nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,anatFields);
    end
    %%%%%%% coeffNormP %%%%%%%%
    plotData = coeffNormP;
    log10Bool = 1;
    commonCLim = 2;
    colorLimits = [0 -3];
    titleBase = 'coeffNormP';
    nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,anatFields);
    %%%%%%% residNormPs %%%%%%%%
    plotData = mu.residNormPs;
    log10Bool = 0;
    commonCLim = 1;
    colorLimits = [0 -3];
    titleBase = 'residNormPs';
    nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,anatFields);
    %%%%%%% residMeanPs %%%%%%%%
    plotData = mu.residMeanPs;
    log10Bool = 0;
    commonCLim = 1;
    colorLimits = [0 -3];
    titleBase = 'residMeanPs';
    nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,anatFields);
    %%%%%%% contDwPvals %%%%%%%%
    plotData = mu.contDwPvals;
    log10Bool = 0;
    commonCLim = 1;
    colorLimits = [0 -3];
    titleBase = 'contDwPvals';
    nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,anatFields);
    %%%%%%% categDwPvals %%%%%%%%
    plotData = mu.categDwPvals;
    log10Bool = 0;
    commonCLim = 1;
    colorLimits = [0 -3];
    titleBase = 'categDwPvals';
    nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,anatFields);
    %%%%%%% prllPvals %%%%%%%%
    plotData = mu.prllPvals;
    log10Bool = 0;
    commonCLim = 1;
    colorLimits = [0 -3];
    titleBase = 'prllPvals';
    nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,depVar,titleBase,commonCLim,colorLimits,anatFields,anatFields);
    
    cd(origDir)
    if reportFigBool
        ReportFigSM(1:nextFig-1,Dot2Underscore(['/u12/smm/public_html/NewFigs/' saveDir dirname chanLocVersion '/' inNameNote '/' fileExt '/']));
    end

end


return
end


function nextFig = LocalPlotHelper(nextFig,plotData,log10Bool,figName,titleBase,commonCLim,colorLimits,yTickLabels,xTickLabels)
figure(nextFig )
clf
nextFig = nextFig + 1;
resizeWinBool = 1;
figSizeFactor = 2.5;
figVertOffset = 0.5;
figHorzOffset = 0;

defaultAxesPosition = [0.1,0.15,0.85,0.70];
set(gcf,'DefaultAxesPosition',defaultAxesPosition);
set(gcf,'name',figName)
analNames = fieldnames(plotData);

if resizeWinBool
    set(gcf, 'Units', 'inches')
    set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(length(analNames)),figSizeFactor])
end
if isempty(colorLimits)
    colorLimits = [NaN NaN];
    autoCLim = 1;
else
    autoCLim = 0;
end
%keyboard
for j=1:length(analNames)
    if log10Bool
        plotData.(analNames{j}) = log10(plotData.(analNames{j}));
    end
    if ~strcmp(analNames{j},'Constant') & commonCLim > 0 & autoCLim
        temp = max([abs(colorLimits(1)) max(max(abs(plotData.(analNames{j}))))]);
        colorLimits = [-temp temp];
    end
end
for j=1:length(analNames)
    subplot(1,length(analNames),j)
    hold on
    if commonCLim == 0  & autoCLim
        colorLimits = [min(min(plotData.(analNames{j}))) max(max(plotData.(analNames{j})))];
    end
    mask = logical(tril(ones(size(plotData.(analNames{j}))),0));
    if strcmp(analNames{j},'Constant') & commonCLim ~=2
        ImageScMask(plotData.(analNames{j}),mask,[],[0 0 1]);
    else
        ImageScMask(plotData.(analNames{j}),mask,colorLimits,[0 0 1]);
    end
    title(SaveTheUnderscores([titleBase, ' ' analNames{j}]),'fontsize',3);
    set(gca,'fontsize',3,'ytick',[1:length(yTickLabels)],'yticklabel',yTickLabels,'ylim',[0.5 length(yTickLabels)+0.5])
    set(gca,'fontsize',3,'xtick',[1:length(xTickLabels)],'xticklabel',xTickLabels,'xlim',[0.5 length(xTickLabels)+0.5])
    %plot(1:length(xTickLabels),1:length(yTickLabels),'-','color',[0.5 0.5 0.5])
end
return
end



function nextFig = LocalPlotHelper2(nextFig,plotData,valueData,log10Bool,figName,titleBase,commonCLim,colorLimits,yTickLabels,xTickLabels)
figure(nextFig)
nextFig = nextFig + 1;
clf
resizeWinBool = 1;
figSizeFactor = 2.5;
figVertOffset = 0.5;
figHorzOffset = 0;

defaultAxesPosition = [0.1,0.15,0.85,0.70];
set(gcf,'DefaultAxesPosition',defaultAxesPosition);
set(gcf,'name',figName)
analNames = fieldnames(plotData);

baseAlpha = 0.01;
pValCut = log10(baseAlpha./((length(valueData.(analNames{1}))+1)*length(valueData.(analNames{1}))/2));

if resizeWinBool
    set(gcf, 'Units', 'inches')
    set(gcf, 'Position', [figHorzOffset,figVertOffset,figSizeFactor*(length(analNames)),figSizeFactor])
end
if isempty(colorLimits)
    colorLimits = [NaN NaN];
    autoCLim = 1;
else
    autoCLim = 0;
end
%keyboard
for j=1:length(analNames)
    if log10Bool
        plotData.(analNames{j}) = log10(plotData.(analNames{j}));
    end
    if ~strcmp(analNames{j},'Constant') & commonCLim > 0 & autoCLim
        temp = max([abs(colorLimits(1)) max(max(abs(plotData.(analNames{j}))))]);
        colorLimits = [-temp temp];
    end
end
for j=1:length(analNames)
    subplot(1,length(analNames),j)
    hold on
    if commonCLim == 0  & autoCLim
        colorLimits = [min(min(plotData.(analNames{j}))) max(max(plotData.(analNames{j})))];
    end
    plotTemp = plotData.(analNames{j});
    plotNaNs = isnan(plotTemp);
    plotTemp(plotNaNs) = 0;
    if strcmp(analNames{j},'Constant') & commonCLim ~=2
%         mask = logical(tril(ones(size(plotData.(analNames{j}))),0));
%         mask(mask~=1) = 0;
%         mask = logical(mask)
%         plotTemp = plotData.(analNames{j});
%         plotTemp(isnan(plotTemp)) = 0;
%         mask(plotNaNs) = 1;
       
%         ImageScMask(plotTemp,mask,[],[0 0 1]);
        sat = 0.3;
        val = 0.3;
        valMask = ones(size(plotData.(analNames{j})));
        triuMask = triu(ones(size(plotData.(analNames{j}))),1);
        satMask = valMask;
        satMask(satMask~=1) = sat;
        satMask(triuMask==1) = 0;
        valMask(valMask~=1) = val;
        satMask(plotNaNs) = 0;
        valMask(plotNaNs) = 0.35;
        valMask(triuMask==1) = 1;
        ImageScHSV(plotTemp,satMask,valMask,[]);
    else
        sat = 0.3;
        val = 0.3;
        valMask = clip((log10(valueData.(analNames{j}))/pValCut),0,1);
        triuMask = triu(ones(size(plotData.(analNames{j}))),1);
        satMask = valMask;
        satMask(satMask~=1) = sat;
        satMask(triuMask==1) = 0;
        valMask(valMask~=1) = val;
        satMask(plotNaNs) = 0;
        valMask(plotNaNs) = 0.35;
         valMask(triuMask==1) = 1;
       ImageScHSV(plotTemp,satMask,valMask,colorLimits);
    end
    title(SaveTheUnderscores([titleBase, ' ' analNames{j} ' p<' num2str(10^pValCut,'%1.5f')]),'fontsize',3);
    set(gca,'fontsize',3,'ytick',[1:length(yTickLabels)],'yticklabel',yTickLabels,'ylim',[0.5 length(yTickLabels)+0.5])
    set(gca,'fontsize',3,'xtick',[1:length(xTickLabels)],'xticklabel',xTickLabels,'xlim',[0.5 length(xTickLabels)+0.5])
    %plot(1:length(xTickLabels),1:length(yTickLabels),'-','color',[0.5 0.5 0.5])
end

return
end

function [mu p] = CalcMuP(analData,transMuBool,log10Bool,depVarType,constantCoeff)
if ~exist('log10Bool','var') | isempty(log10Bool)
    log10Bool = 0;
end

analNames = fieldnames(analData);
for n=1:length(analNames)
     catData = {};
     % concatenate data across animals and across diagonal 
     animalNames = fieldnames(analData.(analNames{n}));
     for m=1:length(animalNames)
         temp1 = analData.(analNames{n}).(animalNames{m});
         temp2 = flipud(rot90(temp1));
         for j=1:size(temp1,1)
             for k=1:size(temp1,2)
                 if j==k % don't duplicate diagonal measurements
                     temp2{j,k} = [];
                 end
                 if strcmp(depVarType,'phase') & ~log10Bool
                     temp2{j,k} = -temp2{j,k}; % phases are opposite
                 end
                 if isempty(find([j k] > size(catData))) % existscatData{j,k} ?
                     catData{j,k} = cat(1,catData{j,k},temp1{j,k},temp2{j,k});
                 else
                     catData{j,k} = cat(1,temp1{j,k},temp2{j,k});
                 end
             end
         end
     end
     anatNames = {'or','ca1Pyr','rad','lm','mol','gran','ca3Pyr','hil'};
     catData2 = [];
     catData2Names = {};
     for j=1:size(catData,1)
         for k=1:j
             catData2 = cat(1,catData2,catData{j,k});
             catData2Names = cat(1,catData2Names,repmat({[anatNames{j} '-' anatNames{k}]},size(catData{j,k})));
         end
     end
             [anovaP,AT,stats] = anova1(catData2,catData2Names,0);
        multcompare(stats);

     keyboard
     % calc stats
     for j=1:size(catData,1)
         for k=1:size(catData,2)
             ttestData = catData{j,k};
             ttestData = ttestData(isfinite(ttestData));
             if log10Bool
                 ttestData = log10(ttestData);
             end
             if isempty(ttestData)
                 p.(analNames{n})(j,k) = NaN;
                 mu.(analNames{n})(j,k) = NaN;
             else
                 %%%%% calc pval %%%%%
                 if strcmp(analNames{n},'Constant')
                     p.(analNames{n})(j,k) = NaN;
                 else
                     [h p.(analNames{n})(j,k)] = ttest(ttestData,[],0.01);
                 end
                 %%%%% calc means %%%%%
                 if strcmp(analNames{n},'Constant') | transMuBool
                     if strcmp(depVarType,'coh')
                         mu.(analNames{n})(j,k) = UnATanCoh(mean(ttestData));
                     end
                     if strcmp(depVarType,'phase')
                         mu.(analNames{n})(j,k) = mean(ttestData)./pi.*360;
                     end
                 else
                     mu.(analNames{n})(j,k) = mean(ttestData);
                 end
             end
         end
     end
end
return
end

function [p] = CalcNormP(analData)

analNames = fieldnames(analData);
for n=1:length(analNames)
     catData = {};
     % concatenate data across animals and across diagonal 
     animalNames = fieldnames(analData.(analNames{n}));
     for m=1:length(animalNames)
         temp1 = analData.(analNames{n}).(animalNames{m});
         temp2 = flipud(rot90(temp1));
         for j=1:size(temp1,1)
             for k=1:size(temp1,2)
                 try catData{j,k} = cat(1,catData{j,k},temp1{j,k},temp2{j,k});
                 catch catData{j,k} = cat(1,temp1{j,k},temp2{j,k});
                 end
             end
         end
     end
     for j=1:size(catData,1)
         for k=1:size(catData,2)
             ttestData = catData{j,k};
             ttestData = ttestData(isfinite(ttestData));
%              if log10Bool
%                  ttestData = log10(ttestData);
%              end
             if isempty(ttestData)
                 p.(analNames{n})(j,k) = NaN;
             else
                 %%%%% calc pval %%%%%
                 [h p.(analNames{n})(k,j)] = jbtest(ttestData);
             end
         end
     end
end
return
end
