function TrialDesigLists(junk)
analDirs = {...
    '/BEEF02/smm/sm9614_Analysis/analysis02/',...
    '/BEEF02/smm/sm9608_Analysis/analysis02/',...
    '/BEEF01/smm/sm9601_Analysis/analysis03/',...
    '/BEEF01/smm/sm9603_Analysis/analysis04/',...
    };


for j=1:length(analDirs)
    cd(analDirs{j})
    %%%%%%%%%% RemVsThetaFreq %%%%%%%%%%
    if 0
        clear all
        trialDesigName = 'RemVsThetaFreq';
        contIndepCell = {'thetaFreq'};
        trialDesig.rem =  {'REM',[1 1 1 1 1 1 1 1 1 1 1 1 1],1,[1 1 1 1 1 1 1 1 1],1}                      
        trialMeanBool = 0;
        outlierDepth = 0;
        wholeModelSpec = 1;
        partialModelSpec = 1;
        ssType = 3;
        adjDayMedBool = 1;
        adjDayZbool = 0;
             save(trialDesigName,SaveAsV6,'trialDesig','contIndepCell','trialMeanBool','outlierDepth',...
        'wholeModelSpec','ssType','adjDayMedBool','adjDayZbool');
  end        
    %%%%%%%%%% RemVsRun %%%%%%%%%%
    if 0
        trialDesigName = 'RemVsRun';
        contIndepCell = {};
        trialDesig.maze = cat(1,{'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 1 1 1 1 1],0.5},...
                          {'circle',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 1 1],0.5});
        trialDesig.rem =  {'REM',[1 1 1 1 1 1 1 1 1 1 1 1 1],1,[1 1 1 1 1 1 1 1 1],1}                      
        trialMeanBool = 0;
        outlierDepth = 0;
        wholeModelSpec = 1;
        partialModelSpec = 1;
        ssType = 3;
        adjDayMedBool = 1;
        adjDayZbool = 0;
             save(trialDesigName,SaveAsV6,'trialDesig','contIndepCell','trialMeanBool','outlierDepth',...
        'wholeModelSpec','ssType','adjDayMedBool','adjDayZbool');
  end        
    %%%%%%%%%% RemVsRun_allTrials %%%%%%%%%%
    if 0
        trialDesigName = 'RemVsRun_allTrials';
        contIndepCell = {};
        trialDesig.maze = cat(1,{'alter',[1 1 1 1 1 1 1 1 1 1 1 1 1],0.6,[1 1 1 1 1 1 1 1 1],0.5},...
                               {'circle',[1 1 1 1 1 1 1 1 1 1 1 1 1],0.6,[1 1 1 1 1 1 1 1 1],0.5});
        trialDesig.rem =  {'REM',[1 1 1 1 1 1 1 1 1 1 1 1 1],1,[1 1 1 1 1 1 1 1 1],1}                      
        trialMeanBool = 0;
        outlierDepth = 0;
        wholeModelSpec = 1;
        partialModelSpec = 1;
        ssType = 3;
        adjDayMedBool = 1;
        adjDayZbool = 0;
            save(trialDesigName,SaveAsV6,'trialDesig','contIndepCell','trialMeanBool','outlierDepth',...
        'wholeModelSpec','ssType','adjDayMedBool','adjDayZbool');
   end        
    %%%%%%%%%% RemVsRun_thetaFreq %%%%%%%%%%
    if 0
        analDirs = {...
            'cd /BEEF02/smm/sm9614_Analysis/analysis02/',...
            'cd /BEEF02/smm/sm9608_Analysis/analysis02/',...
            'cd /BEEF01/smm/sm9601_Analysis/analysis03/',...
            'cd /BEEF01/smm/sm9603_Analysis/analysis04/',...
            };
        for j=1:length(analDirs)
            cd(analDirs{j})


            clear all
            trialDesigName = 'RemVsRun_thetaFreq';
            contIndepCell = {'thetaFreq'};
            contVarSub = {[2,34]};
            fileBaseMat = [LoadVar('RemFiles');LoadVar('MazeFiles')];
            trialDesig.maze = cat(1,{'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 1 1 1 1 1],0.5},...
                {'circle',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 1 1],0.5});
            trialDesig.rem =  {'REM',[1 1 1 1 1 1 1 1 1 1 1 1 1],1,[1 1 1 1 1 1 1 1 1],1};
            trialMeanBool = 0;
            outlierDepth = 0;
            wholeModelSpec = 2;
            partialModelSpec = 1;
            ssType = 3;
            adjDayMedBool = 1;
            adjDayZbool = 0;
            equalNbool = 1;

            if ~exist('TrialDesig/GlmWholeModel05/','dir')
                mkdir('TrialDesig/GlmWholeModel05/')
            end

            save(['TrialDesig/GlmWholeModel05/' trialDesigName],SaveAsV6,'trialDesig','contIndepCell','contVarSub','fileBaseMat',...
                'trialMeanBool','outlierDepth',...
                'wholeModelSpec','ssType','adjDayMedBool','adjDayZbool','equalNbool');
            clear('trialDesig','contIndepCell','contVarSub','fileBaseMat',...
                'trialMeanBool','outlierDepth',...
                'wholeModelSpec','ssType','adjDayMedBool','adjDayZbool','equalNbool');
        end
    end
    %%%%%%%%%% Alter_S0_A0 %%%%%%%%%%
    if 0
        trialDesigName = 'Alter_S0_A0';
        contIndepCell = {'speed.p0','accel.p0'};
        trialDesig.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
        trialDesig.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
        trialDesig.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
        trialDesig.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
        trialMeanBool = 1;
        outlierDepth = 1;
        wholeModelSpec = 1;
        partialModelSpec = 1;
        ssType = 3;
        adjDayMedBool = 1;
        adjDayZbool = 0;
    end
    %%%% Alter_Vs_Control_EachRegion_S0_A0 %%%%%%%%
    if 0
        trialDesigName = 'Alter_Vs_Control_EachRegion_S0_A0';
        contIndepCell = {'speed.p0','accel.p0'};
        trialDesig.alter.q1 = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
        trialDesig.alter.q2 = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
        trialDesig.alter.q3 = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
        trialDesig.alter.q4 =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
        if exist('CircleFiles.mat','file')
            trialDesig.control.q1 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5},...
                {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5});
            trialDesig.control.q2 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5},...
                {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5});
            trialDesig.control.q3 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5},...
                {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5});
            trialDesig.control.q4 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5},...
                {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5});
        end
        if exist('ZMazeFiles.mat','file')
            trialDesig.control.q1 = {'Z',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.5};
            trialDesig.control.q2 = {'Z',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5};
            trialDesig.control.q3 = {'Z',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.4};
            trialDesig.control.q4 = {'Z',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5};
        end
        if exist('ForceFiles.mat','file')
            trialDesig.control.q1 = {'force',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
            trialDesig.control.q2 = {'force',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
            trialDesig.control.q3 = {'force',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
            trialDesig.control.q4 = {'force',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
        end
        trialMeanBool = 0;
        outlierDepth = 1;
        wholeModelSpec = [1 0 0 0; 0 1 0 0;0 0 1 0; 0 0 0 1; 0 0 1 1];
        partialModelSpec = [1 0;0 1;1 1];
        ssType = 3;
        adjDayMedBool = 1;
        adjDayZbool = 0;
    end
    %%%% Alter_Err_Vs_Corr_S0_A0 %%%%%%%%
    if 0
        trialDesigName = 'Alter_Err_Vs_Corr_S0_A0';
        contIndepCell = {'speed.p0','accel.p0'};
        trialDesig.err.returnArm = {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
        trialDesig.err.centerArm = {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
        trialDesig.err.Tjunction = {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
        trialDesig.err.goalArm =   {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
        trialDesig.corr.returnArm = {'alter',[1 0 1 0 1 0 1 0 1 0 1 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
        trialDesig.corr.centerArm = {'alter',[1 0 1 0 1 0 1 0 1 0 1 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
        trialDesig.corr.Tjunction = {'alter',[1 0 1 0 1 0 1 0 1 0 1 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
        trialDesig.corr.goalArm =   {'alter',[1 0 1 0 1 0 1 0 1 0 1 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
        trialMeanBool = 0;
        outlierDepth = 1;
        wholeModelSpec = [1 0 0 0; 0 1 0 0;0 0 1 0; 0 0 0 1; 0 0 1 1];
        partialModelSpec = [1 0;0 1;1 1];
        ssType = 3;
        adjDayMedBool = 1;
        adjDayZbool = 0;
    end
    %%%% Alter_Right_Vs_Left_S0_A0 %%%%%%%%
    if 0
        trialDesigName = 'Alter_Right_Vs_Left_S0_A0';
        contIndepCell = {'speed.p0','accel.p0'};
        trialDesig.right.returnArm = {'alter',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
        trialDesig.right.centerArm = {'alter',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
        trialDesig.right.Tjunction = {'alter',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
        trialDesig.right.goalArm =   {'alter',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
        trialDesig.left.returnArm =  {'alter',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
        trialDesig.left.centerArm =  {'alter',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
        trialDesig.left.Tjunction =  {'alter',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
        trialDesig.left.goalArm =    {'alter',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
        trialMeanBool = 0;
        outlierDepth = 1;
        wholeModelSpec = [1 0 0 0; 0 1 0 0;0 0 1 0; 0 0 0 1; 0 0 1 1];
        partialModelSpec = [1 0;0 1;1 1];
        ssType = 3;
        adjDayMedBool = 1;
        adjDayZbool = 0;
    end
    %%%% Alter_Control_Snp1000by200_Anp1000by200.mat %%%%%%%%
    if 0
        trialDesigName = 'Alter_Control_S1000by500_A1000by500';
        contIndepCell = {'speed.n1000','speed.n500','speed.p0','speed.p500','speed.p1000',...
                         'accel.n1000','accel.n500','accel.p0','accel.p500','accel.p1000'};
        trialDesig.alter = cat(1,{'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5},...
                                 {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5},...
                                 {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4},...
                                 {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5});
        if exist('CircleFiles.mat','file')
            trialDesig.control = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5},...
                                       {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5},...
                                       {'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5},...
                                       {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5},...
                                       {'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5},...
                                       {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5},...
                                       {'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5},...
                                       {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5});
        end
        if exist('ZMazeFiles.mat','file')
            trialDesig.control = cat(1,{'Z',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.5},...
                                       {'Z',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5},...
                                       {'Z',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.4},...
                                       {'Z',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5});
        end
        if exist('ForceFiles.mat','file')
            trialDesig.control = cat(1,{'force',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5},...
                                       {'force',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5},...
                                       {'force',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4},...
                                       {'force',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5});
        end
        trialMeanBool = 0;
        outlierDepth = 1;
        wholeModelSpec = [1 0 0 0; 0 1 0 0;0 0 1 0; 0 0 0 1; 0 0 1 1];
        partialModelSpec = [1 0;0 1;1 1];
        ssType = 3;
        adjDayMedBool = 1;
        adjDayZbool = 0;
    end

    if ~exist('TrialDesig','dir')
        mkdir('TrialDesig')
    end
    if ~exist('TrialDesig/GlmWholeModel04','dir')
        mkdir('TrialDesig/GlmWholeModel04')
    end
    outNameWhole = ['TrialDesig/GlmWholeModel04/' trialDesigName '.mat'];
    fprintf('Saving: %s\n',[pwd '/' outNameWhole])
    save(outNameWhole,SaveAsV6,'trialDesig','contIndepCell','trialMeanBool','outlierDepth',...
        'wholeModelSpec','ssType','adjDayMedBool','adjDayZbool');
    
    if ~exist('TrialDesig/GlmPartialModel04','dir')
        mkdir('TrialDesig/GlmPartialModel04')
    end
    outNamePartial = ['TrialDesig/GlmPartialModel04/' trialDesigName '.mat'];
    fprintf('Saving: %s\n',[pwd '/' outNamePartial])
    save(outNamePartial,SaveAsV6,'trialDesig','contIndepCell','trialMeanBool','outlierDepth',...
        'partialModelSpec','ssType','adjDayMedBool','adjDayZbool');
end
return,


if 0
    trialDesig.alter.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.alter.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.circle.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
    trialDesig.circle.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
    outlierDepth = 2;
    trialMeanBool = 0;
end


if 0
    %trialDesig.alter.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.centerArm =  {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.q12 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.4},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5});
    trialMeanBool = 0;
    removeOutliersBool = 0;
end
if 0
    trialDesig.err.returnArm = {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.err.centerArm = {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.err.Tjunction = {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 1 0 0 0 0 0],.9};
    trialDesig.err.goalArm =   {'alter',[0 1 0 1 0 1 0 1 0 1 0 1 0],0.6,[0 0 0 0 0 1 1 0 0],.9};
    trialDesig.corr.returnArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.corr.centerArm = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.corr.Tjunction = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
    trialDesig.corr.goalArm =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
    trialMeanBool = 0;
    outlierDepth = 0;
    outNameNote = [ 'AlterCorr_v_AlterErr_' outNameNote '_']

end
if 0
    trialDesig.circle.q1 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5});
    trialDesig.circle.q2 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5});
    trialDesig.circle.q3 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5});
    trialDesig.circle.q4 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5});
    trialMeanBool = 1;
    outlierDepth = 1;
        outNameNote = ['Circle_' outNameNote '_']
end
if 0
    trialDesig.alter.q2 = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.alter.q1 = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.alter.q3 = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
    trialDesig.alter.q4 =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
    trialDesig.circle.q1 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5});
    trialDesig.circle.q2 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5});
    trialDesig.circle.q3 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.5});
    trialDesig.circle.q4 = cat(1,{'circle',[1 0 0 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5},...
        {'circle',[0 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 0 1],0.5});
    trialMeanBool = 0;
    outlierDepth = 1;
    adjDayMedBool = 1;
    modelSpec = [1 0 0 0; 0 1 0 0;0 0 1 0; 0 0 0 1; 0 0 1 1];
        %outNameNote = [outNameNote '_']
end

if 0
% z:      rwp lwp  da a1 c1 a2  c2  a3
    trialDesig.alter.q1 = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.alter.q2 = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.alter.q3 = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
    trialDesig.alter.q4 =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
    trialDesig.control.q1 = {'Z',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.5}
    trialDesig.control.q2 = {'Z',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 0 0 0],0.5}
    trialDesig.control.q3 = {'Z',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 1 0 0],0.4}
    trialDesig.control.q4 = {'Z',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 0],0.5}
    trialMeanBool = 0;
    outlierDepth = 1;
    adjDayMedBool = 1;
    modelSpec = [1 0 0 0; 0 1 0 0;0 0 1 0; 0 0 0 1; 0 0 1 1];
end
if 0
    trialDesig.alter.q1 = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.alter.q2 = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.alter.q3 = {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
    trialDesig.alter.q4 =   {'alter',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
    trialDesig.control.q1 = {'force',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 1 0 0 0 0],0.5};
    trialDesig.control.q2 = {'force',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 0 0 1 1],0.5};
    trialDesig.control.q3 = {'force',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 1 0 0 0 0 0],0.4};
    trialDesig.control.q4 =   {'force',[1 0 1 0 0 0 0 0 0 0 0 0 0],0.6,[0 0 0 0 0 1 1 0 0],0.5};
    trialMeanBool = 0;
    outlierDepth = 1;
    adjDayMedBool = 1;
    modelSpec = [1 0 0 0; 0 1 0 0;0 0 1 0; 0 0 0 1; 0 0 1 1];
end