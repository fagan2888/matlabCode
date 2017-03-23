function CalcPartCoh01(fileBaseMat,extCell,thetaFreqRange,gammaFreqRange);

%dirBaseName = 'CalcRunningSpectra9_noExp_MidPoints_MinSpeed0Win626';
dirBaseNameCell = {...
    'RemVsRun_noExp_MinSpeed0Win1250',...
    %'CalcRunningSpectra9_noExp_MidPoints_MinSpeed0Win626',...
    };

%dirExtCell = {'_noExp_MidPoints_MinSpeed0Win626_LinNear.eeg'}

% dirExtCell = {'_noExp_MidPoints_MinSpeed0Win626.eeg';...
%           '_noExp_MidPoints_MinSpeed0Win626_LinNearCSD121.csd';...
%           %'_noExp_MidPoints_MinSpeed0Win626_NearAveCSD1.csd';...
%           '_noExp_MidPoints_MinSpeed0Win626_LinNear.eeg'};

currDir = pwd;
chanInfoDir = [currDir '/ChanInfo/'];
for j=1:size(fileBaseMat,1)
    fprintf('%s\n',fileBaseMat(j,:));
    for d=1:length(dirBaseNameCell)
        for k=1:length(extCell)
            selChans = load([chanInfoDir 'SelectedChannels' extCell{k} '.txt']);

            cd(fileBaseMat(j,:))
            dirName = [dirBaseNameCell{d} extCell{k}];
            if ~exist(dirName,'dir')
                fprintf('\nERROR: %s not found\n',dirName)
            else
                cd(dirName);
                load('powSpec.mat','-mat');
                powSpec.yo = 10.^(powSpec.yo./10);             
                fs = powSpec.fo;
                load('crossSpec.mat','-mat');
                load(['thetaFreq' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.mat'],'-mat');
                
                if crossSpec.fo ~= powSpec.fo
                    fprintf('ERROR!!!! crossSpec.fo ~= powSpec.fo\n%s\n%s',...
                        fileBaseMat(j,:),dirBaseNameCell{d},extCell{k})
                    keyboard
                end
                %load('cohSpec.mat','-mat')
                for z=1:length(selChans) %%% partializer chan %%%
                    %figure(z)
                    for x=1:length(selChans) %%% ref chan %%%
                        crossSize = size(crossSpec.yo.(['ch' num2str(selChans(x))])); % for repmat
                        Syx = conj(crossSpec.yo.(['ch' num2str(selChans(x))]));
                        Szz = repmat(powSpec.yo(:,selChans(z),:),crossSize-size(powSpec.yo(:,selChans(z),:))+1);
                        Syz = conj(crossSpec.yo.(['ch' num2str(selChans(z))]));
                        Szx = repmat(crossSpec.yo.(['ch' num2str(selChans(z))])(:,selChans(x),:),...
                            crossSize-size(crossSpec.yo.(['ch' num2str(selChans(z))])(:,selChans(x),:))+1);
                        Syy = powSpec.yo;
                        Sxx = repmat(powSpec.yo(:,selChans(x),:),crossSize-size(powSpec.yo(:,selChans(x),:))+1);
                        Sxz = repmat(crossSpec.yo.(['ch' num2str(selChans(x))])(:,selChans(z),:),...
                            crossSize-size(crossSpec.yo.(['ch' num2str(selChans(x))])(:,selChans(z),:))+1);
                        
                        partCohSpec.yo.(['ch' num2str(selChans(x))]) = atanh((sqrt(...
                            abs((abs(Syx.*Szz-Syz.*Szx).^2)./((Syy.*Szz-abs(Syz).^2).*(Sxx.*Szz-abs(Sxz).^2)))...
                            )-0.5)*1.999);
%                                             subplot(6,2,x*2-1)
%                         imagesc(squeeze(mean(abs(partialCohSpec.(['ch' num2str(selChans(x))])(:,49:64,:)))));
%                         %shading interp
%                         set(gca,'clim',[-1 4.2])
%                         colorbar
%                         subplot(6,2,x*2)
%                         imagesc(squeeze(mean(cohSpec.yo.(['ch' num2str(selChans(x))])(:,49:64,:))));
%                         %shading interp
%                         set(gca,'clim',[-1 4.2])
%                         colorbar
                        
                        selChanName = ['ch' num2str(selChans(x))];
                        for n=1:size(partCohSpec.yo.(selChanName),1)
                            partThetaCohPeakSelChF.(selChanName)(n,:) = partCohSpec.yo.(selChanName)...
                                (n,:,find(abs(fs-thetaFreq(n,selChans(x)))==min(abs(fs-thetaFreq(n,selChans(x)))),1));
                        end
                        selChanName = ['ch' num2str(selChans(x))];
                        for n=1:size(partCohSpec.yo.(selChanName),1)
                            partThetaCohPeakLMF.(selChanName)(n,:) = partCohSpec.yo.(selChanName)...
                                (n,:,find(abs(fs-thetaFreq(n,selChans(3)))==min(abs(fs-thetaFreq(n,selChans(3)))),1));
                        end
                        
                        partThetaCohMedian.(selChanName) = squeeze(median(partCohSpec.yo.(selChanName)(:,:,find(fs>=thetaFreqRange(1) & fs<=thetaFreqRange(2))),3));
                        partThetaCohMean.(selChanName) = squeeze(mean(partCohSpec.yo.(selChanName)(:,:,find(fs>=thetaFreqRange(1) & fs<=thetaFreqRange(2))),3));

                        partGammaCohMedian.(selChanName) = squeeze(median(partCohSpec.yo.(selChanName)(:,:,find(fs>=gammaFreqRange(1) & fs<=gammaFreqRange(2))),3));
                        partGammaCohMean.(selChanName) = squeeze(mean(partCohSpec.yo.(selChanName)(:,:,find(fs>=gammaFreqRange(1) & fs<=gammaFreqRange(2))),3));

                    end
%                     clf
%                     pcolor(1:size(squeeze(partCohSpec.yo.ch39(:,42,:)),1),fs,squeeze(partCohSpec.yo.ch39(:,39+16,:))') 
%                     shading interp
%                     set(gca,'ylim',[0 150],'clim',[-1 3]);
%                     hold on
%                     plot(thetaFreq(:,39),'k')
   %keyboard

                    partCohSpec.fo = fs;
                  
                    saveBase = '';
                    save([saveBase 'partCohSpec' 'Ch' num2str(selChans(z)) '.mat'],SaveAsV6,'partCohSpec');
                    save([saveBase 'partThetaCohPeakSelChF' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'HzCh' num2str(selChans(z)) '.mat'],SaveAsV6,'partThetaCohPeakSelChF');
                    save([saveBase 'partThetaCohPeakLMF' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'HzCh' num2str(selChans(z)) '.mat'],SaveAsV6,'partThetaCohPeakLMF');
                    save([saveBase 'partThetaCohMedian' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'HzCh' num2str(selChans(z)) '.mat'],SaveAsV6,'partThetaCohMedian');
                    save([saveBase 'partThetaCohMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'HzCh' num2str(selChans(z)) '.mat'],SaveAsV6,'partThetaCohMean');
                    save([saveBase 'partGammaCohMedian' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'HzCh' num2str(selChans(z)) '.mat'],SaveAsV6,'partGammaCohMedian');
                    save([saveBase 'partGammaCohMean' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'HzCh' num2str(selChans(z)) '.mat'],SaveAsV6,'partGammaCohMean');
                    
                    clear partCohSpec
                    clear partThetaCohPeakSelChF
                    clear partThetaCohPeakLMF
                    clear partThetaCohMedian
                    clear partThetaCohMean
                    clear partGammaCohMedian
                    clear partGammaCohMean
                 end
            end
            cd(currDir)
        end
    end
end

return
plot(fs,squeeze(mean(abs(partialCohSpec.(['ch' num2str(selChans(2))])(:,39,:)))));


%%% testing %%%%
fs = 0;
figure
clf
for selCh=1:6;
    subplot(6,2,selCh*2-1)
    imagesc(squeeze(mean(abs(partialCohSpec.(['ch' num2str(selChans(selCh))])(:,49:64,:)))));
    set(gca,'clim',[-1 4.2])
    colorbar
    subplot(6,2,selCh*2)
    imagesc(squeeze(mean(cohSpec.yo.(['ch' num2str(selChans(selCh))])(:,49:64,:))));
    %set(gca,'clim',[-1 4.2])
    colorbar
end
