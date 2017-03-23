function PlotMazeCoh01(taskType,fileBaseCell,fileNameFormat,fileExt,freqRange,winLength,refChan,chanMat,varargin)
% function PlotPowMapsBat(taskType,fileBaseCell,fileNameFormat,fileExt,freqRange,winLength,NW,peakBool,chanMat,...
% badchan,saveMazePow,calcZ,percentageBool,DB,colorLimits,maxscale,textBool,plotRes,plot_low_thresh)
%
% 'pos_sum' is a 2D matrix containing the number of video frames the animals spent in each spatial position
% 'pow_sum' is a 2D by nchanMat matrix containing the sum a variable of interest (e.g. power) for each position
% 'chanMat' is a 3D matrix that determines graphical output. x,y for each z determines page layout for each figure respectively.
% 'DB' if DB=1 the variable of interes will be transformed 10*log10 after spatial smoothing before plotting
%   default = 0
% 'samescale' if samescale=1 all graphs will be scaled to the same values 'minscale' and 'maxscale'
%   default = 0
% 'calcZ' if calcZ=1 the power will be expressed as a
%   percentage of the mean power for that channel
%   default = 0
%
% plotpowmapsbat7 can plot the percentage changes in power from the mean
% rather than the raw power or the mean power (can have same scaling)
[badchan, saveMazePow, calcZ, normalizeBool, colorLimits, textBool, plotRes, plot_low_thresh, smoothpixels] = ...
    DefaultArgs(varargin,{0, 0, 0, 0, [], 1, 3, 0.01, 4});


%normVals = [73.7,75.5,80.7,79.9,80,79.7]; % alter theta
%normVals = [55.1 61.6 60.6 64.9 63.7 63.3]; % alter gamma

xlimits = [0 368];
ylimits = [0 240];

[chan_y chan_x chan_z] = size(chanMat);

fileNamesInfo = GetFileNamesInfo(fileBaseCell,fileNameFormat);

pos_pow_sumFile = [taskType '_' fileNamesInfo ...
    fileExt '_ref' num2str(refChan) '_' num2str(freqRange(1)) '-' num2str(freqRange(2))...
    'Hz_Win' num2str(winLength) '_pos_coh_sum.mat'];

smoothMazePowFile = [taskType '_' fileNamesInfo ...
    fileExt '_ref' num2str(refChan) '_' num2str(freqRange(1)) '-' num2str(freqRange(2))...
    'Hz_Win' num2str(winLength) '_SmoothMazeCoh.mat'];

i = 0;
fromFile = 0;
while exist(smoothMazePowFile,'file') & ~strcmp(i,'y') & ~strcmp(i,'n') & ~strcmp(i,'') 
    i = input('Would you like to load smoothMazePowFile? [y]/n: ','s');
end
if strcmp(i,'y') | strcmp(i,'')
    fprintf('loading %s\n',smoothMazePowFile);
    load(smoothMazePowFile);
    fromFile = 1;
else
    if exist(pos_pow_sumFile,'file')
        fprintf('loading %s\n',pos_pow_sumFile);
        load(pos_pow_sumFile);
        pos_sum = getfield(sumPerPosStruct,'posSum');
        pow_sum = getfield(sumPerPosStruct,'powSum');

    else
        pos_pow_sumFile
        YOU_NEED_TO_RUN_calcpospowsum
    end

    fprintf('Smoothing Position\n');
    % now smooth & plot
    smooth_pos_sum = Smooth(pos_sum, smoothpixels); % smooth position data
    norm_smooth_pos_sum = smooth_pos_sum/sum(sum(smooth_pos_sum));
    norm_plot_low_thresh = plot_low_thresh/sum(sum(smooth_pos_sum));
    [below_thresh_indexes] = find(norm_smooth_pos_sum<=norm_plot_low_thresh);
    %[above_thresh_x above_thresh_y] = find(norm_smooth_pos_sum>norm_plot_low_thresh);
    smooth_pos_sum_nan = smooth_pos_sum;
    smooth_pos_sum_nan(below_thresh_indexes)= NaN;
    %minxborder = max(1,above_thresh_x(1)-1);
    %minyborder = max(1,above_thresh_y(1)-1);
    %maxxborder = min(videoxmax,above_thresh_x(end)+1);
    %minyborder = min(videoymax,above_thresh_y(end)+1);
end


for z=1:chan_z
    figure(z);
    clf;
    for y=1:chan_y
        for x=1:chan_x
            fprintf('%i,',chanMat(y,x,z));
            if isempty(find(badchan==chanMat(y,x,z))), % if the channel isn't bad
                if ~fromFile
                    pow_sum(:,:,chanMat(y,x,z)) = Smooth(pow_sum(:,:,chanMat(y,x,z)), smoothpixels); % smooth power data
                    if strcmp(taskType(1:5),'Zmaze')
                        mazePow(:,:,chanMat(y,x,z)) = fliplr(rot90(pow_sum(:,:,chanMat(y,x,z))./smooth_pos_sum_nan)); % average pow/pixel
                    else
                        mazePow(:,:,chanMat(y,x,z)) = pow_sum(:,:,chanMat(y,x,z))./smooth_pos_sum_nan; % average pow/pixel
                    end
                end

                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                
                plotMazePow = mazePow;
                thisChanMazePow = plotMazePow(:,:,chanMat(y,x,z));
                try
%                 if ~exist('normVals')
                    meanPowthisChan = mean(thisChanMazePow(~isnan(thisChanMazePow)));
%                 else
%                     meanPowthisChan = 10^(normVals(find(chanMat==chanMat(y,x,z)))/10);
%                 end
                catch keyboard
                end
                if calcZ
                   sdPowthisChan = std(thisChanMazePow(~isnan(thisChanMazePow)));
                    plotMazePow(:,:,chanMat(y,x,z)) = (plotMazePow(:,:,chanMat(y,x,z))-meanPowthisChan)./sdPowthisChan;

                elseif normalizeBool
                       plotMazePow(:,:,chanMat(y,x,z)) = UnATanCoh(plotMazePow(:,:,chanMat(y,x,z))) ...
                           - UnATanCoh(meanPowthisChan);
                else
                    plotMazePow(:,:,chanMat(y,x,z)) = UnATanCoh(plotMazePow(:,:,chanMat(y,x,z)));
                end
                %[toPlotY toPlotX] = find(plotMazePow(:,:,chanMat(y,x,z)) > -1);
                ImageScRmNaN_old(plotMazePow(1:plotRes:end,1:plotRes:end,chanMat(y,x,z)),colorLimits,[1 0 1]);

                [toPlotY toPlotX] = find(mazePow(:,:,chanMat(y,x,z)) > -1);
                toPlotX = [min(toPlotX)/plotRes-2 max(toPlotX)/plotRes+2];
                toPlotY = [min(toPlotY)/plotRes-2 max(toPlotY)/plotRes+2];

                set(gca, 'xlim',toPlotX,'ylim',toPlotY,'xticklabel', [], 'yticklabel', []);
                if calcZ | normalizeBool
                    title([num2str(chanMat(y,x,z)) ': ' num2str(UnATanCoh(meanPowthisChan),3)]);
                else
                    title(['Channel: ',num2str(chanMat(y,x,z))])
                end
            end
        end
    end
end
fprintf('\n');

return
fileNamesInfo = GetFileNamesInfo(fileBaseCell,fileNameFormat);
outname = [taskType '_' fileNamesInfo ...
    fileExt '_' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz_Win' num2str(winLength) '_NW' num2str(NW) peak '_SmoothMazePow.mat'];

if ~fromFile
    if saveMazePow
        fprintf('Saving %s\n', outname);
        matlabVersion = version;
        if str2num(matlabVersion(1)) > 6
            save(outname,'-V6','mazePow');
        else
            save(outname,'mazePow');
        end
    end
end



measureText = [];
if calcZ
    measureText = 'z-score';
elseif normalizeBool
    measureText = 'Normalized';
end

if textBool
    if 1
        for i=1:size(chanMat,3)
            figure(i);
            fileNamesInfo = GetFileNamesInfo(fileBaseCell,fileNameFormat);

            text(100,50,{[num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz Power'],fileExt,'',...
                taskType,SaveTheUnderscores(fileNamesInfo), ['Win=' num2str(winLength)], ['NW=' num2str(NW)]...
                ['ssm pix=' num2str(smoothpixels)],...
                ['thresh=' num2str(plot_low_thresh)]})
            titleText = ['SmoothMazePow_' taskType '_' fileNamesInfo ...
    fileExt '_' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz_Win' num2str(winLength) '_NW' num2str(NW) peak];
            set(gcf,'name',titleText)
        end
    end
end
return

