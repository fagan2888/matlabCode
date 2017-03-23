function spzoom(action)
%SPZOOM  Spectrum Viewer zoom function.
%  Contains callbacks for Zoom button group of spectview.
%    mousezoom
%    zoomout
%    zoominx
%    zoomoutx
%    zoominy
%    zoomouty

%   Copyright (c) 1988-98 by The MathWorks, Inc.
% $Revision: 1.1 $
 
fig = gcf;
ud = get(fig,'userdata');

if ud.pointer==2   % help mode
    if strcmp(action,'mousezoom')
        state = btnstate(fig,'zoomgroup',1);
        if state
              btnup(fig,'zoomgroup',1)  % toggle button state back to
                                        % the way it was
        else
              btndown(fig,'zoomgroup',1) 
        end
    end
    spthelp('exit','spzoom',action)
    return
end

switch action

case 'mousezoom'
    state = btnstate(fig,'zoomgroup',1);
    if state == 1   % button is currently down
        set(fig,'windowbuttondownfcn','sbswitch(''spzoom'',''mousedown'')')
        ud.pointer = 1;  
        set(fig,'userdata',ud)
        setptr(fig,'arrow')
    else   % button is currently up - turn off zoom mode
        set(fig,'windowbuttondownfcn','')
        ud.pointer = 0;  
        set(fig,'userdata',ud)
        setptr(fig,'arrow')
    end

case 'zoomout'
    set(ud.mainaxes,'xlim',ud.limits.xlim,'ylim',ud.limits.ylim)
    
    if ud.prefs.tool.ruler
        ruler('newlimits',fig)
    end
    
case 'zoominx'
    xlim = get(ud.mainaxes,'xlim');
    newxlim = .25*[3 1]*xlim' + [0 diff(xlim)/2];
    if diff(newxlim) > 1e-13;
       set(ud.mainaxes,'xlim',newxlim)
       if ud.prefs.tool.ruler
           ruler('newlimits')
       end
    end

case 'zoomoutx'
    xlim = get(ud.mainaxes,'xlim');
    xlim = .5*[3 -1]*xlim' + [0 diff(xlim)*2];
    xlim = [max(xlim(1),ud.limits.xlim(1)) min(xlim(2),ud.limits.xlim(2))];
    set(ud.mainaxes,'xlim',xlim)
    if ud.prefs.tool.ruler
        ruler('newlimits')
    end

case 'zoominy'
    ylim = get(ud.mainaxes,'ylim');
    newylim = .25*[3 1]*ylim' + [0 diff(ylim)/2];
    if diff(newylim) > 0;
       set(ud.mainaxes,'ylim',newylim)
       if ud.prefs.tool.ruler
           ruler('newlimits')
       end
    end

case 'zoomouty'
    ylim = get(ud.mainaxes,'ylim');
    ylim = .5*[3 -1]*ylim' + [0 diff(ylim)*2];
    ylim = [max(ylim(1),ud.limits.ylim(1)) min(ylim(2),ud.limits.ylim(2))];
    set(ud.mainaxes,'ylim',ylim)
    if ud.prefs.tool.ruler
        ruler('newlimits')
    end

%-------------- these are self callbacks:
case 'mousedown'
    ud.justzoom = get(fig,'currentpoint'); 
    set(fig,'userdata',ud)

    pstart = get(fig,'currentpoint');

    % don't do anything if click is outside mainaxes_port
    fp = get(fig,'position');   % in pixels already
    sz = ud.sz;
    toolbar_ht = sz.ih;
    left_width = ud.left_width;
    mp = [left_width 0  fp(3)-(left_width)  fp(4)-(toolbar_ht)];
    %click is outside of main panel:
    if ~pinrect(pstart,[mp(1) mp(1)+mp(3) mp(2) mp(2)+mp(4)])
        if ~ud.prefs.tool.zoompersist
            % if click was on Mouse Zoom button, don't turn off button because
            % it will get turned off by its own callback  
            zg = findobj(fig,'type','axes','tag','zoomgroup');
            zgPos = get(zg,'position');
            if ~pinrect(pstart,[zgPos(1) zgPos(1)+zgPos(3)/6 ...
                                zgPos(2) zgPos(2)+zgPos(4)])
                btnup(fig,'zoomgroup',1);
                spzoom('mousezoom')
            end
        end
        return
    end
    
    r=rbbox([pstart 0 0],pstart);

    oldxlim = get(ud.mainaxes,'xlim');
    oldylim = get(ud.mainaxes,'ylim');

    if all(r([3 4])==0)
        % just a click - zoom about that point
        p1 = get(ud.mainaxes,'currentpoint');

        switch get(fig,'selectiontype')
        case 'normal'     % zoom in
            xlim = p1(1,1) + [-.25 .25]*diff(oldxlim);
            ylim = p1(1,2) + [-.25 .25]*diff(oldylim);
        otherwise    % zoom out
            xlim = p1(1,1) + [-1 1]*diff(oldxlim);
            ylim = p1(1,2) + [-1 1]*diff(oldylim);
        end

    elseif any(r([3 4])==0)  
        % zero width or height - stay in zoom mode and 
        % try again
        return

    else 
        % zoom to the rectangle dragged
        set(fig,'currentpoint',[r(1) r(2)])
        p1 = get(ud.mainaxes,'currentpoint');
        set(fig,'currentpoint',[r(1)+r(3) r(2)+r(4)])
        p2 = get(ud.mainaxes,'currentpoint');
        
        xlim = [p1(1,1) p2(1,1)];
        ylim = [p1(1,2) p2(1,2)];
    end

    newxlim = inbounds(xlim,ud.limits.xlim);
    newylim = inbounds(ylim,ud.limits.ylim);
    if diff(newxlim) > 1e-13 
       set(ud.mainaxes,'xlim',newxlim)
    else
       newxlim = oldxlim;
    end
    if diff(newylim) > 0
       set(ud.mainaxes,'ylim',newylim)
    end
    if ud.prefs.tool.ruler
        ruler('newlimits')
    end
    if ~ud.prefs.tool.zoompersist
        setptr(fig,'arrow')
        set(fig,'windowbuttondownfcn','')
        btnup(fig,'zoomgroup',1);
        ud.pointer = 0;  
    end
    set(fig,'userdata',ud)
    set(fig,'currentpoint',ud.justzoom)

end

        


