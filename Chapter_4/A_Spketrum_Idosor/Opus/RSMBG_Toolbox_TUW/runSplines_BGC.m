RSMmat=evalin('base','BCP.RSM_Matrix');
Wavenumber=evalin('base','BCP.Wavenumber');
SMmat=evalin('base','BCP.LCIR');
w1=handles.edit9; %Wn1 (cm-1)
w2=handles.edit10; %Wn2 (cm-1)
wnkf=handles.edit11; %KF (KF==0 indicated NO KF)
Mr=size(RSMmat,1); % Number of spectra included in the Reference
[Sr,c]=size(SMmat); % Number of spectra in LCIR
[d1,c1]=min(abs(w1-Wavenumber)); % Column Wn1
[d2,c2]=min(abs(w2-Wavenumber)); % Column Wn2
[d17,ckf]=min(abs(wnkf-Wavenumber)); % Column KF 


Reference=evalin('base','BCP.RSM_Matrix');
Wavenumber=evalin('base','BCP.Wavenumber');
LCIR=evalin('base','BCP.LCIR');
w1=handles.edit18; % A1 (cm-1)
w2=handles.edit19; % A2 (cm-1)
sf=handles.edit20; % Smoothing factor
[r,c]=size(Reference);
[z,c]=size(LCIR);
[Difference1,c1]=min(abs(w1-Wavenumber)); % Column A1
[Difference2,c2]=min(abs(w2-Wavenumber)); % Column A2
OrderSpect=handles.popupmenu4;
Spline_RSM=handles.popupmenu15;
% Selection of the Spline-RSM method
if (Spline_RSM==1); % SW-Spline-RSM
    X_RefVal=Reference(:,c1);
    x=X_RefVal;
    xx=LCIR(:,c1);
   for i=1:c; % For each wavenumber, calc of the splines
    y=Reference(:,i);
    epsilon=(abs((x(end)-x(1)))/(numel(x)-1))^3/16; % Calc. of the 'magic number'
    p=1/(1+(sf*epsilon)); % sf=Smoothing factor (0.01<sf<100)
    [cBKG(:,i),pk]=csaps(x,y,p,xx);
    pR=1-p;
   end
   BKGcSM=LCIR-cBKG;
    
else % AR-Spline-RSM
    X_RefVal=Reference(:,c1)./Reference(:,c2);
    x=X_RefVal;
    xx=LCIR(:,c1)./LCIR(:,c2);
   for i=1:c; % For each wavenumber, calc of the splines
    y=Reference(:,i);
    epsilon=(abs((x(end)-x(1)))/(numel(x)-1))^3/16; % Calc. of the 'magic number'
    p=1/(1+(sf*epsilon)); % sf=Smoothing factor (0.01<sf<100)
    [cBKG(:,i),pk]=csaps(x,y,p,xx);
    pR=1-p;
   end
   BKGcSM=LCIR-cBKG;
end
%end

handles.pushbutton27=BKGcSM;
guidata(hObject,handles);
checkLabels={'Save the obtained background corrected matrix'};
varNames={'R_Spline_RSM'};
items={handles.pushbutton27};
export2wsdlg(checkLabels,varNames,items,'Save corrected FTIR matrix using Splines-RSM: ');

vars = evalin('base','who');
set(handles.popupmenu1,'String',vars)
set(handles.popupmenu2,'String',vars)
set(handles.popupmenu3,'String',vars)
set(handles.popupmenu7,'String',vars)
set(handles.popupmenu8,'String',vars)




% selection of the method
UBC_RSM_met=handles.popupmenu15;
if UBC_RSM_met==2 % AR
    VRef=RSMmat(:,c1)./RSMmat(:,c2); % Wn1/Wn2 ratio for the RSM-spectra 
    SMarref=SMmat(:,c1)./SMmat(:,c2); % Wn1/Wn2 ratio for the SM-spectra  
elseif UBC_RSM_met==3 % RW
    VRef=RSMmat(:,c1)-RSMmat(:,c2); % Wn1-Wn2 for the RSM-spectra 
    SMarref=SMmat(:,c1)-SMmat(:,c2); % Wn1-Wn2 for the SM-spectra 
elseif UBC_RSM_met==4 % SW
    VRef=RSMmat(:,c1); % Wn1 abs values for the RSM-spectra 
    SMarref=SMmat(:,c1); % Wn1 abs values for the SM-spectra 
end 


cSMmat=ones(Sr,c);
for p=1:Sr
   [dx,pp]=min(abs(SMarref(p,1)-VRef(p,1)));
   if wnkf==0 %No KF
       cSMmat(p,:)=SMmat(p,:)-(RSMmat(pp,:));
   else  
        KF=SMmat(p,ckf)/RSMmat(pp,ckf);
        cSMmat(p,:)=SMmat(p,:)-KF.*(RSMmat(pp,:));
   end
end

handles.pushbutton8=cSMmat;
guidata(hObject,handles);
checkLabels={'Save the obtained background corrected matrix'};
varNames={'BGC_Matrix'};
items={handles.pushbutton8};
export2wsdlg(checkLabels,varNames,items,'Save corrected matrix: ');
