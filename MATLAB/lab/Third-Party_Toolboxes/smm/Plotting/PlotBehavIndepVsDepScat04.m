function PlotBehavIndepVsDepScat02(analDirs,indepVar,depVar,fileExt,spectAnalDir,analRoutine,varargin)
[xLimits,yLimits,catMethod,saveDir,chanLocVersion,glmVersion,reportFigBool] ...
    = DefaultArgs(varargin,{[],[],'trial','RemPaper','Sel','GlmWholeModel08',0});
chanDir = 'ChanInfo/';

cwd = pwd;
cd(analDirs{1});

if ~isempty([strfind(depVar,'Phase') strfind(depVar,'phase')])
    depVarType = 'phase';
    depSelChanBool = 1;
elseif ~isempty([strfind(depVar,'Coh') strfind(depVar,'coh')])
    depVarType = 'coh';
    depSelChanBool = 1;
elseif ~isempty([strfind(depVar,'Pow') strfind(depVar,'pow')]);
    depVarType = 'pow';
    selChanNames = {''};
    depSelChanBool = 0;
else
    depVarType = 'undef';
    selChanNames = {''};
    depSelChanBool = 0;
end
if ~isempty([strfind(indepVar,'Phase') strfind(indepVar,'phase')])
    indepVarType = 'phase';
    indepSelChanBool = 1;
elseif ~isempty([strfind(indepVar,'Coh') strfind(indepVar,'coh')])
    indepVarType = 'coh';
    indepSelChanBool = 1;
elseif ~isempty([strfind(indepVar,'Pow') strfind(indepVar,'pow')]);
    indepVarType = 'pow';
    selChanNames = {''};
    indepSelChanBool = 0;
else
    indepVarType = 'undef';
    selChanNames = {''};
    indepSelChanBool = 0;
end
endchanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
eegChanMat = LoadVar(['ChanInfo/ChanMat' '.eeg' '.mat']);
badChan = load(['ChanInfo/BadChan' fileExt '.txt']);
offset = load(['ChanInfo/Offset' fileExt '.txt']);


selChansCell = Struct2CellArray(LoadVar([chanDir 'SelChan' fileExt '.mat']));

dirName = [spectAnalDir fileExt];
% dirName = [spectAnalDir midPointsText '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) fileExt];
% if ~isstruct(analRoutine)
%     load(['TrialDesig/' glmVersion '/' analRoutine '.mat']);
%     fileName = ParseStructName(depVar);
%     % fo = LoadField([fileBaseCell{1} '/' dirName '/' fileName{1} '.fo']);
% 
%     % depCell = Struct2CellArray(LoadDesigVar(fileBaseCell(1:4,:),dirName,depVar,trialDesig),[],1);
%     files = MatStruct2StructMat(dir('sm96*'),'name');
%     if ~exist('fileBaseCell','var')
%         fileBaseCell = mat2cell(fileBaseMat,ones(size(fileBaseMat,1),1),size(fileBaseMat,2));
%     end
%     fileBaseCell = intersect(fileBaseCell,files.name);
% end
% fileBaseCell = fileBaseCell(1:3);
depCell = Struct2CellArray(LoadAnalResults({analDirs},spectAnalDir,fileExt,depVar,glmVersion,...
    analRoutine,depSelChanBool,chanLocVersion,catMethod,0,0),[],1);
% indepCell = Struct2CellArray(LoadDesigResults(analDirs,dirName,indepVar,glmVersion,analRoutine),[],1);
indepCell = Struct2CellArray(LoadAnalResults({analDirs},spectAnalDir,fileExt,indepVar,glmVersion,...
    analRoutine,depSelChanBool,chanLocVersion,catMethod,1),[],1);

colorOrder = get(gca,'colororder');
figure
clf
for j=1:size(depCell,1)
    for n=1:size(depCell{j,end},2)
      for m=1:size(depCell{j,end},1)
          if m==1 | n<=m
          subplot(size(depCell{j,end},2),size(depCell{j,end},1),(m-1)*size(depCell{j,end},2)+n)
          hold on
%           if size(indepCell{j,end},1) == size(depCell{j,end}{m,n},1)
            switch indepVarType
                case 'coh'
                    indepTemp = UnATanCoh(indepCell{j,end}{m,n});
                case 'phase'
                    indepTemp = angle(indepCell{j,end}{m,n});
                otherwise
                    indepTemp = indepCell{j,end}{m,n};
            end
            switch depVarType
                case 'coh'
                     depTemp = depCell{j,end}{m,n};
%                     depTemp = UnATanCoh(depCell{j,end}{m,n});
                case 'phase'
                    depTemp = angle(depCell{j,end}{m,n});
                otherwise
                    depTemp = depCell{j,end}{m,n};
            end
                    
            plot(indepTemp,depTemp,'o','color',colorOrder(j,:),'markersize',4)
%           else
%               idfactor = size(depCell{j,end}{m,n},1)/size(indepCell{j,end},1);
%               temp = repmat(indepCell{j,end},[idfactor,1]);
%               plot(temp,depCell{j,end}{m,n},'o','color',colorOrder(j,:),'markersize',4)
%           end
          if ~isempty(xLimits)
              set(gca,'xlim',xLimits)
          end
          if ~isempty(yLimits)
              set(gca,'ylim',yLimits)
          end
            xlim = get(gca,'xlim');
            ylim = get(gca,'ylim');
            [beta,BINT,res,RINT,STATS] = regress(depTemp,cat(2,ones(size(indepTemp,1),1),indepTemp));
            yData = xlim*beta(2)+beta(1);
            plot(xlim,yData,'r','linewidth',3)
            set(gca,'ylim',ylim)
            text(xlim(1)+(xlim(2)-xlim(1))*1,ylim(1)+(ylim(2)-ylim(1))*0.6,...
                {['b=' num2str(beta(2),3)]; ['rsq=' num2str(STATS(1),3)]; ['p=' num2str(STATS(3),3)]},'color','r')
          end
      end
    end
end
xLimits = get(gca,'xlim');
yLimits = get(gca,'ylim');
for j=1:size(depCell,1)
    text(xLimits(2),yLimits(2)-(yLimits(2)-yLimits(1))*j/size(depCell,1),[depCell{j,1:end-1}],'color',colorOrder(j,:))
end

return
% function PlotBehavIndepVsDepScat01(indepVar,depVar,fileExt,spectAnalDir,analRoutine,varargin)
% [xLimits,yLimits,chanMat,glmVersion] ...
%     = DefaultArgs(varargin,{[],[],[],'GlmWholeModel08'});
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
