function CalcUnitCCG03(fileBaseCell,winLen,spectAnalDir,varargin)
%function CalcUnitSpectrum01(fileBaseCell)
%spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
%winLen = 626;
%[winLen,spectAnalDir] = DefaultArgs(varargin,{winLen,spectAnalDir});

[normalization,binSize] = DefaultArgs(varargin,{'hz',3});

prevWarnSettings = SetWarnings({'off','MATLAB:divideByZero'});

eegSamp = 1250;
datSamp = 20000;
timeWin = winLen/eegSamp;

%bps = 2;
%nChan = load('ChanInfo/NChan.eeg.txt');
%chanLoc = LoadVar('ChanInfo/ChanLoc_Full.eeg.mat');

unitCCG.infoStruct.eegSamp = eegSamp;
unitCCG.infoStruct.datSamp = datSamp;
unitCCG.infoStruct.timeWin = timeWin;
unitCCG.infoStruct.binSize = binSize;
unitCCG.infoStruct.winLen = winLen;
unitCCG.infoStruct.spectAnalDir = spectAnalDir;
% unitCCG.infoStruct.bps = bps;
% unitCCG.infoStruct.nChan = nChan;
unitCCG.infoStruct.normalization = normalization;
unitCCG.infoStruct.mfilename = mfilename;


% try
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    unitCCG.cellLayer = LoadCellLayers([fileBase '/' fileBase '.cellLayer']);
    unitCCG.cellType = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
% allTimes = LoadVar([fileBase '/' spectAnalDir 'allEegSegTime.mat'])/eegSamp;
    %eegFiles = dir([fileBase '/' fileBase '.eeg']);
    %numNewSamp = ceil(eegFiles(1).bytes/bps/nChan/eegSamp*newSamp);
    elNum = 0;
    catClu = [];
    catRes = [];
    for k=1:size(unitCCG.cellLayer,1)
        if elNum ~= unitCCG.cellLayer{k,1}% saves a little time
            clu = load([fileBase '/' fileBase '.clu.' num2str(unitCCG.cellLayer{k,1})]);
            res = load([fileBase '/' fileBase '.res.' num2str(unitCCG.cellLayer{k,1})]);
        end
        elNum = unitCCG.cellLayer{k,1};
        selInd = find(clu(2:end)==unitCCG.cellLayer{k,2});
        catRes = cat(1,catRes,res(selInd));
        catClu = cat(1,catClu,k*ones(size(selInd)));
    end
%     keyboard
    ccgTemp = [];
    unitCCG.yo = [];
    unitRate = zeros(length(time),size(unitCCG.cellLayer,1));
    for n=1:length(time)
        % calculate ACG
        [ccgTemp unitCCG.to] = CCG(catRes,catClu,...
            round(binSize*datSamp/1000),round(timeWin/2*1000/binSize),...
            datSamp,[1:size(unitCCG.cellLayer,1)],normalization,...
            [time(n)-timeWin/2 time(n)+timeWin/2]*datSamp);
        if isempty(unitCCG.yo) 
            unitCCG.yo = zeros([length(time) size(permute(ccgTemp,[2,3,1]))]);
        end
        unitCCG.yo(n,:,:,:) = permute(ccgTemp,[2,3,1]);
        % calculate rate
        for k=1:size(unitCCG.cellLayer,1)
            selInd = find(catClu==k & ...
                catRes>=(time(n)-timeWin/2)*datSamp & catRes<=(time(n)+timeWin/2)*datSamp);
            unitRate(n,k) = length(selInd)/timeWin;
        end
    end
    save([fileBase '/' spectAnalDir 'unitCCGBin' num2str(binSize) normalization '.mat'],SaveAsV6,'unitCCG');
    save([fileBase '/' spectAnalDir 'unitRate.mat'],SaveAsV6,'unitRate');
end
% catch
%     junk = lasterror
%     %junk.stack
%     keyboard
% end

SetWarnings(prevWarnSettings);