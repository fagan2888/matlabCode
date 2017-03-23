function trinx = CheckTrials(whl,trin,varargin)
%function trnew = CheckTrials(whl,trin,varargin)
[overwrite] = DefaultArgs(varargin,{0});
%% input:
%%   whl - nx2 matrix !!!
%%   trials - beginning and end for trials (in whl samples)
%% output:
%%   trqual - trial direction (or classification)

%% print position
whlplot = whl(whl(:,1)>0,:);

%% plot trials and select good/bad/dir/etc
tt=0;
while tt<length(trin)
  tt = tt+1
  clf;
  twhl = [];
  twhl = whl(trin(tt,1):trin(tt,2),:);
  
  plot(whlplot(1:100:end,1),whlplot(1:100:end,2),'o','markersize',5,'markeredgecolor','none','markerfacecolor',[0.9 0.9 0.9]);
  hold on
  plot(twhl(:,1),twhl(:,2),'o','markersize',5,'markeredgecolor','none','markerfacecolor',[0 0 1]);
  plot(twhl(1,1),twhl(1,2),'o','markersize',10,'markeredgecolor','none','markerfacecolor',[0 1 0]);
  plot(twhl(end,1),twhl(end,2),'o','markersize',10,'markeredgecolor','none','markerfacecolor',[1 0 0]);
  
  title(['(left=good; right=bad; mid=back;)  trials: ' num2str(tt)]);
  
  %% good='left'; bad='right'; cut='mid'; 
  waitforbuttonpress;
  whatbutton = get(gcf,'SelectionType');
  switch whatbutton
   case 'normal'  % left -- good 
    trqual(tt,1)=1
   case 'alt'      % right -- bad
    trqual(tt,1)=0
   case 'extend'     % mid -- go back 
    tt=tt-2;
   case 'open'     % double click -- go back 
    tt=tt-1;
  end
end

%% get indices of good trials
trinx = find(trqual);

%% take only good trials
trnew = trin(find(trqual),:);

return;
