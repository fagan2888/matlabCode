function ExtractGlmBarh04(depVarCell,spectAnalDir,fileExt,chanLocVersion,analRoutine,analDirs,varargin)
[saveDir statsDir] = DefaultArgs(varargin,{'/u12/smm/public_html/NewFigs/REMPaper/UnitFieldMetaAnal/','GlmWholeModel08'});
reportFigBool = 0;
chanInfoDir = 'ChanInfo/';

prevWarn = SetWarnings({'off','MATLAB:divideByZero'});

% depVarPoss = {...
%     'gammaCohMean60-120Hz',...
%     'gammaCohMean40-100Hz',...
%     'gammaCohMean40-120Hz',...
%     'gammaCohMean50-100Hz',...
%     'gammaCohMean50-120Hz',...
%     'thetaCohMean6-12Hz',...
%     'thetaCohPeakSelChF6-12Hz',...
%     'thetaCohMedian6-12Hz',...
%     'gammaCohMedian60-120Hz',...
%     'thetaCohPeakLMF6-12Hz',...
%     'thetaPowIntg4-12Hz',...
%     'thetaPowIntg6-12Hz',...
%     'gammaPowIntg40-100Hz',...
%     'gammaPowIntg40-120Hz',...
%     'gammaPowIntg50-100Hz',...
%     'gammaPowIntg50-120Hz',...
%     'gammaCohMean40-100Hz',...
%     'thetaCohMean4-12Hz',...
%     'thetaPhaseMean4-12Hz',...
%     'gammaPhaseMean40-100Hz',...
%     };
% 
% 
% depVarCell = intersect(depVarCell,depVarPoss);

anatNames = fieldnames(LoadVar([analDirs{1}{1} 'ChanInfo/ChanLoc_' chanLocVersion fileExt]));

for a=1:length(depVarCell)
    depVar = depVarCell{a}

    if ~isempty([strfind(depVar,'Phase') strfind(depVar,'phase')])
        depVarType = 'phase';
        selChanNames = fieldnames(LoadVar([analDirs{1}{1} 'ChanInfo/SelChan' fileExt]));
        selChanBool = 1;
    elseif ~isempty([strfind(depVar,'Coh') strfind(depVar,'coh')])
        depVarType = 'coh';
        selChanNames = fieldnames(LoadVar([analDirs{1}{1} 'ChanInfo/SelChan' fileExt]));
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
        
    dataStruct = GlmResultsLoad01(depVar,chanLocVersion,spectAnalDir,fileExt,analRoutine,analDirs,statsDir,selChanBool,saveDir,reportFigBool);
    dataStruct = GlmResultsCatAnimal(dataStruct,0);
    
     varNames = fieldnames(dataStruct.coeffs);
     
            outCell = {};
    varNames = fieldnames(dataStruct.coeffs);
    for k=1:length(anatNames)
            tempMean = [];
            tempstd = [];
            for j=2:length(varNames)
                tempMean(j) = mean(dataStruct.coeffs.(varNames{j}){k,1},1);
                tempStd(j) = std(dataStruct.coeffs.(varNames{j}){k,1},1);
            end
            for j=2:length(varNames)
                outCell = cat(1,outCell,...
                    cat(2,anatNames(k),selChanNames(1),varNames(j),...
                    tempMean(j)/mean(tempStd)));
            end
    end
 
    
% outCell = {};
%     varNames = fieldnames(dataStruct.coeffs);
%     for j=2:length(varNames)
%     for k=1:length(anatNames)
%             outCell = cat(1,outCell,...
%                 cat(2,anatNames(k),varNames(j),...
%                 mean(dataStruct.coeffs.(varNames{j}){k},1)));
%     end
%     end
   outCell = cat(2,repmat(depVarCell(a),[size(outCell,1),1]),...
       repmat({Dot2Underscore(fileExt)},[size(outCell,1),1]),...
       outCell);
            
    outDir = [saveDir SC(analRoutine(1:end-3))];
    mkdir(outDir)
        save([outDir depVarCell{a} ...
            Dot2Underscore(fileExt) '.mat'],SaveAsV6,'outCell');
end
     
%      [nLayers nSelChan] = size(dataStruct.coeffs.(varNames{1}));
% %     alpha = baseAlpha/(nLayers*nSelChan);
%     for b=1:nSelChan
%         fileName = [depVar '_' selChanNames{b} '_barh'];

    