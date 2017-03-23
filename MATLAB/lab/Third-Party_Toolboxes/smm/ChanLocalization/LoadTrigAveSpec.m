function [outSpec fo to coi outSeg] = LoadTrigAveSpec(animalDirs,filesNameCell,...
    fileExt,trigFileBase,varargin)
chanLocVersion = DefaultArgs(varargin,'Min');


% prevWarnSettings = SetWarnings({'off','LoadDesigVar:fileNotFound';...
%    'off', 'MATLAB:divideByZero'});
safetyFactor = 1000;
chanInfoDir = 'ChanInfo/';
cwd = pwd;
outStruct = [];
for k=1:length(animalDirs)
    for m=1:length(animalDirs{k})
        fprintf('\ncd %s\n',animalDirs{k}{m})
        cd(animalDirs{k}{m})
        
        files = {};
        for j=1:length(filesNameCell)
            files = cat(1,files,LoadVar(['FileInfo/' filesNameCell{j}]));
        end
        files
        %selChan = LoadVar([chanInfoDir 'selChan_' chanLocVersion fileExt '.mat']);
        chanLoc = LoadVar([chanInfoDir 'ChanLoc_' chanLocVersion fileExt '.mat']);
        badChans = load([chanInfoDir 'BadChan' fileExt '.txt']);
        anatFields = fieldnames(chanLoc);

try        % Sum Files w/in a day
        for j=1:length(files)
            inFile = [files{j} '/' trigFileBase fileExt '.mat'];
%             inFile = [sleepFiles{j} '/' fileBase fileExt '.mat'];
            fprintf('Loading %s\n',inFile);
            inSpec = LoadVar(inFile);
            if j==1 | isempty(tempSpec);
                tempSpec = zeros(size(inSpec.yo));
                numSegFiles = 0;
            end
            if ~isempty(inSpec.yo)
%                 tempSpec = tempSpec + 10.^((inSpec.yo)/10) * inSpec.numSeg / safetyFactor;
                tempSpec = tempSpec + inSpec.yo * inSpec.numSeg / safetyFactor;
                numSegFiles = numSegFiles + inSpec.numSeg / safetyFactor;
            end
            if ~exist('fo','var') | isempty(fo)
                fo = inSpec.fo;
                to = inSpec.to;
                coi = inSpec.coi;
            end
            clear inSpec
        end
%         tempSpec = tempSpec / numSegFiles;
        for p=1:length(anatFields)
            for q=1:length(chanLoc.(anatFields{p}))
                % Average Chans w/in a Shank
                goodChans = setdiff(chanLoc.(anatFields{p}){q},badChans);               
%                         union(badChans,selChanNums(1:length(selChanNums)<=n)));  
                % Sum Files Across Days
                if m==1
                    if isempty(goodChans)
                        numSegDays(p,q) = 0;
                        tempSpec2{p,q} = zeros(1,size(tempSpec,2),size(tempSpec,3));
                    else
                        numSegDays(p,q) = numSegFiles;
                        tempSpec2{p,q} = mean(tempSpec(goodChans,:,:),1); %* numSegFiles;
                    end
                else
                    if ~isempty(goodChans)
                        numSegDays(p,q) = numSegDays(p,q) + numSegFiles;
                        tempSpec2{p,q} = tempSpec2{p,q} + mean(tempSpec(goodChans,:,:),1); %* numSegFiles;
                    end
                end
            end
        end
        catch
            junk = lasterror
            junk.stack(1)
            keyboard
        end
    end
    % Divide by Total Segs
    % Cat Across Animals/Shanks
    for p=1:length(anatFields)
        if k==1
            outSpec{p} = [];
            outSeg{p} = [];
        end
        for q=1:length(chanLoc.(anatFields{p}))
            if numSegDays(p,q) ~= 0
%                 outSpec{p} = cat(1,outSpec{p},10*log10(tempSpec2{p,q} / numSegDays(p,q)));
                outSpec{p} = cat(1,outSpec{p}, tempSpec2{p,q} / numSegDays(p,q) );
                outSeg{p} = cat(1,outSeg{p},numSegDays(p,q)*safetyFactor);
            end
        end
    end
end
cd(cwd)


return
         
% output{numAnatFields,numSelChan}(numAnimalsXnumShanks,freq,time)
% 
% ave(files)
% ave(goodChans)
% ave(days)
% cat(shanks)
% cat(animals)
        
        


