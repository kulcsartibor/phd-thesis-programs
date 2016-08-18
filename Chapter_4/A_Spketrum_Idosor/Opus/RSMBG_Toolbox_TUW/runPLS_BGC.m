RSMmat=evalin('base','BCP.RSM_Matrix');
Wavenumber=evalin('base','BCP.Wavenumber');
SMmat=evalin('base','BCP.LCIR');
w1=handles.edit1; %Reference wavenumber (cm-1)
w2=handles.edit2; %Begin PLS Range (cm-1)
w3=handles.edit3; %End PLS Range (cm-1)
n4=handles.edit4; %Number of PLS factors
wnkf=handles.edit17; %KF (KF==0 indicated NO KF)
Mr=size(RSMmat,1); % Number of spectra included in the Reference
Sr=size(SMmat,1); % Number of spectra in LCIR
[d1,c1]=min(abs(w1-Wavenumber)); % Column Reference wavenumber
[d2,c2]=min(abs(w2-Wavenumber)); % Column Begin PLS Range
[d3,c3]=min(abs(w3-Wavenumber)); % Column End PLS Range
[d17,ckf]=min(abs(wnkf-Wavenumber)); % Column End PLS Range
VRef=RSMmat(:,c1); %Reference values for the PLS model
[SMplspred]=plspred(RSMmat(:,c2:c3),VRef,SMmat(:,c2:c3),0,n4); % Predicted abs @ ref. Wn
for p=1:Sr %find optimum for each SM spectrum and subtraction
    [dx,pp]=min(abs(VRef-SMplspred(p,1)));
    if wnkf==0
       cSMmat(p,:)=SMmat(p,:)-(RSMmat(pp,:));
    else  
        KF=SMmat(p,ckf)/RSMmat(pp,ckf);
        cSMmat(p,:)=SMmat(p,:)-KF.*(RSMmat(pp,:));
    end
end

handles.pushbutton1=cSMmat;
guidata(hObject,handles);
checkLabels={'Save the obtained background corrected matrix'};
varNames={'Result_PLSCM'};
items={handles.pushbutton1};
export2wsdlg(checkLabels,varNames,items,'Save corrected FTIR matrix using PLS: ');
