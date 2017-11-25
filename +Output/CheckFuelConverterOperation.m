clc
%%
figure(1)
str=[];
Fuel_Converter_Operation=figure(1);
set(Fuel_Converter_Operation,'name','Fuel Converter Operation','Numbertitle','off')
% set(Fuel_Converter_Operation,'Position',[553 295 732 530])
set(Fuel_Converter_Operation,'Position',[522 80 765 598])
% get(Fuel_Converter_Operation,'Position')
% not a fuel cell vehicle
   
   %plot max torque envelope
   if exist('fc_max_trq')
      plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'k-');
      str=[str,'''max torque curve'''];
   end;
   hold

   % overlay efficiency contour map
   if nnz(fc_map_trq<eps)
      trq=[];
      for x=1:length(fc_map_trq)
         if fc_map_trq(x)>0
            trq=[trq fc_map_trq(x)];
         end;
      end;
   else 
      trq=fc_map_trq;
   end;
   if nnz(fc_map_spd<eps)
      spd=[];
      for x=1:length(fc_map_spd)
         if fc_map_spd(x)>0
            spd=[spd fc_map_spd(x)];
         end;
      end;
   else
      spd=fc_map_spd;
   end;
   
   % create efficiency map
   diff_trq=length(fc_map_trq)-length(trq);
   diff_spd=length(fc_map_spd)-length(spd);
   [T,w]=meshgrid(trq,spd);
   fc_map_kW=T.*w/1000;
   fc_eff_map=fc_map_kW*1000./(fc_fuel_map(diff_spd+1:length(fc_map_spd),...
      diff_trq+1:length(fc_map_trq))*fc_fuel_lhv);
   
   % plot efficiency map
   % determine the best brake thermal efficiency within the allowable operating range
   good_trqs=[];
   for i=1:length(spd)
      good_trqs=[good_trqs; T(i,:)<=fc_max_trq(i+diff_spd)];
   end
   fc_map_eff_good=fc_eff_map.*good_trqs;
   fc_bte=max(max(fc_map_eff_good));
   temp=fc_bte*100;
   levels=[temp-16 temp-12 temp-8 temp-4 temp-2 temp-1];
   c=contour(spd*30/pi*fc_spd_scale,trq*fc_trq_scale,fc_eff_map'*100,levels);
   clabel(c)
   
if exist('fc_trq_out_a')
    x1=plot(fc_spd_est*30/pi,fc_trq_out_a,'rx');  % fc_trq_out_a includes inertia effects
    str=[str,',''output shaft'''];
end;

if exist('fc_brake_trq')
    x2=plot(fc_spd_est*30/pi,fc_brake_trq,'g^');  % fc_brake_trq does not include inertia effects
    str=[str,',''op. pts(includes inertia & accessories)'''];
end;

if exist('fc_max_trq')
    x3=plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'k-');
    str=[str,'''max torque curve'''];
end;

legend([x1,x2,x3],'output shaft','op. pts','max torque curve',4)
xlabel('Speed (rpm)');
ylabel('Torque (Nm)');



%12/31/98: tm added plot parallel  control strategy section
%1/20/99:ss changed ylabel to Torque(Nm) was Brake Torque(Nm) [not including inertia]
%8/17/99: ss added axis limits to keep it above 0 speed
% 8/26/99 ss: added design curve for Prius
% 9/7/99 tm: updated linetypes for b&w printing
% 10/1/99 mc changed to use fc_spd_est instead of fc_spd_out_a for plotting
% 10/25/99:tm added lines to plot new parallel control strategy if it exists
%	5/10/00:tm added lines to plot cvt design curve if it exists
% 4/10/02: kh added fuel cell model option #4, lines 12 & 13
% 4/26/02:tm updated fc_pwr in calc for fuel cells to be based on fuel rate not gal
%4/29/02:tm added code to plot polarization curve and efficiency curve for polarization model
