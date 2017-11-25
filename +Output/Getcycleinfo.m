function [cyc_info]=Getcycleinfo(x,y,z)
%
% This function is designed to provide some general information about 
% an ADVISOR drive cycle for comparison with other cycles
%
% format: [cyc_info]=rate_cycle(cyc_name, option)
%
% cyc_name - the filename of the drive cycle to be analyzed
% option   - 1==> mixed units, 2==> SI units
% cyc_info - a structure containing the following fields
%  			 cyc_name - drive cycle filename
%  			 cyc_descrip - drive cycle description
%  			 max_spd - maximum speed (mph)/(km/h)
%  			 avg_spd - average speed (mph)/(km/h)
%  			 max_accel - maximum acceleration rate (miles/hr^2)/(m/s^2)
%  			 max_decel - maximum deceleration rate (miles/hr^2)/(m/s^2)
%  			 num_stops - number of complete stops
%  			 distance - distance covered by the cycle (miles)/(km)
%  			 time - elapse time of the cycle
%  			 idle time - sum of idle time during the cycle
% 
   %load CYC_UDDS.mat   
   len = length(x);
   i=1;
   for i=1:len
       cyc_mph(i,1) = x(i);
   end
   
   k=1;
   for k=1:len
       cyc_mph(k,2) = y(k);
   end
   
    l=1;
   for l=1:len
       vc_key_on(l,1) = x(l);
   end
   
   for m=1:len
       vc_key_on(m,2) = z(m);
   end
   
   option=1; %1表示Km/h  2表示mph
   % convert to true second-by-second data
   time_data=[ceil(min(cyc_mph(:,1))):floor(max(cyc_mph(:,1)))];
%    dist_data=[ceil(min(cyc_grade(:,1))):floor(max(cyc_grade(:,1)))];
   mph_data=interp1(cyc_mph(:,1)+([0; diff(cyc_mph(:,1))<=0]*eps*max(cyc_mph(:,1))),cyc_mph(:,2),time_data);
   vc_key_on_data=interp1(vc_key_on(:,1)+([0; diff(vc_key_on(:,1))<=0]*eps*max(vc_key_on(:,1))),vc_key_on(:,2),time_data);
%    grade_data=interp1(cyc_grade(:,1)+([0; diff(cyc_grade(:,1))<=0]*eps*max(cyc_grade(:,1))),cyc_grade(:,2),dist_data);
   
   % calculate and assign specs
%    cyc_info.cyc_name=cyc_name;
%    cyc_info.description=cyc_description;
   cyc_info.max_spd=max(mph_data);
   cyc_info.avg_spd=mean(mph_data);
   cyc_info.max_accel=max(diff(mph_data)./diff(time_data))/3.6;%5280/3600;
   cyc_info.max_decel=min(diff(mph_data)./diff(time_data))/3.6;
   cyc_info.avg_accel=sum(diff(mph_data)./diff(time_data).*(diff(mph_data)>0))/(sum(diff(mph_data)>0)+eps)/3.6;
   cyc_info.avg_decel=sum(diff(mph_data)./diff(time_data).*(diff(mph_data)<0))/(sum(diff(mph_data)<0)+eps)/3.6;
   cyc_info.time=max(time_data);
   cyc_info.idle_time=sum((mph_data<eps)&(vc_key_on_data>eps));
   cyc_info.distance=trapz(time_data,mph_data/3600);
   cyc_info.num_stops=length(find((mph_data(2:end)==0)&(mph_data(1:end-1)~=0)));
%    cyc_info.max_up_grade=max(grade_data.*(grade_data>=0));
%    cyc_info.avg_up_grade=(sum(grade_data.*(grade_data>=0)))/(sum(grade_data>=0));
%    cyc_info.max_dn_grade=-1*min(grade_data.*(grade_data<=0));
%    cyc_info.avg_dn_grade=-1*(sum(grade_data.*(grade_data<=0)))/(sum(grade_data<=0));
   if option==2
      [N,X]=hist(mph_data*1.609,[5:10:135]);
   else
      %[N,X]=hist(mph_data,[2.5:5:82.5]);
      [N,X]=hist(mph_data,[5:10:115]);
   end
   cyc_info.spd_range=X;
   cyc_info.dist_percent=N/sum(N)*100;
   
   if option==2
      % convert to SI units
      cyc_info.max_spd =cyc_info.max_spd*1.609; % mph to km/h
      cyc_info.avg_spd=cyc_info.avg_spd*1.609; % mph to km/h
      cyc_info.max_accel=cyc_info.max_accel*0.305; % ft/s^2 to m/s^2
      cyc_info.max_decel=cyc_info.max_decel*0.305; % ft/s^2 to m/s^2
      cyc_info.distance=cyc_info.distance*1.609; % miles to km
      cyc_info.avg_decel = cyc_info.avg_decel*0.305; % ft/s^2 to m/s^2
      cyc_info.avg_accel = cyc_info.avg_decel*0.305; % ft/s^2 to m/s^2
   end
   
   
   cyc_info.max_spd =roundn(cyc_info.max_spd,-4);
   cyc_info.avg_spd =roundn(cyc_info.avg_spd,-4);
   cyc_info.max_accel =roundn(cyc_info.max_accel,-4);
   cyc_info.max_decel =roundn(cyc_info.max_decel,-4);
   cyc_info.distance =roundn(cyc_info.distance,-4);
   cyc_info.avg_decel =roundn(cyc_info.avg_decel,-4);
   cyc_info.avg_accel =roundn(cyc_info.avg_accel,-4);
   
   %% figure plot
%    figure(1)
%    plot(time_data,mph_data*1.609);
%    grid on;
%    ylabel('Speed (km/h)');
   
   % this section to be handled by gui when using the gui
   %try 
   %   if evalin('base','vinf.run_without_gui')==1
   %      figure
   %      set(gcf,'NumberTitle','off','Name',[upper(cyc_name), ' - ', cyc_description])
   %      subplot(2,1,1)
   %      if option==2
   %         plot(time_data,mph_data*1.609)
   %         ylabel('Speed (km/h)')
   %      else
   %         plot(time_data,mph_data)
   %         ylabel('Speed (mph)')
   %      end
   %      xlabel('Time (s)')
   %      
   %      subplot(2,1,2)
   %      h=bar(cyc_info.spd_range,cyc_info.dist_percent);
   %      if option==2
   %         xlabel('Speed (km/h)')
   %      else
   %        xlabel('Speed (mph)')
   %     end
   %      ylabel('Percentage (%)')
   %   end
      
   %end
   
end


% revision history
% 7/13/00:tm added statements to generate true second-by-second cycle data and update all calcs to use this data
% 7/13/00:tm added statement to calculate maximum and average grade
% 7/13/00:tm revised statements to calculate maximum and average grade to separate into uphill and downhill
%01/26/01: vhj eliminated div. by zero warning for cyc_info.avg_accel and cyc_info.avg_decel (on constant cycle)
% 7/6/01:tm updated help text for max and average speeds units in km/h not
% m/s