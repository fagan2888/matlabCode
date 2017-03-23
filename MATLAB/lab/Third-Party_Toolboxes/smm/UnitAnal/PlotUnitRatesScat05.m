% function PlotUnitRateScats04(analDirs,spectAnalDir,statsAnalFunc,...
%     analRoutine,varargin)
% [saveDir,screenHeight, xyFactor] = DefaultArgs(varargin,...
%     {'/u12/smm/public_html/NewFigs/REMPaper/UnitAnal05/',10.5,1.1});
function PlotUnitRateScats04(analDirs,spectAnalDir,statsAnalFunc,...
    analRoutine,varargin)
[reportFigBool,saveDir,screenHeight, xyFactor] = DefaultArgs(varargin,...
    {1,'/u12/smm/public_html/NewFigs/REMPaper/UnitAnal06/',10.5,1.1});

prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound';...
   'off', 'MATLAB:divideByZero'});

cwd = pwd;

rates = [];
for j=1:length(analDirs)
    cd(analDirs{j})
    selChan = Struct2CellArray(LoadVar('ChanInfo/SelChan.eeg.mat'),[],1);
    load(['TrialDesig/' statsAnalFunc '/' analRoutine '.mat'])
    cellLayers = LoadCellLayers([fileBaseCell{1} '/' fileBaseCell{1} '.cellLayer']);
    cellTypes = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
    
    tempRate = Struct2CellArray(MeanDesigVar(1,fileBaseCell,spectAnalDir,...
        ['unitRate'],trialDesig),[],1);
    for k=1:size(tempRate,1)
        if isempty(rates)
            rates = tempRate;
        end
        if ~isstruct(rates{k,end})
            rates{k,end} = struct([]);
        end
        % sort cells by layer/type
        rates{k,end} = UnionStructMatCat(1,rates{k,end},SortRates2LayerTypes(squeeze(tempRate{k,end}),cellLayers,cellTypes));
    end
    size(tempRate{1,2})
end
cd(cwd)

% 2 axis scatter plot
cellLayers = selChan(:,1);
cellTypes = {'w' 'n' 'x'}
if reportFigBool
    close all
end

colNamesCell{1} = {''};
colNamesCell{2} = {''};
colNamesCell{3} = cellLayers;
colNamesCell{4} = cellTypes;
colNamesCell{5} = rates(:,1);

rateCell = CellArray2Struct(rates);
rateCell = Struct2CellArray(rateCell,[],1);
rateCell = cat(2,repmat({''},size(rateCell(:,[1 2]))),rateCell(:,[2 3]),...
    rateCell(:,[1 4]));

figName = 'UnitRates';
outDir = [saveDir SC(analRoutine)];

UnitBoxPlotHelper(rateCell,{'UnitRate'; ' raw'},figName,colNamesCell,reportFigBool,outDir)
tempRateCell = UnitLog10Helper(rateCell);
UnitBoxPlotHelper(tempRateCell,{'UnitRate'; ' log10'},figName,colNamesCell,reportFigBool,outDir)
tempRateCell = UnitWInCellHelper(rateCell);
UnitBoxPlotHelper(tempRateCell,{'UnitRate'; ' w/in Cell'},figName,colNamesCell,reportFigBool,outDir)
tempRateCell = UnitWInCellHelper(UnitLog10Helper(rateCell));
UnitBoxPlotHelper(tempRateCell,{'UnitRate log10'; ' w/in Cell'},figName,colNamesCell,reportFigBool,outDir)

if reportFigBool
    close all
end
return

