function PlotAnatMazeRegionZ(taskType,fileBaseMat,fileNameFormat,fileExt,chanMat,badchan,lowCut,highCut,onePointBool,samescale,dbscale)


if fileNameFormat == 0,
    if onePointBool
        fileName = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
    else
        fileName = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_mean_AnatMazeRegionPow.mat'];
    end
end
if fileNameFormat == 2,
    if onePointBool
        fileName = [taskType '_' fileBaseMat(1,[1:10]) '-' fileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_point_AnatMazeRegionPow.mat'];
    else
        fileName = [taskType '_' fileBaseMat(1,[1:10]) '-' fileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(lowCut) '-' num2str(highCut) 'Hz_mean_AnatMazeRegionPow.mat'];
    end
end

if exist(fileName,'file')
    fprintf('loading %s\n',fileName)
    load(fileName);
else
    fileName
    ERROR_RUN_CalcAnatMazeRegionPow
end


if ~exist('samescale','var')
    samescale = 0;
end
if ~exist('badchan','var')
    badchan = 0;
end
if ~exist('dbscale','var')
    dbscale = 0;
end
if ~exist('onePointBool','var')
    onePointBool = 0;
end


centerAnatPowMat = zeros(size(chanMat))*NaN;
rewardAnatPowMat = zeros(size(chanMat))*NaN;
returnAnatPowMat = zeros(size(chanMat))*NaN;
choiceAnatPowmat = zeros(size(chanMat))*NaN;

avepowperchan =  zeros(size(chanMat))*NaN;
sdPowerPerChan =  zeros(size(chanMat))*NaN;

avecenterAnatPowMat = zeros(size(chanMat))*NaN;
averewardAnatPowMat = zeros(size(chanMat))*NaN;
avereturnAnatPowMat = zeros(size(chanMat))*NaN;
avechoiceAnatPowmat = zeros(size(chanMat))*NaN;

zCenterAnatPowMat = zeros(size(chanMat))*NaN;
zRewardAnatPowMat = zeros(size(chanMat))*NaN;
zReturnAnatPowMat = zeros(size(chanMat))*NaN;
zChoiceAnatPowmat = zeros(size(chanMat))*NaN;

zCenterAnatPowMat2 = zeros(size(chanMat))*NaN;
zRewardAnatPowMat2 = zeros(size(chanMat))*NaN;
zReturnAnatPowMat2 = zeros(size(chanMat))*NaN;
zChoiceAnatPowmat2 = zeros(size(chanMat))*NaN;

zCenterAnatPowMat3 = zeros(size(chanMat))*NaN;
zRewardAnatPowMat3 = zeros(size(chanMat))*NaN;
zReturnAnatPowMat3 = zeros(size(chanMat))*NaN;
zChoiceAnatPowmat3 = zeros(size(chanMat))*NaN;

if dbscale
    centerArmPowMat = 10.*log10(centerArmPowMat);
    goalArmPowMat = 10.*log10(goalArmPowMat);
    returnArmPowMat = 10.*log10(returnArmPowMat);
    tJunctionPowMat = 10.*log10(TjunctionPowMat);
end


[nChanY nChanX] = size(chanMat);
for x=1:nChanX
    for y=1:nChanY
    if isempty(find(badchan==chanMat(y,x))), % if the channel isn't bad
        
        %col = ceil(channels(i)/nrow);
        %row = mod(channels(i)-1,nrow)+1;
        
%        meanReturn = mean(returnArmPowMat,1);
%meanCenter = mean(centerArmPowMat,1);
%meanCP = mean(tJunctionPowMat,1);
%meanChoice = mean(goalArmPowMat,1);


        centerAnatPowMat(y,x) = mean(centerArmPowMat(:,chanMat(y,x)));
        rewardAnatPowMat(y,x) = mean(goalArmPowMat(:,chanMat(y,x)));
        returnAnatPowMat(y,x) = mean(returnArmPowMat(:,chanMat(y,x)));
        choiceAnatPowmat(y,x) = mean(TjunctionPowMat(:,chanMat(y,x)));

        avePowPerTrial = mean([centerArmPowMat(:,chanMat(y,x)) goalArmPowMat(:,chanMat(y,x)) returnArmPowMat(:,chanMat(y,x)) tJunctionPowMat(:,chanMat(y,x))],2);
        avepowperchan(y,x) = mean(avePowPerTrial);
        sdPowerPerChan(y,x) = std(avePowPerTrial);
        sdPowerPerChan2(y,x) = mean([std(centerArmPowMat(:,chanMat(y,x))) std(goalArmPowMat(:,chanMat(y,x))) std(returnArmPowMat(:,chanMat(y,x))) std(tJunctionPowMat(:,chanMat(y,x)))],2);

        sdcenterAnatPowMat(y,x) = std(centerArmPowMat(:,chanMat(y,x)));
        sdrewardAnatPowMat(y,x) = std(goalArmPowMat(:,chanMat(y,x)));
        sdreturnAnatPowMat(y,x) = std(returnArmPowMat(:,chanMat(y,x)));
        sdchoiceAnatPowMat(y,x) = std(tJunctionPowMat(:,chanMat(y,x)));

        
        %        centerAnatPowMat(y,x) = meanCenter(chanMat(y,x));
 %       rewardAnatPowMat(y,x) = meanChoice(chanMat(y,x));
 %       returnAnatPowMat(y,x) = meanReturn(chanMat(y,x));
%        choiceAnatPowmat(y,x) = meanCP(chanMat(y,x));
%        avepowperchan(y,x) = mean([centerAnatPowMat(y,x) rewardAnatPowMat(y,x) returnAnatPowMat(y,x) choiceAnatPowmat(y,x)]);
        if dbscale
            avecenterAnatPowMat(y,x) = centerAnatPowMat(y,x)-avepowperchan(y,x);
            averewardAnatPowMat(y,x) = rewardAnatPowMat(y,x)-avepowperchan(y,x);
            avereturnAnatPowMat(y,x) =  returnAnatPowMat(y,x)-avepowperchan(y,x);
            avechoiceAnatPowmat(y,x) = choiceAnatPowmat(y,x)-avepowperchan(y,x);
        else
            avecenterAnatPowMat(y,x) = centerAnatPowMat(y,x)./avepowperchan(y,x);
            averewardAnatPowMat(y,x) = rewardAnatPowMat(y,x)./avepowperchan(y,x);
            avereturnAnatPowMat(y,x) =  returnAnatPowMat(y,x)./avepowperchan(y,x);
            avechoiceAnatPowmat(y,x) = choiceAnatPowmat(y,x)./avepowperchan(y,x);
        end
        
        zCenterAnatPowMat(y,x) = (centerAnatPowMat(y,x) - avepowperchan(y,x))./sdPowerPerChan(y,x);
        zRewardAnatPowMat(y,x) = (rewardAnatPowMat(y,x) - avepowperchan(y,x))./sdPowerPerChan(y,x);
        zReturnAnatPowMat(y,x) = (returnAnatPowMat(y,x) - avepowperchan(y,x))./sdPowerPerChan(y,x);
        zChoiceAnatPowmat(y,x) = (choiceAnatPowmat(y,x) - avepowperchan(y,x))./sdPowerPerChan(y,x);
      
              
        zCenterAnatPowMat2(y,x) = (centerAnatPowMat(y,x) - avepowperchan(y,x))./sdPowerPerChan2(y,x);
        zRewardAnatPowMat2(y,x) = (rewardAnatPowMat(y,x) - avepowperchan(y,x))./sdPowerPerChan2(y,x);
        zReturnAnatPowMat2(y,x) = (returnAnatPowMat(y,x) - avepowperchan(y,x))./sdPowerPerChan2(y,x);
        zChoiceAnatPowmat2(y,x) = (choiceAnatPowmat(y,x) - avepowperchan(y,x))./sdPowerPerChan2(y,x);
      
        zCenterAnatPowMat3(y,x) = (centerAnatPowMat(y,x) - avepowperchan(y,x))./sdcenterAnatPowMat(y,x);
        zRewardAnatPowMat3(y,x) = (rewardAnatPowMat(y,x) - avepowperchan(y,x))./sdrewardAnatPowMat(y,x);
        zReturnAnatPowMat3(y,x) = (returnAnatPowMat(y,x) - avepowperchan(y,x))./sdreturnAnatPowMat(y,x);
        zChoiceAnatPowmat3(y,x) = (choiceAnatPowmat(y,x) - avepowperchan(y,x))./sdchoiceAnatPowMat(y,x);
       
        
%        zCenterAnatPowMat(y,x) = sdPowerPerChan(y,x);
%        zRewardAnatPowMat(y,x) = sdPowerPerChan(y,x);
%        zReturnAnatPowMat(y,x) = sdPowerPerChan(y,x);
%        zChoiceAnatPowmat(y,x) = sdPowerPerChan(y,x);

        
    end   
    end
end


if fileBaseMat(1,1:6) == 'sm9601'
    zeromat = ones(16,1)*NaN;
    
    centerAnatPowMat = [centerAnatPowMat(:,1) zeromat centerAnatPowMat(:,2:5)];
    rewardAnatPowMat = [rewardAnatPowMat(:,1) zeromat rewardAnatPowMat(:,2:5)];
    returnAnatPowMat = [returnAnatPowMat(:,1) zeromat returnAnatPowMat(:,2:5)];
    choiceAnatPowmat = [choiceAnatPowmat(:,1) zeromat choiceAnatPowmat(:,2:5)];

    avecenterAnatPowMat = [avecenterAnatPowMat(:,1) zeromat avecenterAnatPowMat(:,2:5)];
    averewardAnatPowMat = [averewardAnatPowMat(:,1) zeromat averewardAnatPowMat(:,2:5)];
    avereturnAnatPowMat = [avereturnAnatPowMat(:,1) zeromat avereturnAnatPowMat(:,2:5)];
    avechoiceAnatPowmat = [avechoiceAnatPowmat(:,1) zeromat avechoiceAnatPowmat(:,2:5)];
end

figureMats = {{returnAnatPowMat,[taskType ' mean return']},{choiceAnatPowmat,[taskType ' mean choice']};...
    {centerAnatPowMat,[taskType ' mean center']},{rewardAnatPowMat,[taskType ' mean reward']}};
nimagesc(figureMats,1,[]);
 
aveabsmin = 0;
aveabsmax = 4*10^5;
figureMats = {{sdreturnAnatPowMat,[taskType ' sd return']},{sdchoiceAnatPowMat,[taskType ' sd choice']};...
    {sdcenterAnatPowMat,[taskType ' sd center']},{sdrewardAnatPowMat,[taskType ' sd reward']}};
nimagesc(figureMats,1,[]);

figureMats = {{sdPowerPerChan2,[taskType ' mean(std(PowerPerChan2))']}};
nimagesc(figureMats,1,[]);

aveabsmin = 0.40;
aveabsmax = 1.6;
if dbscale
aveabsmin = -2.5;
aveabsmax = 2.5;
end
figureMats = {{avereturnAnatPowMat,[taskType ' norm return']},{avechoiceAnatPowmat,[taskType ' norm choice']};...
    {avecenterAnatPowMat,[taskType ' norm center']},{averewardAnatPowMat,[taskType ' norm reward']}};
nimagesc(figureMats,1,[]);

zabsmin = -3.01;
zabsmax = 3.01;
figureMats = {{zReturnAnatPowMat2,[taskType ' z return']},{zChoiceAnatPowmat2,[taskType ' z choice']};...
    {zCenterAnatPowMat2,[taskType ' z center']},{zRewardAnatPowMat2,[taskType ' z reward']}};
nimagesc(figureMats,1,[]);



if 0
    avecenterAnatPowMat(16) = avecenterAnatPowMat(15);
    avecenterAnatPowMat(81) = avecenterAnatPowMat(82);
    bscnoe =  [21 23 25 27 29 31 55 69 71 73 86 93]; % bad single channels not on end of shank
    for i=1:length(bscnoe)
        avecenterAnatPowMat(bscnoe(i)) = (avecenterAnatPowMat(bscnoe(i)-1) + avecenterAnatPowMat(bscnoe(i)+1))/2;
    end
    tempchan = (avecenterAnatPowMat(74) + avecenterAnatPowMat(77))/2;
    avecenterAnatPowMat(75) = (tempchan + avecenterAnatPowMat(74))/2;
    avecenterAnatPowMat(76) = (tempchan + avecenterAnatPowMat(77))/2;
    
    avechoiceAnatPowmat(16) = avechoiceAnatPowmat(15);
    avechoiceAnatPowmat(81) = avechoiceAnatPowmat(82);
    bscnoe =  [21 23 25 27 29 31 55 69 71 73 86 93]; % bad single channels not on end of shank
    for i=1:length(bscnoe)
        avechoiceAnatPowmat(bscnoe(i)) = (avechoiceAnatPowmat(bscnoe(i)-1) + avechoiceAnatPowmat(bscnoe(i)+1))/2;
    end
    tempchan = (avechoiceAnatPowmat(74) + avechoiceAnatPowmat(77))/2;
    avechoiceAnatPowmat(75) = (tempchan + avechoiceAnatPowmat(74))/2;
    avechoiceAnatPowmat(76) = (tempchan + avechoiceAnatPowmat(77))/2;

end

