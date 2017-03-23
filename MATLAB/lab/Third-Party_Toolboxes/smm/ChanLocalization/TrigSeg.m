% function TrigSeg(fileBaseCell,trigFileName,trigFs,segLen,fileExtCell,nChanCell,varargin)
% [Fs,bps] = ...
%     DefaultArgs(varargin,{1250,2});
function TrigSeg(fileBaseCell,trigFileName,trigFs,segLen,fileExtCell,nChanCell,varargin)
[Fs,bps] = ...
    DefaultArgs(varargin,{1250,2});

infoStruct.trigFileName = trigFileName;
infoStruct.trigFs = trigFs;
infoStruct.segLen = segLen;
infoStruct.Fs = Fs;
infoStruct.bps = bps;
infoStruct.date = date;

for m=1:length(fileBaseCell)
    for k=1:length(fileExtCell)
        fileExt = fileExtCell{k};
        nChan = nChanCell{k};
        infoStruct.fileBase = fileBaseCell{m};
        infoStruct.fileExt = fileExt;
        infoStruct.nChan = nChan;
        
        fprintf('processing: %s\n',[SC(fileBaseCell{m}) trigFileName])

        time = load([SC(fileBaseCell{m}) trigFileName]);
        time((time/trigFs-segLen/2)<0) = [];
        segs = zeros([size(time,1) nChan round(segLen*Fs)]);
        for n = 1:size(time,1)
            segs(n,:,:) = bload([SC(fileBaseCell{m}) fileBaseCell{m} fileExt],...
                [nChan round(segLen*Fs)],...
                round((time(n)/trigFs-segLen/2)*Fs*nChan*bps));
        end
        outFileName = [trigFileName '_' 'TrigSegs' num2str(segLen) 's' fileExt '.mat'];
        fprintf(['Saving: ' outFileName '\n']);
        save([SC(fileBaseCell{m}) outFileName],SaveAsV6,'segs','time','infoStruct')

    end
end