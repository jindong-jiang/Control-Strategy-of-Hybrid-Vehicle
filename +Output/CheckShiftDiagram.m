% subroutine to overlay shift diagrams, engine efficiency map, and engine operating points

if exist('fc_fuel_map')
   if ~exist('fc_spd_est')
      fc_spd_est=fc_spd_out_a;
   end
   str=[];
   ShifDiagram = figure(5);
   set(ShifDiagram,'name','Shift Diagram-Fuel Converter','Numbertitle','off')
   set(ShifDiagram,'Position',[522 80 765 598])
   % plot torque envelop
   plot(fc_map_spd*30/pi*fc_spd_scale,fc_max_trq*fc_trq_scale,'k-')
   str=[str,'''max torque curve'','];
   hold
   
   %plot actual data if it exists
   % color code the data for each gear
   line_type={'cx','mo','rd','g^','y+'};
   for i=1:length(gb_ratio)
      for x=1:length(fc_brake_trq)
         if gear_ratio(x)~=(gb_ratio(i))
            data(x)=nan;
         else
            data(x)=fc_brake_trq(x);
         end
      end
      plot(fc_spd_est*30/pi,data,line_type{rem(i-1,length(line_type))+1})  
      str=[str,'''operating points(gear ',num2str(i),')'','];
   end
   clear data
   
   %%%%%% plot downshift table
   if exist('gb_dnshift_spd')
      line_type={'y--','m--','r--','g--','c--'};
      %str=[];
      for i=2:length(gb_dnshift_spd)
         plot(gb_dnshift_spd{i}*30/pi, gb_dnshift_load{i}.*interp1(fc_map_spd*fc_spd_scale,fc_max_trq*fc_trq_scale,gb_dnshift_spd{i}),line_type{rem(i-1,length(line_type))+1})
         str=[str,'''downshift ',num2str(i),'->',num2str(i-1),''','];
      end
   end
   
   %%%%%% plot upshift table
   if exist('gb_upshift_spd')
      line_type={'y-.','m-.','r-.','g-.','c-.'};
      %str=[];
      for i=1:length(gb_upshift_spd)-1
         plot(gb_upshift_spd{i}*30/pi, gb_upshift_load{i}.*interp1(fc_map_spd*fc_spd_scale,fc_max_trq*fc_trq_scale,gb_upshift_spd{i}),line_type{rem(i-1,length(line_type))+1})
         str=[str,'''upshift ',num2str(i),'->',num2str(i+1),''','];
      end
   end
   
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
   
   if ~exist('fc_eff_map')
      % create efficiency map
      diff_trq=length(fc_map_trq)-length(trq);
      diff_spd=length(fc_map_spd)-length(spd);
      [T,w]=meshgrid(trq,spd);
      fc_map_kW=T.*w/1000;
      fc_eff_map=fc_map_kW*1000./(fc_fuel_map(diff_spd+1:length(fc_map_spd),...
         diff_trq+1:length(fc_map_trq))*fc_fuel_lhv);
   end;
   
   % plot efficiency map
   temp=floor(max(max(fc_eff_map*100)))-1;
   levels=[temp-16 temp-12 temp-8 temp-4 temp-2 temp];
   c=contour(spd*30/pi*fc_spd_scale,trq*fc_trq_scale,fc_eff_map'*100,levels);
   clabel(c)
   
   % add labels to the plot
   xlabel('Speed (rpm)')
   ylabel('Torque (Nm)')
   eval(['legend(',str,'4)']);
end;

% subroutine to overlay shift diagrams, motor efficiency map, and motor operating points
if 0%exist('mc_eff_map')
   if ~exist('mc_spd_est')
      mc_spd_est=mc_spd_out_a;
   end
   str=[];
   figure
   hold
   % plot torque envelop
   plot(mc_map_spd*30/pi*mc_spd_scale,mc_max_trq*mc_trq_scale*mc_overtrq_factor,'k-')
   plot(mc_map_spd*30/pi*mc_spd_scale,mc_max_trq*mc_trq_scale,'b--')
   str=[str,'''peak torque curve'','];
   str=[str,'''cont. torque curve'','];
   
   %plot actual data if it exists
   % color code the data for each gear
   line_type={'cx','mo','rd','g^','y+'};
   for i=1:length(gb_ratio)
      for x=1:length(mc_trq_out_a)
         if gear_ratio(x)~=(gb_ratio(i))
            data(x)=nan;
         else
            data(x)=mc_trq_out_a(x);
         end
      end
      plot(mc_spd_est*30/pi,data,line_type{rem(i-1,length(line_type))+1})  
      str=[str,'''operating points(gear ',num2str(i),')'','];
   end
   clear data
   
   %%%%%% plot downshift table
   if exist('gb_mc_dnshift_spd')
      line_type={'y--','m--','r--','g--','c--'};
      %str=[];
      for i=2:length(gb_mc_dnshift_spd)
         plot(gb_mc_dnshift_spd{i}*30/pi, gb_mc_dnshift_load{i}.*interp1(mc_map_spd*mc_spd_scale,mc_max_trq*mc_trq_scale*mc_overtrq_factor,gb_mc_dnshift_spd{i}),line_type{rem(i-1,length(line_type))+1})
         str=[str,'''downshift ',num2str(i),'->',num2str(i-1),''','];
      end
   end
   
   %%%%%% plot upshift table
   if exist('gb_mc_upshift_spd')
      line_type={'y-.','m-.','r-.','g-.','c-.'};
      %str=[];
      for i=1:length(gb_mc_upshift_spd)-1
         plot(gb_mc_upshift_spd{i}*30/pi, gb_mc_upshift_load{i}.*interp1(mc_map_spd*mc_spd_scale,mc_max_trq*mc_trq_scale*mc_overtrq_factor,gb_mc_upshift_spd{i}),line_type{rem(i-1,length(line_type))+1})
         str=[str,'''upshift ',num2str(i),'->',num2str(i+1),''','];
      end
   end
   
   % overlay efficiency contour map
   % plot efficiency map
   temp=floor(max(max(mc_eff_map*100)))-1;
   levels=[temp-16 temp-12 temp-8 temp-4 temp-2 temp];
   c=contour(mc_map_spd*30/pi*mc_spd_scale,mc_map_trq*mc_trq_scale,mc_eff_map'*100,levels);
   clabel(c)
   
   % add labels to the plot
   xlabel('Speed (rpm)')
   ylabel('Torque (Nm)')
   eval(['legend(',str,'4)']);  

end;

% 10/1/99 mc changed plots to use fc_spd_est instead of fc_spd_out_a
% 3/15/00 tm revised plotting such that operating points are displayed as color
%            coded symbols corresponding to each gear in the gearbox
% 4/4/00:tm removed *fd_ratio from logic statement to determine what gear the vehicle was in
% 4/24/00:tm replaced fc_trq_out_a with fc_brake_trq so that plots show actual 
% 				engine operating points rather than output shaft data
% 9/27/00:tm revised the upshift and dnshift line plots to include different line styles
% 9/27/00:tm removed references to old shift data formats
% 10/19/00:tm revised plot symbols : to -.
% 12/20/00:tm added statements to overlay color coded operating points and shift lines on motor efficiency map
% 01/22/00:tm in plotting of motor efficiency contours, changed mc_max_trq to mc_map_trq and removed *mc_overtrq_factor
% 2/2/01:tm disabled plots of gear number operation on motor efficiency plots - only applicable to bd_par_split
%
