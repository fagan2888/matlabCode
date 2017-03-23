function gobimat=XGobiThetaPow(filebasemat,fileext,nchannels,channels,lowband,highband)
% function multiplotspeedpowbat(filebasemat,fileext,nchannels,chanmat,lowband,highband,samescale,badchannels,xlimits)

if ~exist('trialtypesbool')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end
if ~exist('mazelocationsbool')
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                       %rp lp dp cp ca rca lca rra lra
end
% [1 0 1 0 0 0 0 0 0 0 0 0 0]
% [0 0 0 1 1 1 1 1 1]
if ~exist('depvariable')
    depvariable = 'speed';
end
if ~exist('samescale')
    samescale = 0;
end
if ~exist('badchannels')
    badchannels = 0;
end
avepowerdat = [];
speed = [];
accel = [];
whldat1 = [];
whldat2 = [];
whldat3 = [];

[numfiles n] = size(filebasemat);
numtrials = 0; % for counting trials
nxp = 0;
ncr = 0;
nir = 0;
ncl = 0;
nil = 0;
ncrp = 0;
nirp = 0;
nclp = 0;
nilp = 0;
ncrb = 0;
nirb = 0;
nclb = 0;
nilb = 0;

powmax = [];
powmin = [];
catfreqdat = [];
whlm = 0;

for i=1:numfiles

    filebase = filebasemat(i,:);
    whldat = load([filebase '.whl']);
    [tmpspeed tmpaccel] = mazespeedaccel(whldat);
    speed = [speed; tmpspeed];
    accel = [accel; tmpaccel];
    trialtypesbool = [1 0 1 0 0 0 0 0 0 0 0 0 0];
    whldat1 = [whldat1; loadmazetrialtypes(filebase,trialtypesbool, [0 0 0 1 1 1 1 1 1])];%blue

    dspowfilename = [filebase '_' num2str(lowband) '-' num2str(highband) 'Hz' fileext '.100DBdspow'];
    avepowerdat = [avepowerdat bload(dspowfilename,[nchannels inf],0,'int16')];
    if length(speed) > 4*10^4 & length(speed)<7*10^4
        filebase
    end
end

gobimat = [[1:length(speed)]' speed accel whldat1 avepowerdat(channels,:)'];
return