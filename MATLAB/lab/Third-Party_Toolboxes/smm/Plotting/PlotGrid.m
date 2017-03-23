function PlotGrid(varargin)
%[lineStyle,lineWidth,colorVec] = DefaultArgs(varargin,{':',1,[0 0 0]});
if isempty(varargin)
varargin = {'linestyle',':','lineWidth',1,'color',[0 0 0]};
end

holdStatus = get(gca,'NextPlot');
set(gca,'NextPlot','add');

xTicks = get(gca,'xtick');
xLims = get(gca,'xlim');
yTicks = get(gca,'ytick');
yLims = get(gca,'ylim');

for j=1:length(xTicks)
    plot([xTicks(j) xTicks(j)],yLims,varargin{:});
%     plot([xTicks(j) xTicks(j)],yLims,'linestyle',lineStyle,'lineWidth',lineWidth,'color',colorVec);
end
for j=1:length(yTicks)
    plot(xLims,[yTicks(j) yTicks(j)],varargin{:});
end
set(gca,'NextPlot',holdStatus)
return
