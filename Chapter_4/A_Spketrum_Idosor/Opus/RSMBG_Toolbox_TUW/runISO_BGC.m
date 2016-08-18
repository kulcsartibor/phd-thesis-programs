BKGmat=evalin('base','BCP.BKGmat');
SMmat=evalin('base','BCP.LCIR');
n5=handles.edit5; % number of Background spectrum 
[Sr,c]=size(SMmat); % Number of spectra in LCIR
SMmat=ones(Sr,c);
for p=1:Sr; % Subtraction of the reference spectra
     cSMmat(p,:)=SMmat(p,:)-BKGmat(n5,:);
end
handles.pushbutton2=cSMmat;
guidata(hObject,handles);
checkLabels={'Save the obtained background corrected matrix'};
varNames={'R_Iso'};
items={handles.pushbutton2};
export2wsdlg(checkLabels,varNames,items,'Save corrected LC-IR matrix: ');