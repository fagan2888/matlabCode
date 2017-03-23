%ADDPMENU  Adds menus to the plotting windows in  glmlab

%Copyright 1997, 1998 Peter Dunn
%29 June 1998

uimenu(gcf,'tag','axeslabels','Label','Axes and Labels');
   uimenu(findobj(gcf,'tag','axeslabels'),'Label','Axis Limits',...
      'Callback','figwork(3);');
   uimenu(findobj(gcf,'tag','axeslabels'),'Label','Axis Labels and Titles',...
      'Callback','figwork(1);');

uimenu(gcf,'tag','gridlines','Label','Grid Lines');
   uimenu(findobj(gcf,'tag','gridlines'),'Label','X-axis Grid Lines',...
      'Callback','figwork(2,gcf,1)');
   uimenu(findobj(gcf,'tag','gridlines'),'Label','Y-axis Grid Lines',...
      'Callback','figwork(2,gcf,2)');

uimenu(gcf,'tag','markerats','Label','Marker Attributes');
   uimenu(findobj(gcf,'tag','markerats'),'tag','mstyle','Label','Marker Style');
      uimenu(findobj(gcf,'tag','mstyle'),'Label','point',...
         'Callback','figwork(4,''.'')');
      uimenu(findobj(gcf,'tag','mstyle'),'Label','circle',...
         'Callback','figwork(4,''o'');');
      uimenu(findobj(gcf,'tag','mstyle'),'Label','cross',...
         'Callback','figwork(4,''x'');');
      uimenu(findobj(gcf,'tag','mstyle'),'Label','plus',...
         'Callback','figwork(4,''+'');');
      uimenu(findobj(gcf,'tag','mstyle'),'Label','star',...
         'Callback','figwork(4,''*'');');
      uimenu(findobj(gcf,'tag','mstyle'),'Label','square',...
         'Callback','figwork(4,''s'');');
      uimenu(findobj(gcf,'tag','mstyle'),'Label','diamond',...
         'Callback','figwork(4,''d'');');
      uimenu(findobj(gcf,'tag','mstyle'),'Label','triangle down',...
         'Callback','figwork(4,''v'');');
      uimenu(findobj(gcf,'tag','mstyle'),'Label','triangle up',...
         'Callback','figwork(4,''^'');');
      uimenu(findobj(gcf,'tag','mstyle'),'Label','triangle right',...
         'Callback','figwork(4,''>'');');
      uimenu(findobj(gcf,'tag','mstyle'),'Label','triangle left',...
         'Callback','figwork(4,''<'');');
      uimenu(findobj(gcf,'tag','mstyle'),'Label','pentagram',...
         'Callback','figwork(4,''p'');');
      uimenu(findobj(gcf,'tag','mstyle'),'Label','hexagram',...
        'Callback','figwork(4,''h'');');

   uimenu(findobj(gcf,'tag','markerats'),'tag','mecolor','Label','Marker Edge Colour');
      uimenu(findobj(gcf,'tag','mecolor'),'Label','yellow',...
        'Callback','figwork(5,''y'');');
      uimenu(findobj(gcf,'tag','mecolor'),'Label','magenta',...
        'Callback','figwork(5,''m'');');
      uimenu(findobj(gcf,'tag','mecolor'),'Label','cyan',...
        'Callback','figwork(5,''c'');');
      uimenu(findobj(gcf,'tag','mecolor'),'Label','red',...
        'Callback','figwork(5,''r'');');
      uimenu(findobj(gcf,'tag','mecolor'),'Label','green',...
        'Callback','figwork(5,''g'');');
      uimenu(findobj(gcf,'tag','mecolor'),'Label','blue',...
        'Callback','figwork(5,''b'');');
      uimenu(findobj(gcf,'tag','mecolor'),'Label','white',...
        'Callback','figwork(5,''w'');');
      uimenu(findobj(gcf,'tag','mecolor'),'Label','black',...
        'Callback','figwork(5,''k'');');

   uimenu(findobj(gcf,'tag','markerats'),'tag','mfcolor','Label','Marker Face Colour');
      uimenu(findobj(gcf,'tag','mfcolor'),'Label','yellow',...
        'Callback','figwork(6,''y'');');
      uimenu(findobj(gcf,'tag','mfcolor'),'Label','magenta',...
        'Callback','figwork(6,''m'');');
      uimenu(findobj(gcf,'tag','mfcolor'),'Label','cyan',...
        'Callback','figwork(6,''c'');');
      uimenu(findobj(gcf,'tag','mfcolor'),'Label','red',...
        'Callback','figwork(6,''r'');');
      uimenu(findobj(gcf,'tag','mfcolor'),'Label','green',...
        'Callback','figwork(6,''g'');');
      uimenu(findobj(gcf,'tag','mfcolor'),'Label','blue',...
        'Callback','figwork(6,''b'');');
      uimenu(findobj(gcf,'tag','mfcolor'),'Label','white',...
        'Callback','figwork(6,''w'');');
      uimenu(findobj(gcf,'tag','mfcolor'),'Label','black',...
        'Callback','figwork(6,''k'');');

   uimenu(findobj(gcf,'tag','markerats'),'tag','msize','Label','Marker Size');
      uimenu(findobj(gcf,'tag','msize'),'Label','4 pt',...
        'Callback','figwork(7,4);');
      uimenu(findobj(gcf,'tag','msize'),'Label','6 pt', ...
       'Callback','figwork(7,6);');
      uimenu(findobj(gcf,'tag','msize'),'Label','8 pt', ...
       'Callback','figwork(7,8);');
      uimenu(findobj(gcf,'tag','msize'),'Label','10 pt',...
       'Callback','figwork(7,10);');
      uimenu(findobj(gcf,'tag','msize'),'Label','11 pt',...
       'Callback','figwork(7,11);');
      uimenu(findobj(gcf,'tag','msize'),'Label','12 pt',...
       'Callback','figwork(7,12);');
      uimenu(findobj(gcf,'tag','msize'),'Label','14 pt',...
       'Callback','figwork(7,14);');
      uimenu(findobj(gcf,'tag','msize'),'Label','16 pt',...
       'Callback','figwork(7,16);');
      uimenu(findobj(gcf,'tag','msize'),'Label','18 pt',...
       'Callback','figwork(7,18);');
      uimenu(findobj(gcf,'tag','msize'),'Label','20 pt',...
       'Callback','figwork(7,20);');
