% function CalcWaveletSpectra01(saveDir,fileBaseCell,fileExt,nChan,winLength,wavParam,varargin)
% chanInfoDir = 'ChanInfo/';
% [selChansStruct,plotBool,figHandleCell,subPlotLoc,batchModeBool] = ...
%     DefaultArgs(varargin,{LoadVar([chanInfoDir 'SelChan' fileExt '.mat']),...
%     1,NaN,{{2,2,2},{2,2,3},{2,2,4}},1});
function subPlotHandles = CalcWaveletSpectra02(saveDir,fileBaseCell,fileExt,nChan,winLength,wavParam,varargin)
chanInfoDir = 'ChanInfo/';
[selChansStruct,calcCohBool,plotBool,figHandleCell,subPlotLoc,batchModeBool,overwriteBool] = ...
    DefaultArgs(varargin,{LoadVar([chanInfoDir 'SelChan' fileExt '.mat']),...
    1,1,{},{{2,2,2},{2,2,3},{2,2,4}},1,0});

subPlotHandles = {[]};
mother = 'MORLET'; % do not change... not sure how coherence calc depends on this parameter
% if wavParam~=6% do not change... not sure how coherence calc depends on this parameter
%     ERROR_WAVPARAM_MUST_BE_6
% end
% try

selChanNames = fieldnames(selChansStruct);
for j=1:length(selChanNames)
    selectedChannels(j) = selChansStruct.(selChanNames{j});
end

currDir = pwd;

%     addpath ~/matlab/sm_Copies

%%%% parameters optimized for winLength = 626 %%%%
N = winLength;
DJ = 1/18;
S0 = 4;
J1 = round(log2(N/S0)/(DJ)-1.3/DJ);
dt = 1;
pad = 1;

eegSamp = 1250;
bps = 2;

infoStruct = [];
infoStruct = setfield(infoStruct,'nChan',nChan);
infoStruct = setfield(infoStruct,'winLength',winLength);
infoStruct = setfield(infoStruct,'mother',mother);
infoStruct = setfield(infoStruct,'wavParam',wavParam);
infoStruct = setfield(infoStruct,'S0',S0);
infoStruct = setfield(infoStruct,'DJ',DJ);
infoStruct = setfield(infoStruct,'J1',J1);
infoStruct = setfield(infoStruct,'dt',dt);
infoStruct = setfield(infoStruct,'pad',pad);
infoStruct = setfield(infoStruct,'eegSamp',eegSamp);
infoStruct = setfield(infoStruct,'fileExt',fileExt);
infoStruct = setfield(infoStruct,mfilename,mfilename);
infoStruct = setfield(infoStruct,'selChan',selChansStruct);
infoStruct = setfield(infoStruct,'saveDir',saveDir);

for j=1:length(fileBaseCell)
    %         try
    %             c1 = clock;
    fileBase = fileBaseCell{j};
    infoStruct = setfield(infoStruct,'fileBase',fileBase);
    cd(currDir)
    cd(fileBase);

    if exist([saveDir '/infoStruct.mat'],'file')
        infoStruct = MergeStructs(LoadVar([saveDir '/infoStruct.mat']),infoStruct,1);
    end

    fprintf('Processing: %s; %s%s\n',mfilename,fileBase,fileExt);

    %             rawTrace = [];
    %             powSpec = [];
    %             crossSpec = [];
    %             cohSpec = [];
    %             cohWavSpec = [];
    %             phaseSpec = [];
    updatingBool = 0;
    skippingBool = 0;
    to = LoadVar([saveDir '/eegSegTime.mat']);

    if exist([SC(saveDir) 'powSpec.mat'],'file') & ~overwriteBool
        powSpec = LoadVar([SC(saveDir) 'powSpec.mat']);
        if size(powSpec.yo,1) < size(to,1)
            toLen = length(to);
            to = to(size(powSpec.yo,1)+1:toLen);
            fprintf(['Updating: ' SC(saveDir) 'powSpec.mat, trials '...
                num2str(size(powSpec.yo,1)+1) '-' num2str(toLen) '\n'])
            infoStruct.(['updated_' GenFieldName(date)]) = ...
                [size(powSpec.yo,1)+1:toLen,1];
            updatingBool = 1;
        elseif size(powSpec.yo,1) > size(to,1)
            error([mfilename ':ToTooSmall'],'Variable to is shorter than powSpec.yo: that is bad')
        else
            warning([mfilename ':FileAlreadyUpToDate'],['File '...
                SC(saveDir) 'powSpec.mat is already up to date: SKIPPING']);
            skippingBool = 1;
        end
        clear powSpec;
    end
    if ~skippingBool
        %             try
        if ~isempty(to)
            for i=1:length(to)
                try
                    eegData = bload([fileBase fileExt],[nChan winLength],round(to(i)*nChan*bps),'int16');
                catch
                    keyboard
                end
                if ~exist('rawTrace','var')
                    rawTrace = zeros(length(to),size(eegData,1),size(eegData,2));
                end
                rawTrace(i,:,:) = eegData;


                for m=1:nChan %% calculate the wavelet spectrum
                    [wave(m,:,:) period scale] = wavelet(eegData(m,:),dt,pad,DJ,S0,J1,mother,wavParam);
                end
                sinv=1./(scale');
                normEegHannWin = [repmat([hanning(winLength)./mean(hanning(winLength))],1,length(period))];
                pow = zeros(size(wave,1),size(wave,2));
                smoothWave = zeros(size(wave));
                for m=1:nChan
                    % convert complex wavelet to power spectrum
                    temp = abs(squeeze(wave(m,:,:))).^2;
                    pow(m,:) = mean(temp'.*normEegHannWin,1);
                    % smooth wavelet spectrum for coherence calculation
                    if calcCohBool
                        smoothWave(m,:,:) = smoothwavelet(sinv(:,ones(1,size(wave,3)))...
                            .*temp,dt,period,DJ,scale);
                    end
                end

                if calcCohBool %% If you want to calc coherence
                    xSpec = zeros(length(selectedChannels),size(pow,1),size(pow,2));
                    phase = zeros(length(selectedChannels),size(pow,1),size(pow,2));
                    coh = zeros(length(selectedChannels),size(pow,1),size(pow,2));
                    waveCoh = zeros(length(selectedChannels),size(pow,1),size(pow,2));
                    for k=1:length(selectedChannels)
                        for m=1:nChan
                            % -------- Cross wavelet -------
                            Wxy = squeeze(wave(selectedChannels(k),:,:).*conj(wave(m,:,:)));
                            temp = Wxy;
                            xSpec(k,m,:) = mean(temp'.*normEegHannWin,1);
                            % ----------------------- phase ---------------------------------
                            temp = temp./abs(temp); % normalize (convert to complex phase)
                            phase(k,m,:) = mean(temp'.*normEegHannWin,1);
                            %----------------------- coherence ---------------------------------
                            coh(k,m,:) = ATanCoh(sqrt(squeeze(xSpec(k,m,:).*conj(xSpec(k,m,:)))'./...
                                squeeze(pow(selectedChannels(k),:).*pow(m,:))));
                            % ----------------------- Wavelet coherence ---------------------------------
                            temp = smoothwavelet(sinv(:,ones(1,size(wave,3))).*Wxy,dt,period,DJ,scale);
                            temp = abs(temp).^2./squeeze(smoothWave(selectedChannels(k),:,:).*smoothWave(m,:,:));
                            temp = ATanCoh(sqrt(temp)); % ATan(sqrt(coherence)) approximates normality
                            waveCoh(k,m,:) = mean(temp'.*normEegHannWin,1);
                        end
                    end
                end
                
                fo = 1./period.*eegSamp;
                fo = flipdim(fo,2);

                if ~exist('oldFo','var')
                    oldFo = fo;
                end
                if fo ~= oldFo
                    ERROR_fo_is_changing
                end

                if ~exist('powSpec','var')
                    powSpec.yo = zeros(length(to),size(pow,1),size(pow,2));
                    powSpec.fo = fo;
                    if calcCohBool
                        for k=1:length(selectedChannels)
                            crossSpec.yo.(selChanNames{k}) = ...
                                zeros(length(to),size(xSpec,2),size(xSpec,3));
                            cohSpec.yo.(selChanNames{k}) = ...
                                zeros(length(to),size(coh,2),size(coh,3));
                            cohWavSpec.yo.(selChanNames{k}) = ...
                                zeros(length(to),size(waveCoh,2),size(waveCoh,3));
                            phaseSpec.yo.(selChanNames{k}) = ...
                                zeros(length(to),size(phase,2),size(phase,3));
                        end
                        crossSpec.fo = fo;
                        cohSpec.fo = fo;
                        cohWavSpec.fo = fo;
                        phaseSpec.fo = fo;
                    end
                end

                powSpec.yo(i,:,:) = 10.*log10(flipdim(pow,2));
                if calcCohBool
                    for k=1:length(selectedChannels)
                        crossSpec.yo.(selChanNames{k})(i,:,:) = flipdim(xSpec(k,:,:),3);
                        cohSpec.yo.(selChanNames{k})(i,:,:) = flipdim(coh(k,:,:),3);
                        cohWavSpec.yo.(selChanNames{k})(i,:,:) = flipdim(waveCoh(k,:,:),3);
                        phaseSpec.yo.(selChanNames{k})(i,:,:) = flipdim(phase(k,:,:),3);
                    end
                end

            end
        end
        %             catch
        %                 errorText = ['WARNING:  ' date '  ' mfilename '  call=('...
        %                     saveDir '\n'];
        %                 ReportError(errorText,~batchModeBool)
        %             end

        if plotBool
            if ~isempty(figHandleCell)
                figure(figHandleCell{j})
            else
                figure
            end
            if length(to) > 1
                subPlotHandles{1}{1} = subplot(subPlotLoc{1}{:});
                hold on
                pcolor(1:length(to),powSpec.fo,squeeze(powSpec.yo(:,selectedChannels(2),:))');
                shading 'flat'
                set(gca,'clim',[35 75],'ylim',[0,100]);
                colorbar
                %plot(1:length(to),thetaFreq(:,selectedChannels(1)),'k')
                if calcCohBool
                    subPlotHandles{2}{1} = subplot(subPlotLoc{2}{:});
                    pcolor(1:length(to),cohSpec.fo,UnATanCoh(squeeze(cohSpec.yo.(selChanNames{2})(:,selectedChannels(3),:)))');
                    shading 'flat'
                    set(gca,'clim',[0 1],'ylim',[0,100]);
                    colorbar

                    subPlotHandles{3}{1} = subplot(subPlotLoc{3}{:});
                    pcolor(1:length(to),phaseSpec.fo,angle(squeeze(phaseSpec.yo.(selChanNames{2})(:,selectedChannels(3),:)))');
                    shading 'flat'
                    set(gca,'clim',[-pi pi],'ylim',[0,100]);
                    colorbar
                end
            else
                subPlotHandles{1}{1} = subplot(subPlotLoc{1}{:});
                subPlotHandles{2}{1} = subplot(subPlotLoc{2}{:});
                subPlotHandles{3}{1} = subplot(subPlotLoc{3}{:});
            end
            varargout = subPlotHandles;
        end
        if updatingBool
            temp = LoadField([SC(saveDir) 'powSpec.fo']);
            if temp ~= powSpec.fo
                error([mfilename ':UpdateFailed'],'UPDATE FAILED - fo not the same size');
            else
                catVars = {...
                    'rawTrace',...
                    'powSpec.yo',...
                    };
                if calcCohBool
                    catVars = cat(2,catVars,...
                        'crossSpec.yo',...
                        'cohSpec.yo',...
                        'cohWavSpec.yo',...
                        'phaseSpec.yo'...
                        );
                end
                for v=catVars
                    oldSpec = LoadField([SC(saveDir) v{:}]);
%                     try
                    eval([v{:} ' = CatStruct(1,oldSpec,' v{:} ');'])
%                     catch
%                         keyboard
%                     end
                end
            end
        end

        fprintf('Saving: %s, size=%ix%ix%i\n',saveDir,...
            size(powSpec.yo,1),size(powSpec.yo,2),size(powSpec.yo,3))

        saveVars = {...
            'infoStruct',...
            'rawTrace',...
            'powSpec',...
            };
        if calcCohBool
            saveVars = cat(2,saveVars,...
                'crossSpec',...
                'cohSpec',...
                'cohWavSpec',...
                'phaseSpec'...
                );
        end
        for v=saveVars
            save([SC(saveDir) v{:} '.mat'],SaveAsV6,v{:});
            clear(v{:})
        end

    end
    %             c2 = clock-c1;
    %             disp(num2str(c2))
    cd(currDir)
    %          catch
    %             errorText = ['WARNING:  ' date '  ' mfilename '  call=('...
    %                 saveDir '\n'];
    %             ReportError(errorText,~batchModeBool)
    %         end
end
% catch
%     errorText = ['WARNING:  ' date '  ' mfilename '  call=('...
%         saveDir '\n'];
%     ReportError(errorText,~batchModeBool)
% end
return
