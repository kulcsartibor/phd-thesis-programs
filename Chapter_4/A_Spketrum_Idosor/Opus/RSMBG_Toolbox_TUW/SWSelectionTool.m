function varargout = SWSelectionTool(varargin)
% SWSELECTIONTOOL M-file for SWSelectionTool.fig
%      SWSELECTIONTOOL, by itself, creates a new SWSELECTIONTOOL or raises the existing
%      singleton*.
%
%      H = SWSELECTIONTOOL returns the handle to a new SWSELECTIONTOOL or the handle to
%      the existing singleton*.
%
%      SWSELECTIONTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SWSELECTIONTOOL.M with the given input arguments.
%
%      SWSELECTIONTOOL('Property','Value',...) creates a new SWSELECTIONTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SWSelectionTool_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SWSelectionTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help SWSelectionTool

% Last Modified by GUIDE v2.5 13-Jan-2009 15:58:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SWSelectionTool_OpeningFcn, ...
                   'gui_OutputFcn',  @SWSelectionTool_OutputFcn, ...
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


% --- Executes just before SWSelectionTool is made visible.
function SWSelectionTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SWSelectionTool (see VARARGIN)

% Choose default command line output for SWSelectionTool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SWSelectionTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = SWSelectionTool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RSMmat=evalin('base','BCP.RSM_Matrix'); % RSM matrix
Wavenumber=evalin('base','BCP.Wavenumber');
SMmat=evalin('base','BCP.LCIR'); % Blank matrix
w1=handles.edit8; % Start eval interval (cm-1)
w2=handles.edit9; % End eval interval (cm-1)
w3=handles.edit10; % Noise Wn (cm-1)
[D8,c1]=min(abs(w1-Wavenumber)); 
[D2,c2]=min(abs(w2-Wavenumber)); 
[D3,c3]=min(abs(w3-Wavenumber)); % Noise evaluation
Sr=size(SMmat,1); % Number of spectra in LCIR
t=1;
for j=c1:c2 % c5:C6 is the columns interval 
  VR=RSMmat(:,j); % Reference vector at the selected reference wavenumber
    for p=1:Sr
    Hsample=SMmat(p,j);      
    [d1,Bref]=min(abs(VR-Hsample)); % Location of the closest background spectra
    cSMmat(p,:)=SMmat(p,:)-RSMmat(Bref,:); %Correction using the absorbance at the selected wavenumber
    end
    SWplot(t,1)=Wavenumber(j); % Wn1
    SWplot(t,2)=rmse(cSMmat(:,c3));
t=t+1;
end
SWplot2=sortrows(SWplot,2);
set(handles.text13,'String',SWplot2(1,1));
axes(handles.axes1)
plot(SWplot(:,1),SWplot(:,2),'color',[1 0 0]);
legend (['RMS noise']);
legend('boxoff');
xlabel ('Selected Wavenumber','FontSize',7);
set(gca,'XDir','reverse','FontSize',7);
ylabel ('Noise (RMS)','FontSize',7);
grid on;
axis tight
handles.pushbutton1=SWplot;
guidata(hObject,handles);
checkLabels={'Results from the selection of the Single Wavelength'};
varNames={'Result_SSW'};
items={handles.pushbutton1};
export2wsdlg(checkLabels,varNames,items,'Save results: ');




function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
NewStrVal8=get(hObject,'String');
wn8=str2double(NewStrVal8);
handles.edit8=wn8;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
NewStrVal9=get(hObject,'String');
wn9=str2double(NewStrVal9);
handles.edit9=wn9;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double
NewStrVal10=get(hObject,'String');
wn10=str2double(NewStrVal10);
handles.edit10=wn10;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


