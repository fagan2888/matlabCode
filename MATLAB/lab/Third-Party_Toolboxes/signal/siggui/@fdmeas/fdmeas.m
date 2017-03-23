function obj = fdmeas(varargin)
%FDMEAS  Constructor for filtdes Measurements object
% Syntax:
%    obj = fdmeas('prop1',val1,'prop2',val2,...)  creates a new object
%    obj = fdmeas(objstruct) where objstruct is a structure array with a single
%             field named 'h' and the handle is to a valid object, simply calls
%             class(objstruct,'fdmeas').

%   Author: T. Krauss
%   Copyright (c) 1988-98 by The MathWorks, Inc.
%   $Revision: 1.1 $

if isstruct(varargin{1}) & isequal(fieldnames(varargin{1}),{'h'})
    obj = class(varargin{1},'fdmeas');
    return
end

fig = findobj('type','figure','tag','filtdes');
ud = get(fig,'userdata');

if ~isfield(ud.Objects,'fdmeas') | isempty(ud.Objects.fdmeas)
    pos = 1;
else
    pos = length(ud.Objects.fdmeas)+1;
end

% first define default property values
% objud - object's userdata structure
objud.label = '';
objud.callback = '';
% objud.numeric = 1;  % if 0, the value of this objudect is a string, not a number
objud.value = 0;
objud.lastvalue = 0;
objud.format = '%g';
objud.range = [-Inf Inf];
objud.inclusive = [0 0];
objud.integer = 0;
objud.complex = 0;   % if 0, number must be real; if 1, number can be real or cmplx
objud.editable = 'on';
objud.visible = 'on';
objud.position = pos;  % next available
objud.radiogroup = '';
objud.userdata = [];
objud.help = {''};

% HP - handle properties structure
hp.parent = fig;
hp.style = 'edit';
hp.callback = 'filtdes(''fdmeas'')';

for i = 1:2:length(varargin)

    varargin{i} = lower(varargin{i});
    switch varargin{i}
    case {'label','callback','format','value','lastvalue',...
           'range','inclusive','integer','editable','visible','position',...
           'radiogroup','userdata','help'}
        objud = setfield(objud,varargin{i:i+1});
    otherwise
        hp = setfield(hp,varargin{i:i+1});
    end
    
end

switch hp.style
case 'edit'
    hp.backgroundcolor = 'w';
    hp.horizontalalignment = 'left';
case 'text'
    hp.horizontalalignment = 'left';
case 'popupmenu'
    if objud.value < 1
        objud.value = 1;
    end
case 'frame'
    if ~isfield(objud,'position')
        objud.position = [pos pos+1];
    end
end

hp.visible = objud.visible;
obj.h = uicontrol(hp);
objud.hlabel = fdutil('newlabel',obj.h,objud.label,...
                         objud.position,ud.ht.measFrame);
set(objud.hlabel,'visible',objud.visible)
obj = class(obj,'fdmeas');

set(obj.h,'userdata',objud)

switch hp.style
case {'edit','text'}
    set(obj.h,'string',fdutil('formattedstring',obj));
case {'popupmenu','checkbox','radiobutton'}
    set(obj.h,'value',objud.value)
case 'frame'
    % move to bottom of stacking order if necessary
    needSendToBack = 0;
    for i = 1:length(ud.Objects.fdmeas)
        tempObjHand = ud.Objects.fdmeas(i).h;
        tempObjUD = get(tempObjHand,'userdata');
        tpos = tempObjUD.position;
        switch length(tpos)
        case 1
            if tpos>=objud.position(1) & tpos<=objud.position(2)
                needSendToBack = 1;
            end
        case 2
            if (tpos(1)>=objud.position(1) & tpos(1)<=objud.position(2)) | ...
               (tpos(2)>=objud.position(1) & tpos(2)<=objud.position(2))
                needSendToBack = 1;
            end
        otherwise
            needSendToBack = 1;
        end
        if needSendToBack
            break
        end
    end
    if needSendToBack
        fdutil('sendToBack',fig,[objud.hlabel obj.h ud.ht.specFrame])
    end
    
end

%
% Add this object to figure's object list
%
if ~isfield(ud.Objects,'fdmeas') | isempty(ud.Objects.fdmeas)
    ud.Objects.fdmeas = obj;
else
    ud.Objects.fdmeas(end+1) = obj;
end
set(fig,'userdata',ud)
    
