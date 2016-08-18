RSMmat=evalin('base','BCP.RSM_Matrix');
Wavenumber=evalin('base','BCP.Wavenumber');
SMmat=evalin('base','BCP.LCIR');
wnkf=handles.edit16; %KF (KF==0 indicated NO KF)
Mr=size(RSMmat,1); % Number of spectra included in the Reference
[Sr,c]=size(SMmat); % Number of spectra in SMmat
[r,c]=size(RSMmat); % Number of spectra in RSMmat
[d16,ckf]=min(abs(wnkf-Wavenumber)); % Column KF 
variables=handles.edit15;
kf=handles.popupmenu9;
simindx=handles.popupmenu8;

Mr=size(RSMmat,1); % Number of spectra included in the Reference
Sr=size(SMmat,1); % Number of spectra in LCIR
for i=1:Sr % For every spectra included in the SM SampleM  
    A=SMmat(i,variables);
    mA=A-mean(A);
    enmA=sqrt(mA*mA');
    for j=1:Mr % to compare every sample spèctrum with every RSM spectrum
        B=RSMmat(j,variables);
        if simindx==2; %'cor' Similarity indice = COR
            mB=B-mean(B);
            enmB=sqrt(mB*mB');
            r=(mB*mA')/(enmA*enmB);
            SimIndex(1,j)=999*(r+1)/2;
        elseif simindx==3; %'dpn'; % Similarity indice = DPN
            enA=sqrt(A*A');
            enB=sqrt(B*B');
            SimIndex(1,j)=999*(B*A')/(enA*enB);
        elseif simindx==4; %'rmsd'; % Similarity indice = RMSE root mean square error (difference)
            r=sqrt(mean(A-B).^2);
            SimIndex(1,j)=999*(1-r);
        elseif simindx==5; %'mse'; % Similarity indice = mean square error
            r=(mean(A-B).^2);
            SimIndex(1,j)=999*(1-r);
        elseif simindx==6; %'mae'; % Similarity indice = Maximum absolute error 
            SimIndex(1,j)=-max(A-B); % Data not autoscaled. ** The - sign is to find the maximum **
        elseif simindx==7; %'mare'; % Similarity indice = Mean absolute relative error 
            d=abs(A-B);
            SimIndex(1,j)=-max(abs(d./A)); % Data not autoscaled. ** The - sign is to find the maximum **
        elseif simindx==8; %'mad'; % Similarity indice = MAD
            m=mean(abs(A-B)); % Short-way
            SimIndex(1,j)=999*(1-m);
        elseif simindx==9; %'md'; % Similarity indice = MD
            mD = sum(abs(A-B));
            SimIndex(1,j)=999*(1-mD);
        end
    end 
  [Y,I] = max(SimIndex(1,:));%For every spectrum locate the RSM spectrum with the highest SimIndex
  SelectedRef(i,1)=I; % Position
end    
% Type of Correction Factor
if kf==2 % Type of Correction Factor
   CorrFact=ones(Sr,1);
elseif kf==3
        for i=1:Sr
           A=SMmat(i,variables);
           mA=A-mean(A);
           enmA=sqrt(mA*mA');
           B=RSMmat(SelectedRef(i,1),variables);
           mB=B-mean(B);
           enmB=sqrt(mB*mB');
           CorrFact(i,1)=enmA/enmB;
        end
else
   wnkf=handles.edit16;
   [a,ckf]=min(abs(wnkf-Wavenumber));
        for i=1:Sr
           CorrFact(i,1)=SMmat(i,ckf)/RSMmat(SelectedRef(i,1),ckf);
        end
end
for i=1:Sr; % Background correction of the SM matrix
    cSMmat(i,:)=SMmat(i,:)-CorrFact(i,1)*RSMmat(SelectedRef(i,1),:);    
end

handles.pushbutton11=cSMmat;
guidata(hObject,handles);
checkLabels={'Save the obtained background corrected matrix'};
varNames={'BGC_Matrix'};
items={handles.pushbutton11};
export2wsdlg(checkLabels,varNames,items,'Save corrected matrix using p2p-RSM: ');       