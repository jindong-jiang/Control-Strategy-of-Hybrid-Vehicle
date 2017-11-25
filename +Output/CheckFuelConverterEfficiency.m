figure(2);
Fuel_Converter_Efficiency=figure(2);
set(Fuel_Converter_Efficiency,'name','Fuel Converter Efficiency','Numbertitle','off')
set(Fuel_Converter_Efficiency,'Position',[522 80 765 598])
dt=t(length(t))-t(length(t)-1);
fc_out_W=fc_brake_trq.*fc_spd_est;
galps=diff(gal);
fc_in_W=[galps;galps(length(galps))]./dt*3.785*fc_fuel_lhv*fc_fuel_den;
fc_eta=(fc_out_W./(eps+fc_in_W)).*(fc_in_W>eps).*(fc_out_W>0);
plot(t,fc_eta,'x')
xlabel('time (s)')
ylabel('efficiency')
