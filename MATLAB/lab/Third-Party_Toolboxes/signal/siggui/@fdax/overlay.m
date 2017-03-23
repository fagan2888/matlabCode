function overlay(ax,s)
%OVERLAY Overlay method for fdax object
%  Inputs:
%    ax - fdax object; .overlay may be 'on' or 'off'
%    s - spectrum structure - if empty, removes spectrum from axes

%   Author: T. Krauss
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $

axstruct = struct(ax);
h = axstruct.h;

objud = get(h,'userdata');

switch objud.overlay
case 'on'
    L = objud.overlayhandle;
    if isempty(s)
        set(L,'visible','off','xdata',[],'ydata',[])
    else
        set(L,'xdata',s.f,'ydata',10*log10(s.P),'visible','on')
    end
    objud.overlayhandle = L;
    set(h,'userdata',objud)
    
case 'off'
   % do nothing
   
end