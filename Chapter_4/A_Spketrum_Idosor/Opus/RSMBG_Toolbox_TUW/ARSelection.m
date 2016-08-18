function varargout = ARSelection(varargin)
% ARSELECTION M-file for ARSelection.fig
%      ARSELECTION, by itself, creates a new ARSELECTION or raises the existing
%      singleton*.
%
%      H = ARSELECTION returns the handle to a new ARSELECTION or the handle to
%      the existing singleton*.
%
%      ARSELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARSELECTION.M with the given input arguments.
%
%      ARSELECTION('Property','Value',...) creates a new ARSELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ARSelectionTool_RSM2008_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ARSelection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help ARSelection

% Last Modified by GUIDE v2.5 13-Jan-2009 12:17:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ARSelection_OpeningFcn, ...
                   'gui_OutputFcn',  @ARSelection_OutputFcn, ...
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


% --- Executes just before ARSelection is made visible.
function ARSelection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ARSelection (see VARARGIN)

% Choose default command line output for ARSelection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ARSelection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ARSelection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
NewStrValW1=get(hObject,'String');
wn1=str2double(NewStrValW1);
handles.edit1=wn1;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
NewStrValW2=get(hObject,'String');
wn2=str2double(NewStrValW2);
handles.edit2=wn2;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
NewStrValW3=get(hObject,'String');
wn3=str2double(NewStrValW3);
handles.edit3=wn3;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
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
RSMmat=evalin('base','BCP.RSM_Matrix'); % RSM matrix
Wavenumber=evalin('base','BCP.Wavenumber');
SMmat=evalin('base','BCP.LCIR'); % Blank matrix
w1=handles.edit1; % Start eval interval (cm-1)
w2=handles.edit2; % End eval interval (cm-1)
w3=handles.edit3; % Charact wavenumber (cm-1)
[Difference1,c1]=min(abs(w1-Wavenumber)); 
[Difference2,c2]=min(abs(w2-Wavenumber)); 
[Difference3,c3]=min(abs(w3-Wavenumber)); 
Mr=size(RSMmat,1); % Number of spectra included in the RSMmat
Sr=size(SMmat,1); % Number of spectra in LCIR
WnSize=size(Wavenumber,2); % Number of wavenumbers
t=1; 
SSM=zeros(Sr,WnSize); % pre-allocating for speed
for j=c1:c2;
      for k=(c1+1):c2;
           VR=RSMmat(:,k)./RSMmat(:,j); 
          for p=1:Sr
                Hsample=SMmat(p,k)/SMmat(p,j); 
                [minimo,Bref]=min(abs(VR-Hsample)); % Location of the closest spectra in the RSM according to the Wn1/Wn2 ratio
                SSM(p,:)=SMmat(p,:)-RSMmat(Bref,:); % Corrected Matrix. No KF.              
          end
  ARplot(t,1)=Wavenumber(j); % Wn1
  ARplot(t,2)=Wavenumber(k); % Wn2
  ARplot(t,3)=rmse(SSM(:,c3)); % Noise at c3 using this AR ratio
t=t+1
      end
end

handles.pushbutton1=ARplot;
ARplot2=sortrows(ARplot,3);
guidata(hObject,handles);
set(handles.text18,'String',ARplot2(1,1));
set(handles.text19,'String',ARplot2(1,2));
checkLabels={'Results from the selection of the AR using Abs. at Wn'};
varNames={'SAR'};
items={handles.pushbutton1};
export2wsdlg(checkLabels,varNames,items,'Save obtained results: ');

function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double
NewStrValW10=get(hObject,'String');
wn10=str2double(NewStrValW10);
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

