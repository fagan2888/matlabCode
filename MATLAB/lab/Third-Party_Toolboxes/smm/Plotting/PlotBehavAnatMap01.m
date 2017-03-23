function PlotBehavAnatMap01(depVar,fileExt,spectAnalBase,analRoutine,varargin)
[colorLimits,interpFunc,glmVersion,subtractMeanBool] ...
    = DefaultArgs(varargin,{[],'linear','GlmWholeModel08',1});
% [colorLimits,interpFunc,glmVersion,midPointsBool,minSpeed,winLength] ...
%     = DefaultArgs(varargin,{[],'linear','GlmWholeModel08',1,0,626});
%analRoutine = 'CalcRunningSpectra9_noExp';
% analRoutine = 'RemVsRun_noExp';
% winLength = 1250;
% midPointsBool=0;
% %analRoutine = 'AlterGood_MR';
% analRoutine = 'RemVsRun';
% glmVersion = 'GlmWholeModel05';
chanDir = 'ChanInfo/';
% % fileExt = '.eeg';
% % fileExt = '_NearAveCSD1.csd';
% % fileExt = '_LinNearCSD121.csd';

% depVar = 'powSpec.yo';
% selChansCell = Struct2CellArray(LoadVar([chanDir 'SelChan' fileExt '.mat']));
% selChanNames = selChans(:,1);
% selChans = cell2mat(selChans(:,2));
% if midPointsBool
%     midPointsText = '_MidPoints';
% else
%     midPointsText = [];
% end
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
if selChanBool
    selChanCell = Struct2CellArray(LoadVar(['ChanInfo/SelChan' fileExt '.mat']));
    for j=1:size(selChanCell,1)
    selChanNames{j} = ['.ch' num2str(selChanCell{j,end})];
    end
else
    selChanCell = {''}
    selChanNames = {''};
end
chanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
eegChanMat = LoadVar(['ChanInfo/ChanMat' '.eeg' '.mat']);
badChan = load(['ChanInfo/BadChan' fileExt '.txt']);
offset = load(['ChanInfo/Offset' fileExt '.txt']);

dirName = [spectAnalBase fileExt];
% dirName = [spectAnalBase midPointsText '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) fileExt];

load(['TrialDesig/' glmVersion '/' analRoutine '.mat']);
fileName = ParseStructName(depVar);
% fo = LoadField([fileBaseCell{1} '/' dirName '/' fileName{1} '.fo']);

% depCell = Struct2CellArray(LoadDesigVar(fileBaseCell(1:4,:),dirName,depVar,trialDesig),[],1);
files = MatStruct2StructMat(dir('sm96*'),'name');
%fileBaseCell = mat2cell(fileBaseMat,ones(size(fileBaseMat,1),1),size(fileBaseMat,2));
if strcmp(depVarType,'phase')
    try colormap(LoadVar('CircularColorMap.mat')); end
else
    try colormap(LoadVar('ColorMapSean6')); end
end
    clf;
    set(gcf,'name',depVar)
for k=1:length(selChanNames)
    depCell = Struct2CellArray(LoadDesigVar(cell2mat(intersect(fileBaseCell,files.name)),dirName,[depVar selChanNames{k}],trialDesig),[],1);
    subplot(length(selChanNames),size(depCell,1)+1,(k-1)*(size(depCell,1)+1)+1)
    if strcmp(depVarType,'coh')
        grandMean = UnATanCoh(squeeze(mean(cat(1,depCell{:,end}))));
    elseif strcmp(depVarType,'phase')
        grandMean = angle(squeeze(mean(cat(1,depCell{:,end}))));
    else
        grandMean = squeeze(mean(cat(1,depCell{:,end})));
    end
    imagesc(Make2DPlotMat(grandMean,chanMat,badChan,interpFunc));
    if ~isempty(colorLimits)
        set(gca,'clim',colorLimits)
    end
    PlotAnatCurves('ChanInfo/AnatCurves.mat',size(eegChanMat),0.5-offset);
    set(gca,'xtick',[],'ytick',[])
    title('GrandMean')
    colorbar;
    ylabel(selChanCell{k,1});
    for j=1:size(depCell,1)
        try colormap(LoadVar('ColorMapSean6')); end
        subplot(length(selChanNames),size(depCell,1)+1,(k-1)*(size(depCell,1)+1)+j+1)
        if strcmp(depVarType,'coh')
            temp = UnATanCoh(squeeze(mean(depCell{j,end})));
        else
            temp = squeeze(mean(depCell{j,end}));
        end
        if subtractMeanBool
            temp = temp - grandMean;
        end
        if strcmp(depVarType,'phase')
            imagesc(Make2DPlotMat(angle(temp),chanMat,badChan,interpFunc));
        else
            imagesc(Make2DPlotMat(temp,chanMat,badChan,interpFunc));
        end
       if ~isempty(colorLimits)
            set(gca,'clim',colorLimits)
        end
        PlotAnatCurves('ChanInfo/AnatCurves.mat',size(eegChanMat),0.5-offset);
        set(gca,'xtick',[],'ytick',[])
        title([depCell{j,1:end-1}])
        colorbar;
    end
end
return
