function PlotBehavIndepVsDepScat01(indepVar,depVar,fileExt,spectAnalDir,analRoutine,varargin)
[xLimits,yLimits,chanMat,glmVersion] ...
    = DefaultArgs(varargin,{[],[],[],'GlmWholeModel08'});
chanDir = 'ChanInfo/';
if ~isempty([strfind(depVar,'Phase') strfind(depVar,'phase')])
    depVarType = 'phase';
    selChanBool = 1;
elseif ~isempty([strfind(depVar,'Coh') strfind(depVar,'coh')])
    depVarType = 'coh';
    selChanBool = 1;
elseif ~isempty([strfind(depVar,'Pow') strfind(depVar,'pow')]);
    depVarType = 'pow';
    selChanNames = {''};
    selChanBool = 0;
else
    depVarType = 'undef';
    selChanNames = {''};
    selChanBool = 0;
end
if isempty(chanMat)
    chanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
end
% eegChanMat = LoadVar(['ChanInfo/ChanMat' '.eeg' '.mat']);
badChan = load(['ChanInfo/BadChan' fileExt '.txt']);
% offset = load(['ChanInfo/Offset' fileExt '.txt']);

dirName = [spectAnalDir fileExt];
if ~isstruct(analRoutine)
    load(['TrialDesig/' glmVersion '/' analRoutine '.mat']);
    fileName = ParseStructName(depVar);
    files = MatStruct2StructMat(dir('sm96*'),'name');
    if ~exist('fileBaseCell','var')
        fileBaseCell = mat2cell(fileBaseMat,ones(size(fileBaseMat,1),1),size(fileBaseMat,2));
    end
    fileBaseCell = intersect(fileBaseCell,files.name);
end

clf;
set(gcf,'name',depVar)

depCell = Struct2CellArray(LoadDesigVar(cell2mat(intersect(fileBaseCell,files.name)),dirName,depVar,trialDesig),[],1);
indepCell = Struct2CellArray(LoadDesigVar(cell2mat(intersect(fileBaseCell,files.name)),dirName,indepVar,trialDesig),[],1);

keyboard
plotColors = 'rgbk';
for j=1:size(chanMat,1)
    for k=1:size(chanMat,2)
        subplot(size(chanMat,1),size(chanMat,2),(j-1)*size(chanMat,2)+k)
        ylabel(['ch: ' num2str(chanMat(j,k))])
        hold on
        for m=1:size(depCell,1)
            if ~ismember(chanMat(j,k),badChan)
                if depVarType == 'coh'
                    plot(indepCell{m,end},UnATanCoh(depCell{m,end}(:,chanMat(j,k))),[plotColors(m) '.'])
                elseif depVarType == 'phase'
                    plot(indepCell{m,end},pi/180*(depCell{m,end}(:,chanMat(j,k))),[plotColors(m) '.'])
                else
                    plot(indepCell{m,end},(depCell{m,end}(:,chanMat(j,k))),[plotColors(m) '.'])
                end
            end
            if j==m & k==1
                xmax = get(gca,'xlim');
                text(xmax(2),mean(get(gca,'ylim')),[depCell{m,1:end-1}],'color',plotColors(m))
            end
        end
        if ~isempty(xLimits)
            set(gca,'xlim',xLimits)
        end
        if ~isempty(yLimits)
            set(gca,'ylim',yLimits)
        end
    end
end
return       

if selChanBool
    try
        selChanNames = fieldnames(LoadVar([fileBaseCell{1} '/' dirName '/' depVar]));
    catch
        selChanNames = fieldnames(LoadVar(['ChanInfo/SelChan' fileExt '.mat']));
    end
else
    selChanNames = {''};
end
for k=1:length(selChanNames)
    if ~isstruct(analRoutine)
        depCell = Struct2CellArray(LoadDesigVar(cell2mat(intersect(fileBaseCell,files.name)),dirName,[depVar '.' selChanNames{k}],trialDesig),[],1);
    else
       depCell = Struct2CellArray(analRoutine,[],1);
    end
    keyboard
    subplot(length(selChanNames),size(depCell,1)+1,(k-1)*(size(depCell,1)+1)+1)
    if strcmp(depVarType,'coh')
        grandMean = UnATanCoh(squeeze(mean(cat(1,depCell{:,end}))));
    elseif strcmp(depVarType,'phase')
        grandMean = angle(squeeze(mean(cat(1,depCell{:,end}))));
    else
        grandMean = squeeze(mean(cat(1,depCell{:,end})));
    end
    imagesc(Make2DPlotMat(grandMean,chanMat,badChan));
%     imagesc(Make2DPlotMat(grandMean,chanMat,badChan,interpFunc));
    
    if ~isempty(colorLimits)
        if iscell(colorLimits)
            if ~isempty(colorLimits{1})
                set(gca,'clim',colorLimits{1})
            end
        else
            set(gca,'clim',colorLimits)
        end
    end
    PlotAnatCurves('ChanInfo/AnatCurves.mat',size(eegChanMat),0.5-offset);
    set(gca,'xtick',[],'ytick',[])
    title('GrandMean')
    colorbar;
    ylabel(selChanNames{k});
    for j=1:size(depCell,1)
        subplot(length(selChanNames),size(depCell,1)+1,(k-1)*(size(depCell,1)+1)+j+1)
        if strcmp(depVarType,'coh')
            temp = UnATanCoh(squeeze(mean(depCell{j,end})));
        elseif strcmp(depVarType,'phase')
            temp = angle(squeeze(mean(depCell{j,end})));
        else
            temp = squeeze(mean(depCell{j,end}));
        end
        if subtractMeanBool
            if strcmp(depVarType,'phase')
                temp = angle(complex(cos(temp-grandMean),sin(temp-grandMean)));
            else
                temp = temp - grandMean;
            end
        end
        imagesc(Make2DPlotMat(temp,chanMat,badChan));
%         imagesc(Make2DPlotMat(temp,chanMat,badChan,interpFunc));

        if ~isempty(colorLimits)
            if iscell(colorLimits)
                if length(colorLimits)>=(j+1) & ~isempty(colorLimits{j+1})
                    set(gca,'clim',colorLimits{j+1})
                end
            else
                set(gca,'clim',colorLimits)
            end
        end
        PlotAnatCurves('ChanInfo/AnatCurves.mat',size(eegChanMat),0.5-offset);
        set(gca,'xtick',[],'ytick',[])
        title([depCell{j,1:end-1}])
        colorbar;
    end
end
return
