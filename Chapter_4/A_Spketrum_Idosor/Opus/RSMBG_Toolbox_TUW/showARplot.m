RSMmat=evalin('base','BCP.RSM_Matrix');
Wavenumber=evalin('base','BCP.Wavenumber');
SMmat=evalin('base','BCP.LCIR');
w1=handles.edit9; %Wn1 (cm-1)
w2=handles.edit10; %Wn2 (cm-1)
[d1,c1]=min(abs(w1-Wavenumber)); % Column Wn1
[d2,c2]=min(abs(w2-Wavenumber)); % Column Wn2

figure (8)
    plot (RSMmat(:,c1)./RSMmat(:,c2),'b-')
    hold on
    plot (SMmat(:,c1)./SMmat(:,c2),'r-');
    grid on;
    title (['AR values for the RSM and the sample matrix: AR=(',mat2str(w1),' / ',mat2str(w2), ')cm-1']);
    %set(gca,'XDir','reverse');
    legend ('AR values RSM','AR values SM');
    xlabel('Number of spectrum');
    ylabel('Absorbance');
    box('on');
    grid('on');
    axis tight
    hold off
