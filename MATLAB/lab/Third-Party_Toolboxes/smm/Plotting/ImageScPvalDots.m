function h = ImageScPvalDots(imageData,pVals,varargin)
[colorLimits,pValLim,minSize] = DefaultArgs(varargin,{[min(min(imageData)) max(max(imageData))],-3,0.075});

Gamma = 1;

temp = zeros(size(imageData));
temp = (2/3) - (2/3)*clip((imageData -colorLimits(1))./(colorLimits(2)-colorLimits(1)),0,1).^Gamma;
% if isnan(maskHSV(1)) % if maskHSV(1) = NaN scale the hue as the rest of imageData
%     temp(~mask) = (2/3) - (2/3)*clip((imageData(~mask) -colorLimits(1))./(colorLimits(2)-colorLimits(1)),0,1).^Gamma;
% else
%     temp(~mask) = maskHSV(1);
% end
Hsv(:,:,1) = temp;
Hsv(:,:,2) =   1;%mask + ~mask.*maskHSV(3);
Hsv(:,:,3) =   1;%mask + ~mask.*maskHSV(3);
rgbData = hsv2rgb(Hsv);


holdStatus = get(gca,'NextPlot');
hold on
if length(pValLim) ==1
    pValLim = 0:-1:pValLim;
end
pValLim;
% colorSlope = (0.49 - minSize) / (pValLim(end) - pValLim(1));
% colorYcept = 0.49-pValLim(end)*colorSlope;
colorSlope = (0.49 - minSize)/(length(pValLim)-1);
colorMapping = cat(1,pValLim,[minSize:colorSlope:0.49]);

if any(pValLim < 0)
    pVals = FurcateData(pValLim,pVals,'ceil');
%     pVals(isinf(pVals)
else
    pVals = FurcateData(pValLim,pVals,'floor');
end
% imageData = flipud(imageData)
% pVals = flipud(pVals)
angleData = -pi:0.1:pi;
for m=1:size(imageData,1)
    for n=1:size(imageData,2)
        if isfinite(pVals(m,n))
            %                 radius = 0.49/pValLim*clip(ceil(log10(pVals(m,n))),pValLim,-0.5);
            %                 radius = (0.49-minSize)/pValLim*(clip(ceil(pVals(m,n)),pValLim,0));
%             radius = pVals(m,n)*colorSlope + colorYcept;
            radius = colorMapping(2,colorMapping(1,:)==pVals(m,n));
            xData = radius*cos(angleData)+n;
            yData = radius*sin(angleData)+m;
            if all(isfinite(rgbData(m,n,:)))
                fill(xData,yData,squeeze(rgbData(m,n,:))','edgecolor',squeeze(rgbData(m,n,:))');
            end
        end
    end
end

text(1,0,'p<','horizontalalignment','center')
for j=1:length(pValLim)
    radius = colorMapping(2,colorMapping(1,:)==pValLim(j));
    xData = radius*cos(angleData)+j+1;
    yData = radius*sin(angleData)-1;
    fill(xData,yData,'w','edgecolor','k');
    text(j+1,0,num2str(pValLim(j),2),'horizontalalignment','center')
end

set(gca,'ydir','reverse')
set(gca,'xlim',[0.5 size(pVals,2)+0.5])
set(gca,'ylim',[-1.5 size(pVals,1)+0.5])
set(gca,'NextPlot',holdStatus)

prevWarnings = SetWarnings({'off','MATLAB:dispatcher:nameConflict'});
%%%%%%%%%% most annoying bit is colorbar %%%%%%%%%%%%
addpath /u16/local/matlab6.5/toolbox/matlab/graph2d/
h = gca;
h2 = SideBar;
BarHsv(:,:,1) = (2/3) - (2/3)*(0:.01:1)'.^Gamma;
BarHsv(:,:,2) = ones(101,1);
BarHsv(:,:,3) = ones(101,1);
image(0,(colorLimits(1):(colorLimits(2)-colorLimits(1))/100:colorLimits(2)), hsv2rgb(BarHsv));
set(gca, 'ydir', 'normal');
set(gca, 'xtick', []);
set(gca, 'yaxislocation', 'right');
axes(h);
rmpath /u16/local/matlab6.5/toolbox/matlab/graph2d/
if nargout == 0
    clear h;
end
SetWarnings(prevWarnings);