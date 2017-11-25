% use to check motor operation

Motor_Controller_Operation = figure(3);
set(Motor_Controller_Operation,'name','Motor Controller Operation','Numbertitle','off')
set(Motor_Controller_Operation,'Position',[522 80 765 598])

hold;
str=[];
if exist('mc_max_trq')
   plot(mc_map_spd*30/pi*mc_spd_scale,mc_max_trq*mc_trq_scale,'kx-');
   plot(mc_map_spd*mc_spd_scale*30/pi,mc_max_trq*mc_trq_scale*mc_overtrq_factor,'bx--')
   str=['''max cont. motoring torque'', ''max motoring torque'','];
end
if exist('mc_max_gen_trq')
   plot(mc_map_spd*mc_spd_scale*30/pi,mc_max_gen_trq*mc_trq_scale,'ko-')
   plot(mc_map_spd*mc_spd_scale*30/pi,mc_max_gen_trq*mc_trq_scale*mc_overtrq_factor,'bo-')
   str=[str,'''max cont. gen. torque'', ''max gen. torque'','];
else
   plot(mc_map_spd*mc_spd_scale*30/pi,-mc_max_trq*mc_trq_scale,'ko-')
   plot(mc_map_spd*mc_spd_scale*30/pi,-mc_max_trq*mc_trq_scale*mc_overtrq_factor,'bo-')
   str=[str,'''max cont. gen. torque'', ''max gen. torque'','];
end
if exist('mc_spd_est')
   plot(mc_spd_est*30/pi,mc_ni_trq_out_a,'rx');
   str=[str,'''actual operating points'','];
end
eval(['legend(',str,'4)'])
levels=[60 65 70 75 80 85 90 95]/100;
c=contour(mc_map_spd*30/pi*mc_spd_scale,mc_map_trq*mc_trq_scale,mc_eff_map',levels);
clabel(c);
xlabel('Speed (rpm)');
ylabel('Torque (Nm)');
% 
% if length(['Motor/Controller Operation - ',mc_description])<75
%    title(['Motor/Controller Operation - ',mc_description]);
% elseif length(mc_description)<75
%    ttl={'Motor/Controller Operation';mc_description};
%    title(ttl,'Fontsize',7);
% else
%    ttl_str=['Motor/Controller Operation - ',mc_description];
%    space_index=findstr(ttl_str,' ');   
%    cut_index=max(find(space_index<=75));
%    ttl={ttl_str(1:space_index(cut_index));ttl_str(space_index(cut_index)+1:end)};
%    title(ttl,'Fontsize',7);
% end
% set(gcf,'NumberTitle','off','Name','Motor/Controller Operation')

% 10/1/99 mc changed to use mc_spd_est instead of mc_spd_out_a
% 10/7/99 mc changed to use mc_ni_trq_out_a instead of mc_trq_out_a
% 9/10/00:tm added the capability to plot max gen trq curve data if it exists
