function varargout = p2pSelection(varargin)
% P2PSELECTION M-file for p2pSelection.fig
%      P2PSELECTION, by itself, creates a new P2PSELECTION or raises the existing
%      singleton*.
%
%      H = P2PSELECTION returns the handle to a new P2PSELECTION or the handle to
%      the existing singleton*.
%
%      P2PSELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in P2PSELECTION.M with the given input arguments.
%
%      P2PSELECTION('Property','Value',...) creates a new P2PSELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before p2pSelection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to p2pSelection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help p2pSelection

% Last Modified by GUIDE v2.5 13-Jan-2009 14:01:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @p2pSelection_OpeningFcn, ...
                   'gui_OutputFcn',  @p2pSelection_OutputFcn, ...
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


% --- Executes just before p2pSelection is made visible.
function p2pSelection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to p2pSelection (see VARARGIN)

% Choose default command line output for p2pSelection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes p2pSelection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = p2pSelection_OutputFcn(hObject, eventdata, handles) 
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
NewStrVal1=get(hObject,'String');
edit1a=str2double(NewStrVal1);
handles.edit1=edit1a;
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
NewStrVal2=get(hObject,'String');
edit2a=str2double(NewStrVal2);
handles.edit2=edit2a;
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
NewStrVal3=get(hObject,'String');
edit3a=eval(NewStrVal3);
handles.edit3=edit3a;
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



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
NewStrVal5=get(hObject,'String');
edit5a=str2double(NewStrVal5);
handles.edit5=edit5a;
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RSMmat=evalin('base','BCP.RSM_Matrix'); % RSM matrix
Wavenumber=evalin('base','BCP.Wavenumber');
SMmat=evalin('base','BCP.LCIR'); % Blank matrix
windowsize=handles.edit5;
NoiseEv=handles.edit3;
simindx=handles.popupmenu1;
kf=handles.popupmenu2;
[Mr,WnN]=size(RSMmat); % Number of rows and columns included in the Reference
Sr=size(SMmat,1); % Number of spectra in LCIR
wn1=handles.edit1;
wn2=handles.edit2;
[d1,co1]=min(abs(wn1-Wavenumber)); % Column wn1. Start of the interval to be evaluated
[d2,co2]=min(abs(wn2-Wavenumber)); % Column wn2. End of the interval to evaluate
% c1 must be lower than c2 (c1:c2)
c1=min([co1 co2]);
c2=max([co1 co2]);
% Definition of the evaluation interval
iRSMmat=RSMmat(:,c1:c2);
iSMmat=SMmat(:,c1:c2);
iwn=Wavenumber(:,c1:c2);
N=size(iwn,2);

NEv=size(NoiseEv,2);
SimIndex=zeros(1,Mr); % Pre-allocating of SimIndex for speed
Solution=zeros(Sr,WnN); %Pre-allocating of Solution for speed
NoiseInterval=zeros(N,NEv+1); %Pre-allocating of NoiseInterval for speed

for intrval=1:N
    disp(intrval)
    if intrval<=(windowsize-1)/2;
        selectedwindow=1:(intrval+(windowsize-1)/2);
    elseif intrval>N-(windowsize-1)/2;
            selectedwindow=(intrval-(windowsize-1)/2):N;
    else
        selectedwindow=(intrval-(windowsize-1)/2):(intrval+(windowsize-1)/2);
    end
    sw_SampleM=iSMmat(:,selectedwindow);
    sw_RefMatrix=iRSMmat(:,selectedwindow);
  for i=1:Sr % For every spectra included in the SM SampleM  
    A=sw_SampleM(i,:);
    mA=A-mean(A);
    enmA=sqrt(mA*mA');
    for j=1:Mr % to compare every sample spèctrum with every RSM spectrum
        if simindx==2; %'cor';
            B=sw_RefMatrix(j,:); % Similarity indice = COR
            mB=B-mean(B);
            enmB=sqrt(mB*mB');
            r=(mB*mA')/(enmA*enmB);
            SimIndex(1,j)=999*(r+1)/2;
        elseif simindx==3; %'dpn'; % Similarity indice = DPN
            enA=sqrt(A*A');
            B=sw_RefMatrix(j,:);
            enB=sqrt(B*B');
            SimIndex(1,j)=999*(B*A')/(enA*enB);
        elseif simindx==4; %'rmsd'; % Similarity indice = RMSE
            B=sw_RefMatrix(j,:);
            r=sqrt(mean(A-B).^2);
            SimIndex(1,j)=999*(1-r);
        elseif simindx==5; %'mse'; % Similarity indice = MSE, mean std error
            B=sw_RefMatrix(j,:);
            r=(mean(A-B).^2);
            SimIndex(1,j)=999*(1-r);
        elseif simindx==6; %'mae'; % Similarity indice = Maximum absolute error 
            B=sw_RefMatrix(j,:);
            SimIndex(1,j)=-max(A-B); % Data not autoscaled. ** The - sign is to find the maximum **
        elseif simindx==7; %'mare'; % Similarity indice = MARE, mean abs relat error
            B=sw_RefMatrix(j,:);
            d=abs(A-B);
            SimIndex(1,j)=-max(abs(d./A)); % Data not autoscaled. ** The - sign is to find the maximum **
        elseif simindx==8; %'mad'; % Similarity indice = MAD
            B=sw_RefMatrix(j,:);
            k=windowsize;
            d=abs(A-B);
            m=sum(d)/k;
            SimIndex(1,j)=999*(1-m);
        elseif simindx==9; %'md'; % Similarity indice = MD
            B=sw_RefMatrix(j,:);
            mD = sum(abs(A-B));
            SimIndex(1,j)=999*(1-mD);
        end 
    [Y,I] = max(SimIndex(1,:));%For every spectra now we find the RSM spectrum with the lowest COR
    end
        SelectedRef(i,1)=I; % Position
  end
  
% Type of Correction Factor
        if kf==2 % Type of Correction Factor
            CorrFact=ones(Sr,1);
        elseif kf==3
            for i=1:Sr
                A=SMmat(i,selectedwindow);
                mA=A-mean(A);
                enmA=sqrt(mA*mA');
                B=RSMmat(SelectedRef(i,1),selectedwindow);
                mB=B-mean(B);
                enmB=sqrt(mB*mB');
                CorrFact(i,1)=enmA/enmB;
            end
        else
                wnkf=handles.edit6;
                [a,ckf]=min(abs(wnkf-Wavenumber));
                for i=1:Sr
                CorrFact(i,1)=SMmat(i,ckf)/RSMmat(SelectedRef(i,1),ckf);
                end
        end
 
for i=1:Sr; % Background correction of the SM matrix
    cSMmat(i,:)=SMmat(i,:)-CorrFact(i,1)*RSMmat(SelectedRef(i,1),:);    
end  
  NoiseInterval(intrval,1)=iwn(intrval);
  for z=2:NEv+1;
  NoiseInterval(intrval,z)=rmse(cSMmat(:,NoiseEv(1,z-1))); % %Noise measure in the corrected matrix
  end 
end
% PLOT
   RMmean=mean(SMmat);
    if min(RMmean)<0
        RMmean=RMmean+(-min(RMmean)); % To make all intensities positive
    end
%Results plot
LegendNames=zeros(size(NoiseEv,2),1); % Pre-allocating for speed.
for i=1:size(NoiseEv,2);
    LegendNames(i,1)=round(Wavenumber(NoiseEv(1,i)));
end
LegendNames=num2str(LegendNames);
figure('Name','Interval p2p selection results','NumberTitle','off')
plot (Wavenumber(1,c1:c2),NoiseInterval(:,2:end))
hold on
legend (LegendNames,'Location','NorthEastOutside');
actualaxis=axis;
plot(Wavenumber,RMmean./max(RMmean)*actualaxis(4),'-g') % Scaled spectrum
axis tight
ylabel('Chromatographic noise measured as RMSE')
xlabel('Wavenumber (cm-1)')
set(gca,'XDir','reverse');
title({'Point to point matching error using measured as RMSE using different intervals.';[' Interval width= ',num2str(windowsize),' points. Noise evaluated between ',num2str(wn1),' and ',num2str(wn2),' cm-1.']},'fontweight','bold','fontsize',8);
hold off
% end PLOT %
handles.pushbutton1=NoiseInterval;
guidata(hObject,handles);
checkLabels={'Results from the selection of the interval for p2p-BGC'};
varNames={'NoiseValues'};
items={handles.pushbutton1};
export2wsdlg(checkLabels,varNames,items,'Save obtained results: ');




% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
p2p_met=get(hObject,'Value');
handles.popupmenu1=p2p_met;
guidata(hObject,handles);

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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
p2pKF_met=get(hObject,'Value');
handles.popupmenu2=p2pKF_met;
guidata(hObject,handles);

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



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
NewStrVal6=get(hObject,'String');
edit6a=str2double(NewStrVal6);
handles.edit6=edit6a;
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


