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
% selection of the method
UBC_RSM_met=handles.popupmenu4;
if  UBC_RSM_met==2 % SW
    VRef=RSMmat(:,c1); % Wn1 abs values for the RSM-spectra 
    SMarref=SMmat(:,c1); % Wn1 abs values for the SM-spectra 
elseif UBC_RSM_met==3 % RW
    VRef=RSMmat(:,c1)-RSMmat(:,c2); % Wn1-Wn2 for the RSM-spectra 
    SMarref=SMmat(:,c1)-SMmat(:,c2); % Wn1-Wn2 for the SM-spectra 
elseif UBC_RSM_met==4 % AR
    VRef=RSMmat(:,c1)./RSMmat(:,c2); % Wn1/Wn2 ratio for the RSM-spectra 
    SMarref=SMmat(:,c1)./SMmat(:,c2); % Wn1/Wn2 ratio for the SM-spectra 
end 


cSMmat=ones(Sr,c);
for p=1:Sr
   [dx,pp]=min(abs(SMarref(p,1)-VRef(:,1)));
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
