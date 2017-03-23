analDirs = {'/BEEF02/smm/sm9614_Analysis/4-17-05/analysis','/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/'};

spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
selAnatRegions = {'or','ca1Pyr','rad','lm','mol','gran','hil','ca3Pyr'};
chanLocVersion = 'Full';

%for each analDir
%make trialsXcells mat
%make mazeLocName vec
%make chan vec
%make cellType vec
%for each MR
%make firingRateStruct vec
%end
%end
%for each MR
cwd = pwd;
cellTypesVecAll = [];
chanLayerVecAll = [];
firingRateStruct = [];
for a=1:length(analDirs)
    cd(analDirs{a})
    fileBaseCell = LoadVar('FileInfo/ZMazeFiles');
    chanLoc = LoadVar(['ChanInfo/ChanLoc_' chanLocVersion '.eeg.mat']);
    cellType = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
    cluLoc = load([fileBaseCell{1} '/' fileBaseCell{1} '.cluloc']);
    trialsByCells = [];
    mazeLocVec = {};
    cellTypesVec = {};
    chanLayerVec = {};
    for f=1:length(fileBaseCell)
        fileBase = fileBaseCell{f};
        mazeLocName = LoadVar([fileBase '/' spectAnalDir 'mazeLocName.mat']);
        firingRate = LoadVar([fileBase '/' spectAnalDir 'firingRate.mat']);
        tempTrialsByCells = [];
        elecNames = fieldnames(firingRate);
        for j=1:length(elecNames)
            cluNames = fieldnames(firingRate.(elecNames{j}));
            for k=1:length(cluNames)
                tempTrialsByCells = cat(2,tempTrialsByCells,firingRate.(elecNames{j}).(cluNames{k}));
                if f==1
                    cellTypesVec = cat(2,cellTypesVec,...
                        cellType([cellType{:,1}]==str2num(elecNames{j}(5:end))...
                        & [cellType{:,2}]==str2num(cluNames{k}(4:end)),3));
                    chanLayerVec = cat(2,chanLayerVec,...
                        GetChanLayer(cluLoc(cluLoc(:,1)==str2num(elecNames{j}(5:end))...
                        & cluLoc(:,2)==str2num(cluNames{k}(4:end)),3),chanLoc));
                end
            end
        end
        trialsByCells = cat(1,trialsByCells,tempTrialsByCells);
        mazeLocVec = cat(1,mazeLocVec,mazeLocName);
    end
    mazeLocFieldNames = unique(mazeLocName);
    for j=1:length(mazeLocFieldNames)
        if a==1
            firingRateStruct.(mazeLocFieldNames{j}) = mean(trialsByCells(strcmp(mazeLocVec,mazeLocFieldNames{j}),:));
        else
            firingRateStruct.(mazeLocFieldNames{j}) = cat(2,firingRateStruct.(mazeLocFieldNames{j}),...
                mean(trialsByCells(strcmp(mazeLocVec,mazeLocFieldNames{j}),:)));
        end

    end
    cellTypesVecAll = cat(2,cellTypesVecAll,cellTypesVec);
    chanLayerVecAll = cat(2,chanLayerVecAll,chanLayerVec);
end
cd(cwd);


figure
cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for j=1:length(mazeLocFieldNames)
        for k=1:length(cellTypeLabels)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            plot(j,sum(firingRateStruct.(mazeLocFieldNames{j})(strcmp(chanLayerVecAll,selAnatRegions{m})...
                & strcmp(cellTypesVecAll,cellTypeLabels(k))))...
                /sum(strcmp(chanLayerVecAll,selAnatRegions{m})...
                & strcmp(cellTypesVecAll,cellTypeLabels(k))),'o');
            title([cellTypeLabels(k) '=' num2str(sum(strcmp(chanLayerVecAll,selAnatRegions{m})...
                & strcmp(cellTypesVecAll,cellTypeLabels(k))))])
            ylabel(selAnatRegions{m})
            set(gca,'xtick',[1:length(mazeLocFieldNames)],'xticklabel',mazeLocFieldNames(:))
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








for a=1:length(analDirs)
    cd(analDirs{a})
fileBaseCell = LoadVar('FileInfo/AlterFiles');
spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
selAnatRegions = {'mol','gran','hil','ca3Pyr'};
chanLocVersion = 'Full';
chanLoc = LoadVar(['ChanInfo/ChanLoc_' chanLocVersion '.eeg.mat']);
cellType = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
% anatNames = fieldnames(chanLoc);
% selAnat
cluLoc = load([fileBaseCell{1} '/' fileBaseCell{1} '.cluloc']);
for k=1:length(selAnatRegions)
    selInd = ismember(cluLoc(:,3),[chanLoc.(selAnatRegions{k}){:}]);
    selFetClu{k} = cluLoc(selInd,1:2);
    if a==1
        selCellType{k} = [];
    end
    selCellType{k} = cat(1,selCellType{k},cellType(selInd,3);
end

mazeLocName = LoadVar([fileBaseCell{1} '/' spectAnalDir 'mazeLocName.mat']);
for m=1:length(mazeLocFieldNames)
    for j=1:length(fileBaseCell)
        fileBase = fileBaseCell{j};
        firingRateStruct.(mazeLocFieldNames{m}){j} = [];
        firingRate = LoadVar([fileBase '/' spectAnalDir 'firingRate.mat']);
        for k=1:length(selAnatRegions)
            mazeLocFieldNames = unique(mazeLocName);
            for n=1:length(selFetClu{k})
                firingRateStruct.(mazeLocFieldNames{m}){j} = cat(1,firingRateStruct.(mazeLocFieldNames{m}){j}...
                    ,sum(firingRate.(['elec' num2str(selFetClu{k}(n,1))]).(['clu' num2str(selFetClu{k}(n,2))])...
                    (strcmp(mazeLocFieldNames{m},mazeLocName)))...
                    /sum(strcmp(mazeLocFieldNames{m},mazeLocName)));
            end
        end
    end
    if a==1
        firingRateStruct2.(mazeLocFieldNames{m}) = [];
    end
    firingRateStruct2.(mazeLocFieldNames{m}) = cat(1,firingRateStruct2.(mazeLocFieldNames{m}),...
        mean(cat(2,firingRateStruct.(mazeLocFieldNames{m}){:}),2));    
end
for m=1:length(mazeLocFieldNames)
    if a==1
        firingRateStruct2.(mazeLocFieldNames{m}) = [];
    end
    firingRateStruct2.(mazeLocFieldNames{m}) = cat(1,firingRateStruct2.(mazeLocFieldNames{m}),...
        mean(cat(2,firingRateStruct.(mazeLocFieldNames{m}){:}),2));
end
selCellType2{m} = cat(1,selCellType2{m},selCellType

figure
cellTypeLabels = ['w' 'n']
for m=1:length(selAnatRegions)
    for j=1:length(mazeLocFieldNames)
        for k=1:length(cellTypeLabels)
            subplot(length(selAnatRegions),length(cellTypeLabels),(m-1)*length(cellTypeLabels)+k)
            hold on
            plot(j,sum(firingRateStruct2.(mazeLocFieldNames{j})([selCellType2{m}{:}]==...
                cellTypeLabels(k)))/sum([selCellType2{m}{:}]==cellTypeLabels(k)),'o')
            title([cellTypeLabels(k) '=' num2str(sum([selCellType2{m}{:}]==cellTypeLabels(k)))])
            ylabel(selAnatRegions{m})
            set(gca,'xtick',[1:length(mazeLocFieldNames)],'xticklabel',mazeLocFieldNames(:))
        end
    end
end

%         for m=unique(selFetClu{k}(:,1))'
%             clu = load([fileBase '.clu.' num2str(m)]);
%             res = load([fileBase '.res.' num2str(m)]);
%             for n=[selFetClu{k}(ismember(selFetClu{k}(:,1),m),2)]'
%                 selRes = res(clu(2:end)==n);
%                 fprintf('%i,%i\n',m,n);
%             end
%         end
%     end
% end
% 

