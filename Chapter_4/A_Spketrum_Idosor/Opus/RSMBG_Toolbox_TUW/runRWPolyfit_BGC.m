RSMmat=evalin('base','BCP.RSM_Matrix');
Wavenumber=evalin('base','BCP.Wavenumber');
SMmat=evalin('base','BCP.LCIR');
w1=handles.edit9; %Wn1 (cm-1)
w2=handles.edit10; %Wn2 (cm-1) (w2==0 indicates SW-Polyfit)
wnkf=handles.edit11; %KF (KF==0 indicated NO KF)
imprf=handles.edit13; % Improvement factor for Polyfit
maxord=handles.edit14; % Max. order of the polynomial functions
%Mr=size(RSMmat,1); % Number of spectra included in the Reference
[Sr,c]=size(SMmat); % Number of spectra in SMmat
[r,c]=size(RSMmat); % Number of spectra in RSMmat
[d1,c1]=min(abs(w1-Wavenumber)); % Column Wn1
[d2,c2]=min(abs(w2-Wavenumber)); % Column Wn2
[d17,ckf]=min(abs(wnkf-Wavenumber)); % Column KF 
cSMmat=ones(Sr,c);
Xref=RSMmat(:,c1)-RSMmat(:,c2);

disp ('Step 1...')
for op=1:maxord; % Calc. of the polynomial fittings
    for j=1:c;
        Order(op).MPC(j,:)=polyfit(Xref,RSMmat(:,j),op);
    end
end

disp ('Step 2...')
for op=1:maxord; % Calc. of the theoretical bacg.matrices of RSM unsing dif. pol. orders
    OrdSel(op).CBKG=ones(r,c);
    for i=1:r;
        for j=1:c;
              OrdSel(op).CBKG(i,j)=polyval(Order(op).MPC(j,:),RSMmat(i,c1)-RSMmat(i,c2));  
        end
    end
end


disp ('Step 3...')
for op=1:maxord; % Calculation of the residuals
    OrdSel(op).ResRSM=(RSMmat-OrdSel(op).CBKG);
end

disp ('Step 4...')
adcfmat=ones(maxord,c);
for op=1:maxord; % Calc of the degress of freedom adj. R2 values
    for j=1:c;
        cef=OrdSel(op).ResRSM(:,j);
        Xvalt=RSMmat(:,j);
        adcfmat(op,j)=1-((r-1)/(r-op))*(sum(cef.^2)/sum((Xvalt-mean(Xvalt)).^2));
    end
end

disp ('Step 5...')
ordopt=ones(c,1);
for j=1:c; % Selection of the opt. order for each variable
    for i=1:(maxord-1);
        if adcfmat(i,j)>=adcfmat(i+1,j)*imprf;
            ordopt(j,1)=i;
            break
        else ordopt(j,1)=op;
        end
    end
end

disp ('Step 6...')
cSM=ones(Sr,c);
for i=1:Sr
    for j=1:c
            cSM(i,j)=polyval(Order(1,(ordopt(j,1))).MPC(j,:),SMmat(i,c1)-SMmat(i,c2)); 
    end
end

 cSMmat=SMmat-cSM;
 
handles.pushbutton8=cSMmat;
handles.pushbutton8=cSMmat;
guidata(hObject,handles);
checkLabels={'Save the obtained background corrected matrix'};
varNames={'BGC_Matrix'};
items={handles.pushbutton8};
export2wsdlg(checkLabels,varNames,items,'Save corrected matrix using Polyfit-RSM: ');       