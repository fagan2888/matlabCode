function PlotBehavTraceMaps01(fileExt,spectAnalBase,analRoutine,varargin)
[yScale,interpFunc,glmVersion,midPointsBool,minSpeed,winLength,eegSamp] ...
    = DefaultArgs(varargin,{[],'linear','GlmWholeModel07',1,0,626,1250});
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
if midPointsBool
    midPointsText = '_MidPoints';
else
    midPointsText = [];
end
bps = 2;
chanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
eegChanMat = LoadVar(['ChanInfo/ChanMat' '.eeg' '.mat']);
badChan = load(['ChanInfo/BadChan' fileExt '.txt']);
offset = load(['ChanInfo/Offset' fileExt '.txt']);
NChan = load(['ChanInfo/NChan' fileExt '.txt']);

dirName = [spectAnalBase midPointsText '_MinSpeed' num2str(minSpeed) 'Win' num2str(winLength) fileExt];

load(['TrialDesig/' glmVersion '/' analRoutine '.mat']);
% fo = LoadField([fileBaseCell{1} '/' dirName '/' fileName{1} '.fo']);

% depCell = Struct2CellArray(LoadDesigVar(fileBaseCell(1:4,:),dirName,depVar,trialDesig),[],1);
files = MatStruct2StructMat(dir('sm96*'),'name');
%fileBaseCell = mat2cell(fileBaseMat,ones(size(fileBaseMat,1),1),size(fileBaseMat,2));
    clf;
     for m=1:length(files)
         fileBase =files{m}
%     set(gcf,'name',depVar)
    time = Struct2CellArray(LoadDesigVar(fileBase,dirName,'time',trialDesig),[],1);
%     fileBase = Struct2CellArray(LoadDesigVar(cell2mat(intersect(fileBaseCell,files.name)),dirName,'infoStruct.fileBase',trialDesig),[],1);
%    eegSamp = Struct2CellArray(LoadDesigVar(fileBase,dirName,'infoStruct.eegSamp',trialDesig),[],1);
    for j=1:min([time{:,end}])
        for k=1:size(time,1)
            traceSeg = bload([fileBase{k,end}{j} fileExt],[NChan winLength],(time{k,end}(j)*eegSamp{k,end}(j)-winLength/2)*bps*NChan);
keyboard
        end
    end
     end