function varargout = PLSSelectionTool(varargin)
% PLSSELECTIONTOOL M-file for PLSSelectionTool.fig
%      PLSSELECTIONTOOL, by itself, creates a new PLSSELECTIONTOOL or raises the existing
%      singleton*.
%
%      H = PLSSELECTIONTOOL returns the handle to a new PLSSELECTIONTOOL or the handle to
%      the existing singleton*.
%
%      PLSSELECTIONTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLSSELECTIONTOOL.M with the given input arguments.
%
%      PLSSELECTIONTOOL('Property','Value',...) creates a new PLSSELECTIONTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PLSSelectionTool_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PLSSelectionTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help PLSSelectionTool

% Last Modified by GUIDE v2.5 07-Aug-2007 17:05:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PLSSelectionTool_OpeningFcn, ...
                   'gui_OutputFcn',  @PLSSelectionTool_OutputFcn, ...
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


% --- Executes just before PLSSelectionTool is made visible.
function PLSSelectionTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PLSSelectionTool (see VARARGIN)

% Choose default command line output for PLSSelectionTool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PLSSelectionTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function [M1]=get_name1(handles)
list_entries1=get(handles.listbox1,'String');
index_entries1=get(handles.listbox1,'Value');
M1=list_entries1{index_entries1(1)};

function [M2]=get_name2(handles)
list_entries2=get(handles.listbox2,'String');
index_entries2=get(handles.listbox2,'Value');
M2=list_entries2{index_entries2(1)};

function [M3]=get_name3(handles)
list_entries3=get(handles.listbox3,'String');
index_entries3=get(handles.listbox3,'Value');
M3=list_entries3{index_entries3(1)};


% --- Outputs from this function are returned to the command line.
function varargout = PLSSelectionTool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function opini_Callback(hObject, eventdata, handles)
% hObject    handle to opini (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of opini as text
%        str2double(get(hObject,'String')) returns contents of opini as a double
NewStrOpini=get(hObject,'String');
wnini=str2double(NewStrOpini);
handles.opini=wnini;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function opini_CreateFcn(hObject, eventdata, handles)
% hObject    handle to opini (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function opend_Callback(hObject, eventdata, handles)
% hObject    handle to opend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of opend as text
%        str2double(get(hObject,'String')) returns contents of opend as a double
NewStropend=get(hObject,'String');
wnend=str2double(NewStropend);
handles.opend=wnend;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function opend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to opend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function opmaxlv_Callback(hObject, eventdata, handles)
% hObject    handle to opmaxlv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of opmaxlv as text
%        str2double(get(hObject,'String')) returns contents of opmaxlv as a double
NewStropmaxlv=get(hObject,'String');
Nopmaxlv=str2double(NewStropmaxlv);
handles.opmaxlv=Nopmaxlv;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function opmaxlv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to opmaxlv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function opref_Callback(hObject, eventdata, handles)
% hObject    handle to opref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of opref as text
%        str2double(get(hObject,'String')) returns contents of opref as a double
NewStropref=get(hObject,'String');
wnopref=str2double(NewStropref);
handles.opref=wnopref;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function opref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to opref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function opnoise_Callback(hObject, eventdata, handles)
% hObject    handle to opnoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of opnoise as text
%        str2double(get(hObject,'String')) returns contents of opnoise as a double
NewStrValWNoise=get(hObject,'String');
wnoise=str2double(NewStrValWNoise);
handles.opnoise=wnoise;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function opnoise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to opnoise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonPLSO1.
function pushbuttonPLSO1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPLSO1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x1]=get_name1(handles);
[x2]=get_name2(handles);
[x3]=get_name3(handles);
w1=handles.opref; % Reference Wavenumber (cm-1)
w2=handles.opini; % Initial wavenumber range (cm-1)
w3=handles.opend; % End PLS range (cm-1) (Initial>End)
n1=handles.opmaxlv; % Maximum number of PLS factors
NWn=handles.opnoise; % Noise evaluation wavenumber;
Mr=evalin('base',['size(' x1 ',1)']); % Number of spectra included in the RSM
Sr=evalin('base',['size(' x2 ',1)']); % Number of spectra included in the Sample Matrix
M1=evalin('base',x1); % RSM
M2=evalin('base',x2); % Sample Matrix
M3=evalin('base',x3); % Wavenumbers vector
[Difference1,c1]=min(abs(w1-M3)); % c1=Column reference wavenumber
[Difference2,c2]=min(abs(w2-M3)); % c2=Column 1st wavenumber
[Difference3,c3]=min(abs(w3-M3)); % c3=Column 2nd wavenumber
[Difference21,cnoise]=min(abs(NWn-M3)); % c21=Column number for the NOISE evaluation

VectorRef=M1(:,c1); % Reference values for the PLS calibration model
[NrWn]=size(M3,2); % Creation of the intervals for iPLS
int_vector=[1 (c2-1) c2 c3 (c3+1) NrWn];
t=1
for nlv=1:n1; % for 1 to n1 latent variables
%% PLS Model %%
[PLS_SampleMatrix]=plspred(M1,VectorRef,M2,0,nlv); % Predicted abs @ ref. Wn

[CSMr]=size(M2,1); %Numero de espectros muestra
[RMS]=size(VectorRef,1); %Numero de espectros RSM
    for p=1:CSMr; %PAra todos los espectros muestra
     [minimum,jj]=min(abs(VectorRef-PLS_SampleMatrix(p,1))); %Busca en minimo en rsm
      CalcEluent=M1(jj,:);
      EluentRef=CalcEluent(1,c1);
      SampleRef=M2(p,c1);
      PLS_SolutionSampleMatrix(p,:)=M2(p,:)-(CalcEluent.*(SampleRef/EluentRef));
    end
    NsEval(t,1)=[sqrt(mean(std(PLS_SolutionSampleMatrix(:,cnoise).^2)))]; % Form measuring the RSM
      t=t+1;
end
axes(handles.axes1)
%bar(NsEval,'color',[1 0 0]);
bar (NsEval);
legend (['RMS noise']);
legend('boxoff');
xlabel ('Number of LVs');
ylabel ('Noise (RMS)');
grid on;
zoom on;
handles.pushbuttonPLSO1=NsEval;
guidata(hObject,handles);
checkLabels={'Save the plot for the selection of the number of LVs'};
varNames={'Slection_LVs'};
items={handles.pushbuttonPLSO1};
export2wsdlg(checkLabels,varNames,items,'Save effect of LVs on the calculated Noise (RMS): ');



% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
vars = evalin('base','who');                                  % get list of vars and sizes in base workspace
set(handles.listbox1,'String',vars)


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
vars = evalin('base','who');                                  % get list of vars and sizes in base workspace
set(handles.listbox2,'String',vars)


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3
vars = evalin('base','who');                                  % get list of vars and sizes in base workspace
set(handles.listbox3,'String',vars)


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


