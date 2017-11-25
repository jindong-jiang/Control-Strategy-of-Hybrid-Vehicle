figure(2);
  %%%%%% ess efficiency --------------
  ess_charge_eta=(ess_pwr_out_a+ess_pwr_loss_a)./(ess_pwr_out_a-eps).*(ess_pwr_out_a<0);
   ess_discharge_eta=ess_pwr_out_a./(ess_pwr_out_a+ess_pwr_loss_a+eps).*(ess_pwr_out_a>0);
   
   %%%%%% DISPLAY S-BY-S DATA %%%%%%%%%%%%%

      %%%%% ESS -----------
      figure
      plot(t,ess_discharge_eta,'x')
      xlabel('time (s)')
      ylabel('efficiency')
      set(gcf,'NumberTitle','off','Name','Ess Discharge Efficiency')
      set(gcf,'Position',[522 80 765 598])
     
      figure
      plot(t,ess_charge_eta,'x')
      xlabel('time (s)')
      ylabel('efficiency')
      %title('Energy Storage System Efficiency (charging)')
      set(gcf,'NumberTitle','off','Name','Ess Charge Efficiency')
      set(gcf,'Position',[522 80 765 598])
 
  