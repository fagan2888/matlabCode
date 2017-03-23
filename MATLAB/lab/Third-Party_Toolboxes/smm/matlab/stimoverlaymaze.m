function stimoverlaymaze(filebase,channels,notes)

datsampl=20000;
eegsampl = 1250;

data = readmulti([filebase '.dat'],97,channels(1));

% calculate stim peaks
timewindow = 0.8; %seconds
winheight = 20000;
stimindex = 1;
stims = [];
figure(1)
for i=1:10*datsampl:length(data(:,1))-10*datsampl
    clf;
    localmin = i-1 + find(data(i:i+10*datsampl-1,1)==min(data(i:i+10*datsampl-1,1)));
    localmax = i-1 + find(data(i:i+10*datsampl-1,1)==max(data(i:i+10*datsampl-1,1)));
    %localmin(1)-localmax(1)
    %if abs(localmin(1)-localmax(1)) < datsampl/100
    hold on
    plot(data((localmax(1)-timewindow*datsampl):(localmax(1)+timewindow*datsampl),1));
    plot([timewindow*datsampl timewindow*datsampl],[-winheight -0.75*winheight],'r')
    plot([timewindow*datsampl timewindow*datsampl],[winheight 0.75*winheight],'r')
    set(gca,'ylim',[-winheight winheight]);
    keyin = input('record stim time? y/[n]', 's');
    if keyin == 'y'
        stims(stimindex) = localmax(1);
        stimindex = stimindex + 1;
    end    
    %end
end
keyboard
eeg = readmulti([filebase '.eeg'],97,channels);

% firfiltb = fir1(floor(0.25*eegsampl)*2,[4/eegsampl*2,20/eegsampl*2]);
% filtseg = Filter0(firfiltb,eegseg);

%filter with cheby
forder = 4;
Ripple = 20;
lowcut = 4;
highcut = 20;
[b a] = Scheby2(forder, Ripple, [lowcut highcut]/eegsampl*2);
filtseg = Sfiltfilt(b,a,eeg);

figure(1)
clf
plot(data(:,1))
hold on
plot(1:round(datsampl/eegsampl):length(data), eeg(:,1),'r')
plot(1:round(datsampl/eegsampl):length(data), filtseg(:,1),'g')
plot(stims,data(stims,1),'.','markersize',10,'color',[0 0 0])
title([filebase ': channel ' num2str(channels(1)) ' - ' notes]);
datstims = stims;
stims = round(stims*eegsampl/datsampl); % convert to eeg sampling

%stims = [stims1 stims2+length(filtseg1) stims3+length(filtseg1)+length(filtseg2)];
%filtseg = [filtseg1; filtseg2; filtseg3];


figure(2)
clf;
xmid = 3; % * eegsampl
xdisp = 1; % * eegsampl
traceOffset = 5000;
for j=1:length(channels)
    for i=1:length(stims)
        hold on; 
        plot(filtseg((stims(i)-xmid*eegsampl):(stims(i)+xmid*eegsampl),j)-j*traceOffset,'color', [mod(j,2) 0 0]); 
    end
end
title([filebase ': channels ' num2str(channels(1)) '-'  num2str(channels(end)) ' - ' notes]);
set(gca,'xlim',[(xmid-xdisp)*eegsampl (xmid+xdisp)*eegsampl], 'ylim', [-traceOffset*(length(channels)+1) 0]);
set(gca, 'xtick', [(xmid-xdisp)*eegsampl (xmid-0.75*xdisp)*eegsampl (xmid-0.5*xdisp)*eegsampl (xmid-0.25*xdisp)*eegsampl (xmid)*eegsampl (xmid+0.25*xdisp)*eegsampl (xmid+0.5*xdisp)*eegsampl (xmid+0.75*xdisp)*eegsampl (xmid+xdisp)*eegsampl], 'xticklabel', [-1 -0.75 -0.5 -0.25 0 0.25 0.5 0.75 1]);
grid on;

figure(3)
clf;
xmid = 62/1250; % * eegsampl
xdisp = 62/1250; % * eegsampl
traceOffset = 10000;
for j=1:length(channels)
    for i=1:length(stims)
        hold on; 
        plot(eeg((stims(i)-xmid*eegsampl):(stims(i)+xmid*eegsampl),j)-j*traceOffset,'color', [mod(j,2) 0 0]); 
    end
end
title([filebase ': channels ' num2str(channels(1)) '-'  num2str(channels(end)) ' - ' notes]);
set(gca,'xlim',[(xmid)*eegsampl (xmid+xdisp)*eegsampl], 'ylim', [-traceOffset*(length(channels)+1.5) 0.5*traceOffset]);
set(gca, 'xtick', [(xmid)*eegsampl (xmid+0.25*xdisp)*eegsampl (xmid+0.5*xdisp)*eegsampl (xmid+0.75*xdisp)*eegsampl (xmid+xdisp)*eegsampl], 'xticklabel', [0 0.25*xdisp*1000 0.5*xdisp*1000 0.75*xdisp*1000 1*xdisp*1000]);
grid on;

while 1,
    i = input('Save to disk? (yes/no):', 's');
    if strcmp(i,'yes') | strcmp(i,'no'), break; end
end
if i(1) == 'y'
    fprintf('Saving %s\n', [filebase '_stims.mat']);
    
    
    save([filebase '_stims.mat'],'stims','datstims');
end

keyboard