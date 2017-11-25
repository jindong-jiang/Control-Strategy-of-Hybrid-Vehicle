
gb_pwr_in_a=gb_trq_in_a.*gb_spd_in_a;
gb_pwr_out_a=gb_ni_trq_out_a.*gb_spd_out_a;
gb_eta=(gb_pwr_out_a./(eps+gb_pwr_in_a)).*(gb_trq_in_r>0).*(gb_ni_trq_out_a>0);
plot(t,gb_eta,'x')
xlabel('time (s)')
ylabel('efficiency')
% title('Gearbox Efficiency (driving only, not regen)')
set(gcf,'NumberTitle','off','Name','Drivetrain Efficiency')
set(gcf,'Position',[522 80 765 598])