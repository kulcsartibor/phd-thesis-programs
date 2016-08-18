valtozok={'Time [h]' 'C_2 (w%)' 'C_6 (w%)' 'H_2 (mol%)' 'slurry (g/cm^3)' 'T (^oC)' 'PE (t/h)' 'C_{6in} (kg/h)' 'C_2_{in} (t/h)' 'H_2_{in} (kg/h)' 'IB_{in} (t/h)' 'Kat_{in}'};
%valtozok={'idô (óra)' 'C_2' 'C_6' 'H_2' 'zagy' 'T_R' 'PE' 'C_{6be}' 'C_2_{be}' 'H_2_{be}' 'IB_{be}' 'Kat_{be}'};
set(0,'DefaultAxesFontName','times');
set(0,'DefaultTextFontName','times');
set(0,'DefaultAxesFontSize',10);
set(0,'DefaultTextFontSize',10);


figure(4)
  for j=2:6
      subplot(5,1,j-1);
      hold on
      plot(data(:,1),data(:,j),'linewidth',2)
      V=axis;
      axis([0 data(end,1) V(3) V(4)])
      ylabel(valtozok{j})
      grid on
      if j==size(valtozok,2)/2
          xlabel(valtozok{1})
      end
      b=axis;
        b=b(3:4);
    for j=1:size(seg{i},2)
       line([seg{i}(j).lx/240  seg{i}(j).lx/240], b);
    end

  end 

  
figure(5)
  for j=7:size(data,2)
      subplot(6,1,j-6);
      hold on
      plot(data(:,1),data(:,j),'linewidth',2)
      V=axis;
      axis([0 data(end,1) V(3) V(4)])
      ylabel(valtozok{j})
      grid on
      if j==size(data,2)
          xlabel(valtozok{1})
      end
        b=axis;
        b=b(3:4);
    for j=1:size(seg{i},2)
       line([seg{i}(j).lx/240  seg{i}(j).lx/240], b);
    end

  end 

