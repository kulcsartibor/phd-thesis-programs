function varargout = ChromNoise(varargin)
% CHROMNOISE M-file for ChromNoise.fig
%      CHROMNOISE, by itself, creates a new CHROMNOISE or raises the existing
%      singleton*.
%
%      H = CHROMNOISE returns the handle to a new CHROMNOISE or the handle to
%      the existing singleton*.
%
%      CHROMNOISE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHROMNOISE.M with the given input arguments.
%
%      CHROMNOISE('Property','Value',...) creates a new CHROMNOISE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChromNoise_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChromNoise_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help ChromNoise

% Last Modified by GUIDE v2.5 13-Jan-2009 10:04:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChromNoise_OpeningFcn, ...
                   'gui_OutputFcn',  @ChromNoise_OutputFcn, ...
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


% --- Executes just before ChromNoise is made visible.
function ChromNoise_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChromNoise (see VARARGIN)

% Choose default command line output for ChromNoise
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ChromNoise wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = ChromNoise_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
NewStrValSp1=get(hObject,'String');
Sp1=str2double(NewStrValSp1);
handles.edit4=Sp1;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
NewStrValSp2=get(hObject,'String');
Sp2=str2double(NewStrValSp2);
handles.edit5=Sp2;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
NewStrValWN=get(hObject,'String');
WN=str2double(NewStrValWN);
handles.edit6=WN;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
M1=evalin('base','BCP.SMatrix');;% Data Matrix
M2=evalin('base','BCP.Wavenumber'); % Wavenumber vector 
e4=handles.edit4; % Initial spectra of the chromatogram
e5=handles.edit5; % Last spectra of the chromatogram to evaluate the noise
WnN=handles.edit6; % Wavenumber for the noise evaluation
[Difference21,cN]=min(abs(WnN-M2)); % c21=Column number for the NOISE evaluation
signal=M1(e4:e5,cN);
NoiseEvaluated=[sqrt(mean(std(signal.^2)))]; % just a way to calculate the noise,but there are others ... 

handles.pushbutton1=NoiseEvaluated;
set (handles.text11,'String',NoiseEvaluated);
guidata(hObject,handles);
checkLabels={'Calculated Chromatographic noise'};
varNames={'Noise_RMS'};
items={handles.pushbutton1};
export2wsdlg(checkLabels,varNames,items,'Save the obtained value: ');


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
popmenu1=get(handles.popupmenu1,'String');
pm1=get(handles.popupmenu1,'Value');

if pm1==1
    
else
    selec1=char([popmenu1(pm1)]);
    Wavenumber=evalin('base',selec1);
    assignin('base','Wavenumber',Wavenumber);
    evalin('base','BCP.Wavenumber=Wavenumber;');
    set(handles.popupmenu1,'enable','on')
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
lsvar=evalin('base','whos');
[rr,cc]=size(lsvar);
j=2;
lsv(1)={'Select a wavenumbers vector'};
for i=1:rr,
   csize=length(lsvar(i).class);
    if csize==6,
       if lsvar(i).class=='double',
          lsb=[lsvar(i).name];
           lsv(j)={lsb};
            j=j+1;
        end;
    end;
end;
set(hObject,'string',lsv)

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
popmenu2=get(handles.popupmenu2,'String');
pm2=get(handles.popupmenu2,'Value');

if pm2==1
    
else
    selec2=char([popmenu2(pm2)]);
    SMatrix=evalin('base',selec2);
    assignin('base','SMatrix',SMatrix);
    evalin('base','BCP.SMatrix=SMatrix;');
    set(handles.popupmenu2,'enable','on')
end


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
lsvar=evalin('base','whos');
[rr,cc]=size(lsvar);
j=2;
lsv(1)={'Select a data matrix'};
for i=1:rr,
   csize=length(lsvar(i).class);
    if csize==6,
       if lsvar(i).class=='double',
          lsb=[lsvar(i).name];
           lsv(j)={lsb};
            j=j+1;
        end;
    end;
end;
set(hObject,'string',lsv)

