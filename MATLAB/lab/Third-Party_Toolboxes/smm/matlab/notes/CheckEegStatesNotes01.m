CheckEegStatesNotes01

addpath /u12/antsiro/matlab/draft
addpath /u12/antsiro/matlab/General
addpath /u12/smm/matlab/Ant


fileExt = '.eeg'
selChan = Struct2CellArray(LoadVar(['../ChanInfo/SelChan' fileExt]),[],1)
nChan = load(['../ChanInfo/NChan' fileExt '.txt'])

[40 56 57 74 92]

cwd = pwd;
fileBase = fileBaseCell{15}
cd([cwd '/' fileBase])
CheckEegStates(fileBase,'REM',[],[0 300],[selChan{:,2}],nChan,fileExt,0.5)

remFiles = {};
for j=1:length(fileBaseCell)
    if exist([fileBaseCell{j} '/' fileBaseCell{j} '.sts.REM'],'file')
        remFiles = cat(1,remFiles,fileBaseCell(j));
    end
end
remFiles

save('FileInfo/RemFiles.mat',SaveAsV6,'remFiles')


CheckEegStates_junk(fileBase,'REM',[],[0 300],[selChan{4,2}],nChan,fileExt,0.5)
CheckEegStates(fileBase,'REM',[],[0 300],[selChan{4,2}],nChan,fileExt,0.5)
 plot(t,log10(sum(y(:,f>5 & f<=12,4),2)./sum(y(:,f>=1 & f<=3,4,:),2)))
set(gca,'xlim',[0 300])

convSize = 50;
smoothY = Conv2Trim(ones(convSize,1)/convSize,1,(y));
% plot(t,log10(sum(y(:,f>4 & f<=8),2)./sum(y(:,f>=1 & f<=4),2)))
%  plot(t,10*log10(sum(smoothY(:,f>4 & f<=8),2)./sum(y(:,f>=1 & f<=4),2)))
convSize = 50;
delta = (f<=4) | (f>12 & f<30);
% delta = (f<=4) ;
t_d = ConvTrim(sum(smoothY(:,f>4 & f<12),2)./sum(y(:,delta),2),ones(convSize,1)/convSize);
 plot(t,10*log10(t_d))
 set(gca,'xlim',[0 300])

t_d = sum(y(:,f>4 & f<=8),2)./sum(y(:,f>=1 & f<=4),2)
set(gca,'xlim',[0 300])




