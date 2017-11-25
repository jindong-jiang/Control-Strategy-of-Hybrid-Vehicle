Motor_Controller_Efficiency=figure(4);
dt=t(length(t))-t(length(t)-1);
fc_out_W=fc_brake_trq.*fc_spd_est;
galps=diff(gal);
fc_in_W=[galps;galps(length(galps))]./dt*3.785*fc_fuel_lhv*fc_fuel_den;
fc_eta=(fc_out_W./(eps+fc_in_W)).*(fc_in_W>eps).*(fc_out_W>0);
plot(t,fc_eta,'x')
xlabel('time (s)')
ylabel('efficiency')

mc_out_W=mc_ni_trq_out_a.*mc_spd_est.*(mc_ni_trq_out_a>0);
mc_in_W=mc_pwr_in_a.*(mc_pwr_in_a>0);
mc_eta=(mc_out_W./(eps+mc_in_W)).*(mc_in_W>eps).*(mc_out_W>0);

plot(t,mc_eta,'x')
xlabel('time (s)')
ylabel('efficiency')

set(Motor_Controller_Efficiency,'name','Motor/Controller Efficiency','Numbertitle','off')
set(Motor_Controller_Efficiency,'Position',[522 80 765 598])