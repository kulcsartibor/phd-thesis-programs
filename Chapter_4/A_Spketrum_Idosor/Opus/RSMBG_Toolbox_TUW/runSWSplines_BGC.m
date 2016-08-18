RSMmat=evalin('base','BCP.RSM_Matrix');
Wavenumber=evalin('base','BCP.Wavenumber');
SMmat=evalin('base','BCP.LCIR');
w1=handles.edit9; %Wn1 (cm-1)
w2=handles.edit10; %Wn2 (cm-1)
[d1,c1]=min(abs(w1-Wavenumber)); % Column Wn1
[d2,c2]=min(abs(w2-Wavenumber)); % Column Wn2
sf=handles.edit12; % Smoothing factor
[r,c]=size(RSMmat);
[z,c]=size(RSMmat);
X_RefVal=RSMmat(:,c1);
x=X_RefVal;
xx=SMmat(:,c1);
   for i=1:c; % For each wavenumber, calc of the splines
    y=RSMmat(:,i);
    epsilon=(abs((x(end)-x(1)))/(numel(x)-1))^3/16; % Calc. of the 'magic number'
    p=1/(1+(sf*epsilon)); % sf=Smoothing factor (0.01<sf<100)
    [cBKG(:,i),pk]=csaps(x,y,p,xx);
    pR=1-p;
   end
cSMmat=SMmat-cBKG;

handles.pushbutton8=cSMmat;
guidata(hObject,handles);
checkLabels={'Save the obtained background corrected matrix'};
varNames={'BGC_Matrix'};
items={handles.pushbutton8};
export2wsdlg(checkLabels,varNames,items,'Save corrected matrix: ');
