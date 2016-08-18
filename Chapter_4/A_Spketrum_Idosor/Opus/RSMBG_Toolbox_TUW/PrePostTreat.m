function varargout = PrePostTreat(varargin)
% PREPOSTTREAT M-file for PrePostTreat.fig
%      PREPOSTTREAT, by itself, creates a new PREPOSTTREAT or raises the existing
%      singleton*.
%
%      H = PREPOSTTREAT returns the handle to a new PREPOSTTREAT or the handle to
%      the existing singleton*.
%
%      PREPOSTTREAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREPOSTTREAT.M with the given input arguments.
%
%      PREPOSTTREAT('Property','Value',...) creates a new PREPOSTTREAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PrePostTreat_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PrePostTreat_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help PrePostTreat

% Last Modified by GUIDE v2.5 13-Jan-2009 09:41:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PrePostTreat_OpeningFcn, ...
                   'gui_OutputFcn',  @PrePostTreat_OutputFcn, ...
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


% --- Executes just before PrePostTreat is made visible.
function PrePostTreat_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PrePostTreat (see VARARGIN)

% Choose default command line output for PrePostTreat
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PrePostTreat wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = PrePostTreat_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
editDerivative=get(hObject,'String');
SG_Derivative=str2double(editDerivative);
handles.edit5=SG_Derivative;
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


% --- Executes on button press in PB_SG.
function PB_SG_Callback(hObject, eventdata, handles)
% hObject    handle to PB_SG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DM=evalin('base','BCP.SMatrix');;% Data MatrixBCP.SMatrix
WV=evalin('base','BCP.Wavenumber'); % Wavenumber vector 
InputWidth=handles.edit3; % Width
InputOrder=handles.edit4; % Order polinomial
InputDerivative=handles.edit5; % Order derivative
typeOfData=handles.DataType;
if (typeOfData==1)
    DM=DM;
    if InputDerivative==0
    ModifiedDM=savgol(DM,InputWidth,InputOrder,InputDerivative);
    else
     ModifiedDM=-savgol(DM,InputWidth,InputOrder,InputDerivative);  
    end
else
    DM=DM';
    ModifiedDM=savgol(DM,InputWidth,InputOrder,InputDerivative);
    ModifiedDM=ModifiedDM';
end
handles.PB_SG=ModifiedDM;
guidata(hObject,handles);
checkLabels={'SAVGOL Savitsky-Golay smoothing and differentiation'};
varNames={'SGMatrix'};
items={handles.PB_SG};
export2wsdlg(checkLabels,varNames,items,'Save output: Matrix of smoothed and differentiated ROW vectors: ');

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
editNormalization=get(hObject,'String');
Normalization=str2double(editNormalization);
handles.edit6=Normalization;
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



function BLWn_Callback(hObject, eventdata, handles)
% hObject    handle to BLWn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BLWn as text
%        str2double(get(hObject,'String')) returns contents of BLWn as a double
editBLWnum=get(hObject,'String');
BLWnum=str2double(editBLWnum);
handles.BLWn=BLWnum;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function BLWn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BLWn (see GCBO)
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


% --- Executes on button press in PB_BLC.
function PB_BLC_Callback(hObject, eventdata, handles)
% hObject    handle to PB_BLC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DM=evalin('base','BCP.SMatrix');;% Data MatrixBCP.SMatrix
WV=evalin('base','BCP.Wavenumber'); % Wavenumber vector 
BLW=handles.BLWn; % Baseline correction Wavenumber (cm-1)
[rowsDM,colsDM]=size(DM); % Number of [spectra,waveunmbers] included in the Data Matrix
[D1,cBL]=min(abs(BLW-WV)); % cBL=Column baseline correction
DM2=DM(:,:);
blcDM=ones(rowsDM,colsDM);
for i=1:rowsDM
    for j=1:colsDM
       blcDM(i,j)=DM(i,j)-DM2(i,cBL);
    end
end
handles.PB_BLC=blcDM;
guidata(hObject,handles);
checkLabels={'Save the obtained single point baseline corrected matrix'};
varNames={'BLC_Matrix'};
items={handles.PB_BLC};
export2wsdlg(checkLabels,varNames,items,'Save single point baseline corrected matrix: ');


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
editWidth=get(hObject,'String');
SG_Width=str2double(editWidth);
handles.edit3=SG_Width;
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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
editOrder=get(hObject,'String');
SG_Order=str2double(editOrder);
handles.edit4=SG_Order;
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

% --- Executes on selection change in DataType.
function DataType_Callback(hObject, eventdata, handles)
% hObject    handle to DataType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns DataType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DataType
val=get(hObject,'Value');
handles.DataType=val;
%set(handles.DataType,'String')
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function DataType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DataType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
popmenu4=get(handles.popupmenu4,'String');
pm4=get(handles.popupmenu4,'Value');

if pm4==1
    
else
    selec4=char([popmenu4(pm4)]);
    SMatrix=evalin('base',selec4);
    assignin('base','SMatrix',SMatrix);
    evalin('base','BCP.SMatrix=SMatrix;');
    set(handles.popupmenu4,'enable','on')
end

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
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
lsv(1)={'Select a RSM matrix'};
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

% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5
popmenu5=get(handles.popupmenu5,'String');
pm5=get(handles.popupmenu5,'Value');

if pm5==1
    
else
    selec5=char([popmenu5(pm5)]);
    Wavenumber=evalin('base',selec5);
    assignin('base','Wavenumber',Wavenumber);
    evalin('base','BCP.Wavenumber=Wavenumber;');
    set(handles.popupmenu5,'enable','on')
end

% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
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

