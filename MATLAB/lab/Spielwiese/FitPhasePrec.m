function [Slope b] = FitPhasePrec(spikepos,spikeph,varargin)
[xspikepos,xspikeph,Manual,NumIter] = DefaultArgs(varargin,{[],[],0,15});

%% does iterative robust fit of phase 
%% optional: Manual lets you manually correct the for mod
%%           

if isempty(xspikepos)
  xspikepos = spikepos;
  xspikeph = spikeph;
end

if length(spikepos)<2 
  Slope = [NaN 0];
  b = [NaN 0];
elseif length(spikepos)==2
  Slope = [diff(spikeph)/diff(spikepos) 0];
  b = [spikeph(1) - Slope(1)*spikepos(1) 0];
else
  
  kspikepos = spikepos;
  kspikeph = spikeph;
  
  [B stats] = robustfit(spikepos,spikeph);
  
  ff=1;
  pp(1) = 1;
  while ff
    
    ff=ff+1;
    
    differ = (B(2)*spikepos+B(1)-spikeph);
    dinx = find(abs(differ)>pi);
    spikeph(dinx) = spikeph(dinx) + 2*pi*sign(differ(dinx)); 
    
    if Manual
      clf
      subplot(211)
      plot(xspikepos,xspikeph,'.')
      hold on
      plot(xspikepos,xspikeph-2*pi,'.')
      plot(xspikepos,xspikeph+2*pi,'.')
      plot(spikepos,B(2)*spikepos+B(1));
      plot(spikepos,spikeph,'ro');
    end
    
    [B stats] = robustfit(spikepos,spikeph);
    
    pp(ff,1) = stats.p(2);
    
    if Manual
      subplot(212)
      plot(log(pp(2:end)),'.-');
    end
    
    if (ff>5 & log(pp(ff))>=log(min(pp(1:ff-1)))) | ff>NumIter
      
      if Manual
	waitforbuttonpress;
	whatbutton = get(gcf,'SelectionType');
	switch whatbutton
	 case 'normal'  % left -- PC 
	  break;
	 case 'alt'      % right -- bad
	  [x y] = ginput(2);
	  B(2) = (y(2)-y(1))/(x(2)-x(1));
	  B(1) = y(1) - B(2)*x(1); 
	  ff=1;
	 case 'extend'     % mid -- go back 
	  ff=ff-1;
	 case 'open'     % double click -- go back 
	  ff=ff-1;
	end
      else
	break
      end
    end
  end
  Slope = [B(2) stats.p(2)];
  b = [B(1) stats.p(1)];

end
return;