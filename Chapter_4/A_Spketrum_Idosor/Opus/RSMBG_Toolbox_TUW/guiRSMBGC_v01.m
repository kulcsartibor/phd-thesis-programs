function varargout = guiRSMBGC_v01(varargin)
% GUIRSMBGC_V01 M-file for guiRSMBGC_v01.fig
%      GUIRSMBGC_V01, by itself, creates a new GUIRSMBGC_V01 or raises the existing
%      singleton*.
%
%      H = GUIRSMBGC_V01 returns the handle to a new GUIRSMBGC_V01 or the handle to
%      the existing singleton*.
%
%      GUIRSMBGC_V01('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIRSMBGC_V01.M with the given input arguments.
%
%      GUIRSMBGC_V01('Property','Value',...) creates a new GUIRSMBGC_V01 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiRSMBGC_v01_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiRSMBGC_v01_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiRSMBGC_v01

% Last Modified by GUIDE v2.5 15-Jan-2009 14:52:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiRSMBGC_v01_OpeningFcn, ...
                   'gui_OutputFcn',  @guiRSMBGC_v01_OutputFcn, ...
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


% --- Executes just before guiRSMBGC_v01 is made visible.
function guiRSMBGC_v01_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% UIWAIT makes guiRSMBGC_v01 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiRSMBGC_v01_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;




% --- Executes on selection change in popupmenu15.
function popupmenu5_Callback(hObject, eventdata, handles)
popmenu5=get(handles.popupmenu5,'String');
pm5=get(handles.popupmenu5,'Value');
if pm5==1
else
    selec5=char([popmenu5(pm5)]);
    Chrom_Matrix=evalin('base',selec5);
    assignin('base','Chrom_Matrix',Chrom_Matrix);
    evalin('base','BCP.Chrom_Matrix=Chrom_Matrix;');
    set(handles.popupmenu5,'enable','on')
end

% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
lsvar=evalin('base','whos');
[rr,cc]=size(lsvar);
j=2;
lsv(1)={'Select matrix'};
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

% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
popmenu6=get(handles.popupmenu6,'String');
pm6=get(handles.popupmenu6,'Value');
if pm6==1   
else
    selec6=char([popmenu6(pm6)]);
    Spectra_Matrix=evalin('base',selec6);
    assignin('base','Spectra_Matrix',Spectra_Matrix);
    evalin('base','BCP.Spectra_Matrix=Spectra_Matrix;');
    set(handles.popupmenu6,'enable','on')
end

% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
lsvar=evalin('base','whos');
[rr,cc]=size(lsvar);
j=2;
lsv(1)={'Select matrix'};
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
function popupmenu7_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
UBC_RSM_met=handles.popupmenu4;
if UBC_RSM_met<=4
    runSW_RW_AR_BGC
elseif UBC_RSM_met==5
   runSWPolyfit_2_BGC
elseif UBC_RSM_met==6
    runRWPolyfit_2_BGC
elseif UBC_RSM_met==7
    runARPolyfit_2_BGC
elseif UBC_RSM_met==8
    runSWSplines_BGC
elseif UBC_RSM_met==9
    runRWSplines_BGC
elseif UBC_RSM_met==10
    runARSplines_BGC  
end

function edit9_Callback(hObject, eventdata, handles)
NewStrVal9=get(hObject,'String');
edit9a=str2double(NewStrVal9);
handles.edit9=edit9a;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
NewStrVal10=get(hObject,'String');
edit10a=str2double(NewStrVal10);
handles.edit10=edit10a;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
NewStrVal11=get(hObject,'String');
edit11a=str2double(NewStrVal11);
handles.edit11=edit11a;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
NewStrVal12=get(hObject,'String');
edit12a=str2double(NewStrVal12);
handles.edit12=edit12a;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
NewStrVal13=get(hObject,'String');
edit13a=str2double(NewStrVal13);
handles.edit13=edit13a;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)

NewStrVal14=get(hObject,'String');
edit14a=str2double(NewStrVal14);
handles.edit14=edit14a;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
NewStrVal6=get(hObject,'String');
edit6a=eval(NewStrVal6);
handles.edit6=edit6a;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
axes(handles.axes1)
Plot_Chrom=evalin('base','BCP.Chrom_Matrix');
Wavenumber=evalin('base','BCP.Wavenumber');
wChrom=handles.edit7; %Extract Chromatogram at wChrom
wBL=handles.edit8; %Baseline correction
[dc,cChrom]=min(abs(wChrom-Wavenumber)); 
[dc,cBL]=min(abs(wBL-Wavenumber)); 
if wBL==0
    PlotChromatogram=((Plot_Chrom(:,cChrom)));
else
PlotChromatogram=((Plot_Chrom(:,cChrom)-Plot_Chrom(:,cBL)));
end
plot(PlotChromatogram,'color',[1 0 0]);
legend (['',mat2str(wChrom),' (cm-1)']);
legend('boxoff');
xlabel ('Number of spectra');
ylabel ('Absorbance');
grid on;
%axis tight
handles.pushbutton3=PlotChromatogram;
guidata(hObject,handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
axes(handles.axes1)
Plot_Chrom=evalin('base','BCP.Chrom_Matrix');
Wavenumber=evalin('base','BCP.Wavenumber');
wChrom=handles.edit7; %Extract Chromatogram at wChrom
wBL=handles.edit8; %Baseline correction
[dc,cChrom]=min(abs(wChrom-Wavenumber)); 
[dc,cBL]=min(abs(wBL-Wavenumber));  
if wBL==0
    PlotChromatogram=((Plot_Chrom(:,cChrom)));
else
    PlotChromatogram=((Plot_Chrom(:,cChrom)-Plot_Chrom(:,cBL)));
end
legend (['',mat2str(wChrom),' (cm-1)']);
hold on
plot(PlotChromatogram,'color',[1 0 0]);
legend('boxoff');
xlabel ('Number of spectra');
ylabel ('Absorbance');
grid on;
hold off
guidata(hObject,handles);


function edit7_Callback(hObject, eventdata, handles)
NewStrVal7=get(hObject,'String');
edit7a=str2num(NewStrVal7);
handles.edit7=edit7a;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
NewStrVal8=get(hObject,'String');
edit8a=str2double(NewStrVal8);
handles.edit8=edit8a;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
axes(handles.axes2)
Plot_Spectra=evalin('base','BCP.Spectra_Matrix');
Wavenumber=evalin('base','BCP.Wavenumber');
PlotNrSp=handles.edit6;
plot(Wavenumber,Plot_Spectra(PlotNrSp,:));
xlabel ('Wavenumber (cm-1)');
ylabel ('Absorbance');
grid on;
%axis tight
set(gca,'XDir','reverse');
handles.pushbutton5=Plot_Spectra(PlotNrSp,:);
guidata(hObject,handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
axes(handles.axes2)
Plot_Spectra=evalin('base','BCP.Spectra_Matrix');
Wavenumber=evalin('base','BCP.Wavenumber');
PlotNrSp=handles.edit6;
hold on
plot(Wavenumber,Plot_Spectra(PlotNrSp,:));
xlabel ('Wavenumber (cm-1)');
ylabel ('Absorbance');
grid on;
set(gca,'XDir','reverse');
hold off
handles.pushbutton6=Plot_Spectra(PlotNrSp,:);
guidata(hObject,handles);

% --- Executes on selection change in popupmenu6.
function popupmenu2_Callback(hObject, eventdata, handles)
popmenu2=get(handles.popupmenu2,'String');
pm2=get(handles.popupmenu2,'Value');

if pm2==1
    
else
    selec2=char([popmenu2(pm2)]);
    LCIR=evalin('base',selec2);
    assignin('base','LCIR',LCIR);
    evalin('base','BCP.LCIR=LCIR;');
    set(handles.popupmenu2,'enable','on')
end

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
lsvar=evalin('base','whos');
[rr,cc]=size(lsvar);
j=2;
lsv(1)={'Select a LC-FTIR matrix'};
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
function popupmenu3_Callback(hObject, eventdata, handles)
popmenu3=get(handles.popupmenu3,'String');
pm3=get(handles.popupmenu3,'Value');
if pm3==1
else
    selec3=char([popmenu3(pm3)]);
    Wavenumber=evalin('base',selec3);
    assignin('base','Wavenumber',Wavenumber);
    evalin('base','BCP.Wavenumber=Wavenumber;');
    set(handles.popupmenu3,'enable','on')
end

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
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

% --- Executes on selection change in popupmenu15.
function popupmenu1_Callback(hObject, eventdata, handles)
popmenu1=get(handles.popupmenu1,'String');
pm1=get(handles.popupmenu1,'Value');
if pm1==1
    
else
    selec1=char([popmenu1(pm1)]);
    RSM_Matrix=evalin('base',selec1);
    assignin('base','RSM_Matrix',RSM_Matrix);
    evalin('base','BCP.RSM_Matrix=RSM_Matrix;');
    set(handles.popupmenu1,'enable','on')
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
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


function edit1_Callback(hObject, eventdata, handles)
NewStrVal1=get(hObject,'String');
edit1a=str2double(NewStrVal1);
handles.edit1=edit1a;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
NewStrVal2=get(hObject,'String');
edit2a=str2double(NewStrVal2);
handles.edit2=edit2a;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
NewStrVal3=get(hObject,'String');
edit3a=str2double(NewStrVal3);
handles.edit3=edit3a;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
NewStrVal4=get(hObject,'String');
edit4a=str2double(NewStrVal4);
handles.edit4=edit4a;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
runPLS_BGC

% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
p2p_met=get(hObject,'Value');
handles.popupmenu8=p2p_met;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
NewStrVal15=get(hObject,'String');
edit15a=eval(NewStrVal15);
handles.edit15=edit15a;
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
NewStrVal16=get(hObject,'String');
edit16a=str2double(NewStrVal16);
handles.edit16=edit16a;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
runP2P_BGC


function edit17_Callback(hObject, eventdata, handles)
NewStrVal17=get(hObject,'String');
edit17a=str2double(NewStrVal17);
handles.edit17=edit17a;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
UBC_RSM_met=get(hObject,'Value');
handles.popupmenu4=UBC_RSM_met;
guidata(hObject,handles);
function popupmenu4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
p2pKF_met=get(hObject,'Value');
handles.popupmenu9=p2pKF_met;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
vars = evalin('base','who');
set(handles.popupmenu1,'String',vars)
set(handles.popupmenu2,'String',vars)
set(handles.popupmenu3,'String',vars)
set(handles.popupmenu5,'String',vars)
set(handles.popupmenu6,'String',vars)
set(handles.popupmenu10,'String',vars)

function edit19_Callback(hObject, eventdata, handles)
NewStrVal19=get(hObject,'String');
edit19a=str2double(NewStrVal19);
handles.edit19=edit19a;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
Backg_Matrix=evalin('base','BCP.Background_Matrix');
Wavenumber=evalin('base','BCP.Wavenumber');
LCIR=evalin('base','BCP.LCIR');
Nr19=handles.edit19; % number of Background spectrum 
Sr=size(LCIR,1); % Number of spectra in LCIR
for i=1:Sr; % Subtraction of the reference spectra
         SSM_Isoc(i,:)=LCIR(i,:)-Backg_Matrix(Nr19,:);
end
handles.pushbutton12=SSM_Isoc;
guidata(hObject,handles);
checkLabels={'Save the obtained background corrected matrix'};
varNames={'R_Iso'};
items={handles.pushbutton12};
export2wsdlg(checkLabels,varNames,items,'Save corrected LC-IR matrix: ');

% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
popmenu10=get(handles.popupmenu10,'String');
pm10=get(handles.popupmenu10,'Value');
if pm10==1
else
    selec10=char([popmenu10(pm10)]);
    Background_Matrix=evalin('base',selec10);
    assignin('base','Background_Matrix',Background_Matrix);
    evalin('base','BCP.Background_Matrix=Background_Matrix;');
    set(handles.popupmenu10,'enable','on')
end

% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
lsvar=evalin('base','whos');
[rr,cc]=size(lsvar);
j=2;
lsv(1)={'Background Matrix'};
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


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function Untitled_12_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function showRSM_Callback(hObject, eventdata, handles)
showRSM
% --------------------------------------------------------------------
function showSM_Callback(hObject, eventdata, handles)
showSM
% --------------------------------------------------------------------
function showAR_Callback(hObject, eventdata, handles)
showARplot
% --------------------------------------------------------------------
function PLSSelTool_Callback(hObject, eventdata, handles)
PLSSelectionTool
% --------------------------------------------------------------------
function ARSelection_Callback(hObject, eventdata, handles)
ARSelection
% --------------------------------------------------------------------
function SW_SelTool_Callback(hObject, eventdata, handles)
SWSelectionTool
% --------------------------------------------------------------------
function p2p_SelTool_Callback(hObject, eventdata, handles)
p2pSelection
% --------------------------------------------------------------------
function loading_tool_Callback(hObject, eventdata, handles)
loading_tool
% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
Export2OPUS
% --------------------------------------------------------------------
function PrePostTreat_Callback(hObject, eventdata, handles)
PrePostTreat
% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
ChromNoise
% --------------------------------------------------------------------
function Untitled_13_Callback(hObject, eventdata, handles)
WnCol

