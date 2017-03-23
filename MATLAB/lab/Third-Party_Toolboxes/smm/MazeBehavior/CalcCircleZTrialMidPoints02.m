function trialMidRegionsStruct = CalcTrialMidPoints02(allMazeRegions,waterPorts,startArm,endArm,mazeRegionsStruct,plotFig,plotWindow)
% function trialMidRegionsStruct = CalcTrialMidPoints02(allMazeRegions,waterPorts,mazeRegionsStruct,plotFig,plotWindow)


if ~exist('plotFig','var')
    plotFig = 0;
end
whlSamp = 39.065;


%[whlm n] = size(whlDat);
mazeRegionNames = fieldnames(mazeRegionsStruct);
trialMazeRegionsStruct = [];
trialMidRegionsStruct = [];
%plot(allMazeRegions(:,1),allMazeRegions(:,2))
%enterWP = find(waterPorts(:,1)~=-1,1)
trialbegin = find(startArm(:,1)~=-1,1);
while ~isempty(trialbegin),
    enterEA = trialbegin + find(endArm(trialbegin+1:end,1)~=-1,1);
    trialend = enterEA(1) + find(waterPorts(enterEA(1)+1:end,1)~=-1,1);
    if isempty(trialend)
        breaking = 1
        break;
    end
%     trialend = enterWP + find(startArm(enterWP+1:end,1)~=-1,1) -1;
%     if isempty(trialend)
%         trialend = enterWP -1 + find(waterPorts(enterWP:end,1)~=-1,1,'last');
%     end
    for i=1:length(mazeRegionNames)
        mazeRegion = getfield(mazeRegionsStruct,mazeRegionNames{i},'data');
        trialMazeRegion = trialbegin(1)-1+find(mazeRegion(trialbegin(1):trialend(1),1)~=-1);
        trialMazeRegionsStruct = setfield(trialMazeRegionsStruct,mazeRegionNames{i},trialMazeRegion)
        if isempty(trialMazeRegion)
            fprintf('MazeRegion: %s missing measurements, trialbegin = %i, trialend = %i: SKIPPING TRIAL\n', mazeRegionNames{i},trialbegin(1),trialend(1));
            skipTrial = 1;
            %keyboard
        else
            skipTrial = 0;
        end
    end
    trialbegin = trialend(1) + find(startArm(trialend(1)+1:end,1)~=-1,1);
    
%     trialbegin = trialend(1) + find(startArm(trialend(1)+1:end,1)~=-1,1);
    if ~skipTrial
        %trialMazeRegionsStruct.returnArm = trialbegin(1)-1+find(mazeRegionsStruct.returnArm(trialbegin(1):(trialend(1)-1),1)~=-1);
        %trialMazeRegionsStruct.centerArm = trialbegin(1)-1+find(centerarm(trialbegin(1):(trialend(1)-1),1)~=-1);
        %trialMazeRegionsStruct.Tjunction = trialbegin(1)-1+find(choicepoint(trialbegin(1):(trialend(1)-1),1)~=-1);
        %trialMazeRegionsStruct.returnArm = trialbegin(1)-1+find(goalarm(trialbegin(1):(trialend(1)-1),1)~=-1);

        

        %if ~isempty(trialreturnarm) & ~isempty(trialcenterarm) & ~isempty(trialchoicepoint) & ~isempty(trialgoalarm)
        if plotFig
            figure(plotFig)
            clf
            plot(allMazeRegions(:,1),allMazeRegions(:,2),'y.')
            hold on
            plotColors = [0 0 1; 1 0 0; 0 0 0; 0 1 1;1 0 1;0 0 0];
            for i=1:length(mazeRegionNames)
                mazeRegion = getfield(mazeRegionsStruct,mazeRegionNames{i},'data');
                trialMazeRegion = getfield(trialMazeRegionsStruct,mazeRegionNames{i});
                try
                    if plotWindow==0
                        plot(mazeRegion(trialMazeRegion,1),mazeRegion(trialMazeRegion,2),'.','color',plotColors(i,:),'markersize',7);
                    else
                        plot(mazeRegion(trialMazeRegion,1),mazeRegion(trialMazeRegion,2),'.','color',clip(0.75+plotColors(i,:),0,1),'markersize',7);
                    end
                catch
                    fprintf('plotting failed\n')
                    keyboard
                end
                %plot(returnarm(trialreturnarm,1),returnarm(trialreturnarm,2),'.','color',[0 0 1],'markersize',7);
                %plot(centerarm(trialcenterarm,1),centerarm(trialcenterarm,2),'.','color',[1 0 0],'markersize',7);
                %plot(choicepoint(trialchoicepoint,1),choicepoint(trialchoicepoint,2),'.','color',[0 0 0],'markersize',7);
                %plot(goalarm(trialgoalarm,1),goalarm(trialgoalarm,2),'.','color',[0 1 1],'markersize',7);
                set(gca,'xlim',[0 368],'ylim',[0 240]);
            end
        end
        for i=1:length(mazeRegionNames)
            mazeRegion = getfield(mazeRegionsStruct,mazeRegionNames{i},'data');
            trialMazeRegion = getfield(trialMazeRegionsStruct,mazeRegionNames{i});
            locationCalc = getfield(mazeRegionsStruct,mazeRegionNames{i},'locationCalc');
            timeOffset = getfield(mazeRegionsStruct,mazeRegionNames{i},'timeOffset');
            if ~isempty(trialMazeRegion)
                if  strcmp(locationCalc,'nearestAbsDist');
                    % nearestAbsDist
                    midPoint = (mazeRegion(trialMazeRegion,1) - mean([max(mazeRegion(trialMazeRegion,1)) min(mazeRegion(trialMazeRegion,1))])).^2 + ...
                        (mazeRegion(trialMazeRegion,2) - mean([max(mazeRegion(trialMazeRegion,2)) min(mazeRegion(trialMazeRegion,2))])).^2;
                    midPoint = find(midPoint == min(midPoint)); 
                end
                if strcmp(locationCalc,'farestXdist');
                    % farestXdist
                    xmid = mean(allMazeRegions(allMazeRegions(:,1)~=-1,1));
                    midPoint = find(abs(mazeRegion(trialMazeRegion,1)-xmid)==max(abs(mazeRegion(trialMazeRegion,1)-xmid)));
                    midPoint = midPoint(1);
                end
                if strcmp(locationCalc,'start');
                    midPoint = 1;
                end
                if strcmp(locationCalc,'end');
                    midPoint = length(trialMazeRegion);
                end
                if isnumeric(locationCalc)
                    % x
                    midPointX = min(mazeRegion(trialMazeRegion,1)) + (max(mazeRegion(trialMazeRegion,1)) - min(mazeRegion(trialMazeRegion,1)))*locationCalc;
                    midPoint = find(abs(mazeRegion(trialMazeRegion,1) - midPointX) == min(abs(mazeRegion(trialMazeRegion,1) - midPointX)));
                end

                if ~isfield(trialMidRegionsStruct,mazeRegionNames{i})
                    trial = 0;
                else
                    trial = length(getfield(trialMidRegionsStruct,mazeRegionNames{i}));
                end
                trialMidRegionsStruct = setfield(trialMidRegionsStruct,mazeRegionNames{i},{trial+1},trialMazeRegion(midPoint(1))+round(timeOffset*whlSamp));
            else
                trialMidRegionsStruct = setfield(trialMidRegionsStruct,mazeRegionNames{i},{trial+1},NaN);
            end
        end

        if plotFig
            for i=1:length(mazeRegionNames)

                midPoint = getfield(trialMidRegionsStruct,mazeRegionNames{i},{trial+1});
                if ~isnan(midPoint)
                    if plotWindow~=0
                        plot(allMazeRegions(midPoint-round(plotWindow*whlSamp):midPoint+round(plotWindow*whlSamp),1),...
                            allMazeRegions(midPoint-round(plotWindow*whlSamp):midPoint+round(plotWindow*whlSamp),2),...
                            '.','color',clip(plotColors(i,:),0,1),'markersize',7+10*mod(i+1,2));
                    end
                    plot(allMazeRegions(midPoint,1),allMazeRegions(midPoint,2),'.','color',[0 1 0],'markersize',20);
                    
                end
            end
            answer = 'junk';
            while ~strcmp(answer,'s') & ~strcmp(answer,'') & ~strcmp(answer,'d')
                answer = input('Save (s) or delete (d)? ','s');
                if strcmp(answer,'d')
                    for i=1:length(mazeRegionNames)
                        trialMidRegionsStruct = setfield(trialMidRegionsStruct,mazeRegionNames{i},{trial+1},[]);
                    end
                end
            end
        end
    end
end
return