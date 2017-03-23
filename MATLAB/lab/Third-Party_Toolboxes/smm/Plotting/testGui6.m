function varargout = testGui6(varargin)
% TESTGUI6 M-file for testGui6.fig
%      TESTGUI6, by itself, creates a new TESTGUI6 or raises the existing
%      singleton*.
%
%      H = TESTGUI6 returns the handle to a new TESTGUI6 or the handle to
%      the existing singleton*.
%
%      TESTGUI6('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTGUI6.M with the given input arguments.
%
%      TESTGUI6('Property','Value',...) creates a new TESTGUI6 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testGui6_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testGui6_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help testGui6

% Last Modified by GUIDE v2.5 06-Oct-2005 01:16:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testGui6_OpeningFcn, ...
                   'gui_OutputFcn',  @testGui6_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before testGui6 is made visible.
function testGui6_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testGui6 (see VARARGIN)

mazeMeasMat = varargin{1};
handles.fieldsNames = fieldnames(mazeMeasMat)


% Choose default command line output for testGui6
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testGui6 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testGui6_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in xVarMenu.
function xVarMenu_Callback(hObject, eventdata, handles)
% hObject    handle to xVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'String','junk')%handles.fieldNames)
guidata(hObject,handles)
keyboard

% Hints: contents = get(hObject,'String') returns xVarMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from xVarMenu


% --- Executes during object creation, after setting all properties.
function xVarMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in yVarMenu.
function yVarMenu_Callback(hObject, eventdata, handles)
% hObject    handle to yVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns yVarMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from yVarMenu


% --- Executes during object creation, after setting all properties.
function yVarMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in cVarMenu.
function cVarMenu_Callback(hObject, eventdata, handles)
% hObject    handle to cVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns cVarMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cVarMenu


% --- Executes during object creation, after setting all properties.
function cVarMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in figVarMenu.
function figVarMenu_Callback(hObject, eventdata, handles)
% hObject    handle to figVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns figVarMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from figVarMenu


% --- Executes during object creation, after setting all properties.
function figVarMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figVarMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in var2InclMenu.
function subplotVarMenu_Callback(hObject, eventdata, handles)
% hObject    handle to var2InclMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns var2InclMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from var2InclMenu


% --- Executes during object creation, after setting all properties.
function subplotVarMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var2InclMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in var2InclMenu.
function var1InclMenu_Callback(hObject, eventdata, handles)
% hObject    handle to var2InclMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns var2InclMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from var2InclMenu


% --- Executes during object creation, after setting all properties.
function var1InclMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var2InclMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes on selection change in var2InclMenu.
function var2InclMenu_Callback(hObject, eventdata, handles)
% hObject    handle to var2InclMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns var2InclMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from var2InclMenu


% --- Executes during object creation, after setting all properties.
function var2InclMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var2InclMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in var3InclMenu.
function var3InclMenu_Callback(hObject, eventdata, handles)
% hObject    handle to var3InclMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns var3InclMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from var3InclMenu


% --- Executes during object creation, after setting all properties.
function var3InclMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var3InclMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in plot2d.
function plot2d_Callback(hObject, eventdata, handles)
% hObject    handle to plot2d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in plot3d.
function plot3d_Callback(hObject, eventdata, handles)
% hObject    handle to plot3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in plot1d.
function plot1d_Callback(hObject, eventdata, handles)
% hObject    handle to plot1d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in holdOnBool.
function holdOnBool_Callback(hObject, eventdata, handles)
% hObject    handle to holdOnBool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of holdOnBool



function xVarInclCritInput_Callback(hObject, eventdata, handles)
% hObject    handle to xVarInclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xVarInclCritInput as text
%        str2double(get(hObject,'String')) returns contents of xVarInclCritInput as a double


% --- Executes during object creation, after setting all properties.
function xVarInclCritInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xVarInclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function xVarExclCritInput_Callback(hObject, eventdata, handles)
% hObject    handle to xVarInclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xVarInclCritInput as text
%        str2double(get(hObject,'String')) returns contents of xVarInclCritInput as a double


% --- Executes during object creation, after setting all properties.
function xVarExclCritInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xVarInclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function yVarInclCritInput_Callback(hObject, eventdata, handles)
% hObject    handle to yVarInclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yVarInclCritInput as text
%        str2double(get(hObject,'String')) returns contents of yVarInclCritInput as a double


% --- Executes during object creation, after setting all properties.
function yVarInclCritInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yVarInclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function yVarExclCritInput_Callback(hObject, eventdata, handles)
% hObject    handle to yVarExclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yVarExclCritInput as text
%        str2double(get(hObject,'String')) returns contents of yVarExclCritInput as a double


% --- Executes during object creation, after setting all properties.
function yVarExclCritInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yVarExclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function cVarInclCritInput_Callback(hObject, eventdata, handles)
% hObject    handle to cVarInclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cVarInclCritInput as text
%        str2double(get(hObject,'String')) returns contents of cVarInclCritInput as a double


% --- Executes during object creation, after setting all properties.
function cVarInclCritInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cVarInclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function cVarExclCritInput_Callback(hObject, eventdata, handles)
% hObject    handle to cVarExclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cVarExclCritInput as text
%        str2double(get(hObject,'String')) returns contents of cVarExclCritInput as a double


% --- Executes during object creation, after setting all properties.
function cVarExclCritInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cVarExclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function figVarInclCritInput_Callback(hObject, eventdata, handles)
% hObject    handle to figVarInclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of figVarInclCritInput as text
%        str2double(get(hObject,'String')) returns contents of figVarInclCritInput as a double


% --- Executes during object creation, after setting all properties.
function figVarInclCritInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figVarInclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function figVarExclCritInput_Callback(hObject, eventdata, handles)
% hObject    handle to figVarExclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of figVarExclCritInput as text
%        str2double(get(hObject,'String')) returns contents of figVarExclCritInput as a double


% --- Executes during object creation, after setting all properties.
function figVarExclCritInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figVarExclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function subplotVarInclCritInput_Callback(hObject, eventdata, handles)
% hObject    handle to subplotVarInclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subplotVarInclCritInput as text
%        str2double(get(hObject,'String')) returns contents of subplotVarInclCritInput as a double


% --- Executes during object creation, after setting all properties.
function subplotVarInclCritInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subplotVarInclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function subplotVarExclCritInput_Callback(hObject, eventdata, handles)
% hObject    handle to subplotVarExclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subplotVarExclCritInput as text
%        str2double(get(hObject,'String')) returns contents of subplotVarExclCritInput as a double


% --- Executes during object creation, after setting all properties.
function subplotVarExclCritInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subplotVarExclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function var1InclCritInput_Callback(hObject, eventdata, handles)
% hObject    handle to var2InclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var2InclCritInput as text
%        str2double(get(hObject,'String')) returns contents of var2InclCritInput as a double


% --- Executes during object creation, after setting all properties.
function var1InclCritInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var2InclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function var1ExclCritInput_Callback(hObject, eventdata, handles)
% hObject    handle to var2InclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var2InclCritInput as text
%        str2double(get(hObject,'String')) returns contents of var2InclCritInput as a double


% --- Executes during object creation, after setting all properties.
function var1ExclCritInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var2InclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function var2InclCritInput_Callback(hObject, eventdata, handles)
% hObject    handle to var2InclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var2InclCritInput as text
%        str2double(get(hObject,'String')) returns contents of var2InclCritInput as a double


% --- Executes during object creation, after setting all properties.
function var2InclCritInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var2InclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function var2ExclCritInput_Callback(hObject, eventdata, handles)
% hObject    handle to var2InclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var2InclCritInput as text
%        str2double(get(hObject,'String')) returns contents of var2InclCritInput as a double


% --- Executes during object creation, after setting all properties.
function var2ExclCritInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var2InclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function var3ExclCritInput_Callback(hObject, eventdata, handles)
% hObject    handle to var3ExclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var3ExclCritInput as text
%        str2double(get(hObject,'String')) returns contents of var3ExclCritInput as a double


% --- Executes during object creation, after setting all properties.
function var3ExclCritInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var3ExclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function var3InclCritInput_Callback(hObject, eventdata, handles)
% hObject    handle to var3ExclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of var3ExclCritInput as text
%        str2double(get(hObject,'String')) returns contents of var3ExclCritInput as a double


% --- Executes during object creation, after setting all properties.
function var3InclCritInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to var3ExclCritInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function plotStyleInput_Callback(hObject, eventdata, handles)
% hObject    handle to plotStyleInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotStyleInput as text
%        str2double(get(hObject,'String')) returns contents of plotStyleInput as a double


% --- Executes during object creation, after setting all properties.
function plotStyleInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotStyleInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


