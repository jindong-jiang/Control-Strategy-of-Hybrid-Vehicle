function EnergyFigure(action)

%this function displays the energy balance figure and energy usage plots

global vinf
str=vinf.drivetrain.name;

global fc_retard_kj tc_in_regen_kj tc_out_regen_kj tc_regen_loss_kj tc_regen_eff
global gb_in_regen_kj gb_out_regen_kj gb_regen_loss_kj gb_regen_eff fd_in_regen_kj fd_out_regen_kj fd_regen_loss_kj fd_regen_eff
global wh_in_regen_kj wh_out_regen_kj wh_regen_loss_kj wh_regen_eff
global aero_kj rolling_kj
global clutch_regen_in_kj clutch_regen_out_kj clutch_regen_loss_kj clutch_regen_eff
global htc_regen_in_kj htc_regen_out_kj htc_regen_loss_kj htc_regen_eff


global values_to_plot labels4plot
global values_to_plot_reg  labels4plot_reg



if nargin<1
%setup the colors for the figure
figure_color=[.7 .9 1];
main_frame_color=[.7 .9 1];
button_frame_color=[0 0 0];   
scale_color=[0.75 .75 .75];

% The figure properties
h0 = figure('Color',figure_color, ...
   'Name','Energy Usage Figure', ...
   'Renderer','zbuffer',...
   'menubar','none',...
	'numbertitle','off',...
   'ResizeFcn','gui_size',...
   'Position',[1 1 717 546],...
   'Visible','off');

%big frame for printing
h1= uicontrol('Parent',h0,...
      'BackgroundColor',figure_color, ...
      'Position',[1 1 717 546],...
      'Style','frame');


%run the file to set up the menubar
adv_menu('energy');

%DONE button
h1=uicontrol('parent',h0,...
   'BackgroundColor',[0.8 0.8 0.8],...
   'CallBack','close(gcbf)',...
   'position',[630 30 60 30],...
   'string','DONE');
h1=uicontrol('parent',h0,...
   'BackgroundColor',[0.8 0.8 0.8],...
   'CallBack','energy_figure(''loss_plot'')',...
   'position',[130 30 150 30],...
   'string','Loss Plot (Power Mode)');
h1=uicontrol('parent',h0,...
   'BackgroundColor',[0.8 0.8 0.8],...
   'CallBack','energy_figure(''regen_plot'')',...
   'position',[300 30 150 30],...
   'string','Loss Plot (Regen Mode)');

%the skinny frames for dividing up the figure
h1 = uicontrol('Parent',h0, ...
   'Position',[ 126 484 512 4], ...
   'Style','frame');
h1 = uicontrol('Parent',h0, ...
   'Position',[ 373 203 5 300], ...
   'Style','frame');


%get the needed values from the base workspace
fuel_in_kj=evalin('base','fuel_in_kj');

fc_in_kj=fuel_in_kj;
fc_out_kj=evalin('base','fc_out_kj');
fc_loss_kj=evalin('base','fc_loss_kj');
fc_eff_avg=round(100*evalin('base','fc_eff_avg'))/100;

clutch_in_kj=evalin('base','clutch_in_kj');
clutch_out_kj=evalin('base','clutch_out_kj');
clutch_loss_kj=evalin('base','clutch_loss_kj');
clutch_eff=round(100*evalin('base','clutch_eff'))/100;

htc_in_kj=evalin('base','htc_in_kj');
htc_out_kj=evalin('base','htc_out_kj');
htc_loss_kj=evalin('base','htc_loss_kj');
htc_eff=round(100*evalin('base','htc_eff'))/100;


tc_in_kj=evalin('base','tc_in_kj');
tc_out_kj=evalin('base','tc_out_kj');
tc_loss_kj=evalin('base','tc_loss_kj');
tc_eff=round(100*evalin('base','tc_eff'))/100;

gb_in_kj=evalin('base','gb_in_kj');
gb_out_kj=evalin('base','gb_out_kj');      
gb_eff=round(100*evalin('base','gb_eff'))/100;
gb_loss_kj=evalin('base','gb_loss_kj');

fd_in_kj=evalin('base','fd_in_kj');
fd_out_kj=evalin('base','fd_out_kj');
fd_eff=round(100*evalin('base','fd_eff'))/100;
fd_loss_kj=evalin('base','fd_loss_kj');
wh_in_kj=evalin('base','wh_in_kj');
wh_out_kj=evalin('base','wh_out_kj');
wh_eff=round(100*evalin('base','wh_eff'))/100;
wh_loss_kj=evalin('base','wh_loss_kj');

road_load_kj=evalin('base','road_load_kj');

aux_load_in_kj=evalin('base','aux_load_in_kj');
aux_load_out_kj=evalin('base','aux_load_out_kj');
aux_load_loss_kj=evalin('base','aux_load_loss_kj');
aux_load_eff=evalin('base','aux_load_eff');

brake_loss_kj=evalin('base','brake_loss_kj');

if evalin('base','exist(''gc_out_kj'')') %ss 2/1/01 changed from 'gc_trq_out_a' to 'gc_out_kj'
   gc_in_kj=evalin('base','gc_in_kj');
   gc_out_kj=evalin('base','gc_out_kj');
   gc_loss_kj=evalin('base','gc_loss_kj');
   gc_eff=round(100*evalin('base','gc_eff'))/100;
 else
   gc_in_kj=NaN;
   gc_out_kj=NaN;
   gc_eff=NaN;
   gc_loss_kj=NaN;
end

if evalin('base','exist(''mc_trq_out_a'')')
   mc_in_kj=evalin('base','mc_in_kj');
   mc_out_kj=evalin('base','mc_out_kj');
   mc_loss_kj=evalin('base','mc_loss_kj');
   mc_eff=round(100*evalin('base','mc_eff'))/100;
   
   mot_as_gen_in_kj=evalin('base','mot_as_gen_in_kj');
   mot_as_gen_out_kj=evalin('base','mot_as_gen_out_kj');
   mot_as_gen_loss_kj=evalin('base','mot_as_gen_loss_kj');
   mot_as_gen_eff=round(100*evalin('base','mot_as_gen_eff'))/100;
else
   mc_in_kj=NaN;
   mc_out_kj=NaN;
   mc_loss_kj=NaN;
   mc_eff=NaN;
   
   mot_as_gen_in_kj=NaN;
   mot_as_gen_out_kj=NaN;
   mot_as_gen_loss_kj=NaN;
   mot_as_gen_eff=NaN;
end
   if evalin('base','exist(''ess_pwr_out_a'')')&evalin('base','ess_on')
      ess_in_kj=evalin('base','ess_in_kj');
      ess_out_kj=evalin('base','ess_out_kj');
      ess_loss_kj=evalin('base','ess_loss_kj');
      ess_eff=round(100*evalin('base','ess_eff'))/100;
      ess_stored_kj=evalin('base','ess_stored_kj');
   else
      ess_in_kj=NaN;
      ess_out_kj=NaN;
      ess_loss_kj=NaN;
      ess_stored_kj=NaN;
      ess_eff=NaN;
   end
   
labels=                     {'Fuel'      'Fuel Converter'  'Clutch'            'Hyd. Torque Converter'  'Generator'    'Torque Coupling'  'Energy Storage'  'Energy Stored'  'Motor/Controller'   'Gearbox' 	     'Final Drive'    'Wheel/Axle'     'Braking'	   'Aux Loads' 	    'Aero'         'Rolling'};

values_not_rounded_in=      [0            fc_in_kj         clutch_in_kj        htc_in_kj                gc_in_kj       tc_in_kj           ess_in_kj         ess_stored_kj    mc_in_kj             gb_in_kj          fd_in_kj  	    wh_in_kj	    NaN               aux_load_in_kj     NaN            NaN           ];
values_not_rounded_out=     [fuel_in_kj   fc_out_kj        clutch_out_kj       htc_out_kj               gc_out_kj      tc_out_kj          ess_out_kj        NaN              mc_out_kj            gb_out_kj         fd_out_kj         wh_out_kj         NaN               aux_load_out_kj    NaN            NaN           ];
values_loss_not_rounded=    [NaN          fc_loss_kj       clutch_loss_kj      htc_loss_kj              gc_loss_kj     tc_loss_kj         ess_loss_kj       NaN              mc_loss_kj           gb_loss_kj        fd_loss_kj        wh_loss_kj        NaN               aux_load_loss_kj   aero_kj        rolling_kj    ];
efficiencies=               [NaN 	      fc_eff_avg	     clutch_eff          htc_eff                  gc_eff	       tc_eff	        ess_eff	        NaN		       mc_eff               gb_eff	          fd_eff            wh_eff            NaN               aux_load_eff       NaN            NaN           ];
values_in=round(values_not_rounded_in);
values_out=round(values_not_rounded_out);
values_loss=round(values_loss_not_rounded); 

%REGEN VALUES
values_not_rounded_in_reg=  [NaN          NaN              clutch_regen_in_kj   htc_regen_in_kj          NaN            tc_in_regen_kj     NaN               NaN              mot_as_gen_in_kj     gb_in_regen_kj    fd_in_regen_kj    wh_in_regen_kj    NaN              NaN                NaN             NaN           ];
values_not_rounded_out_reg= [NaN          NaN              clutch_regen_out_kj  htc_regen_out_kj         NaN            tc_out_regen_kj    NaN               NaN              mot_as_gen_out_kj    gb_out_regen_kj   fd_out_regen_kj   wh_out_regen_kj   NaN              NaN                NaN             NaN           ];
values_loss_not_rounded_reg=[NaN          fc_retard_kj     clutch_regen_loss_kj htc_regen_loss_kj        NaN            tc_regen_loss_kj   NaN               NaN              mot_as_gen_loss_kj   gb_regen_loss_kj  fd_regen_loss_kj  wh_regen_loss_kj  brake_loss_kj    NaN                NaN             NaN           ];
efficiencies_reg=           [NaN 	      NaN              clutch_regen_eff     htc_regen_eff            NaN	       tc_regen_eff	  NaN               NaN		       mot_as_gen_eff       gb_regen_eff      fd_regen_eff      wh_regen_eff      NaN              NaN                NaN             NaN           ];
values_in_reg=round(values_not_rounded_in_reg);
values_out_reg=round(values_not_rounded_out_reg);
values_loss_reg=round(values_loss_not_rounded_reg); 
efficiencies_reg=round(100*efficiencies_reg)/100;


%the energy balance number
balance_check=0;
if ~isnan(fuel_in_kj)
   balance_check=fuel_in_kj;
end
for i=2:length(values_loss_not_rounded)
   if ~isnan(values_loss_not_rounded(i))
      balance_check=balance_check-values_loss_not_rounded(i);
   end
end
for i=2:length(values_loss_not_rounded_reg)
   if ~isnan(values_loss_not_rounded_reg(i))
      balance_check=balance_check-values_loss_not_rounded_reg(i);
   end
end

if ~isnan(ess_stored_kj)
   balance_check=balance_check-ess_stored_kj;
end

%temp correction until find out where the inbalance is between aero+rolling and road_load
balance_check=balance_check+aero_kj+rolling_kj-road_load_kj;

%------------------------

%overall efficiency number
if strcmp(vinf.drivetrain.name,'conventional')
   overall_eff=(aero_kj+rolling_kj)/fuel_in_kj;
else
   if isnan(fuel_in_kj)
      fuel_in_kj=0;
   end
   if isnan(ess_stored_kj)
      ess_stored_kj=0;
   end
   overall_eff=(aero_kj+rolling_kj)/(fuel_in_kj-ess_stored_kj);
end

values_to_plot=[fc_loss_kj        clutch_loss_kj   htc_loss_kj            gc_loss_kj   tc_loss_kj             ess_loss_kj       mc_loss_kj            gb_loss_kj  fd_loss_kj      wh_loss_kj brake_loss_kj aux_load_loss_kj aero_kj  rolling_kj];
labels4plot={'Fuel Converter'    'Clutch'       'Hyd. Torque Converter'  'Generator' 'Torque Coupling'      'Energy Storage'  'Motor/Controller'          'Gearbox'   'Final Drive'  'Wheel/Axle'  'Braking'     'Aux Load'   'Aero'   'Rolling'};
%sort values and labels for a paretto type chart
[values_to_plot,ind]=sort(values_to_plot);
labels4plot=labels4plot(ind);
   
values_to_plot_reg=[fc_retard_kj        clutch_regen_loss_kj   htc_regen_loss_kj          tc_regen_loss_kj      mot_as_gen_loss_kj    gb_regen_loss_kj    fd_regen_loss_kj      wh_regen_loss_kj    brake_loss_kj   ];
labels4plot_reg={'FC braking'           'Clutch'               'Hyd. Torque Converter'   'Torque Coupling'      'Motor/Controller'    'Gearbox'           'Final Drive'         'Wheel/Axle'       'Braking'        };
%sort values and labels for a paretto type chart
[values_to_plot_reg,ind_reg]=sort(values_to_plot_reg);
labels4plot_reg=labels4plot_reg(ind_reg);
   
   

%set up the energy balance table
h1 = uicontrol('Parent',h0, ...
   'BackgroundColor',main_frame_color, ...
   'fontweight','bold',...
   'Position',[20 525 160 20], ...
   'String','Energy Usage Table (kJ)', ...
   'Style','text', ...
   'Tag','StaticText83');
h1 = uicontrol('Parent',h0, ...
   'BackgroundColor',main_frame_color, ...
   'fontweight','bold',...
   'Position',[145 510 140 20], ...
   'String','POWER MODE', ...
   'Style','text', ...
   'Tag','StaticText83');

h1 = uicontrol('Parent',h0, ...
   'BackgroundColor',main_frame_color, ...
   'fontweight','bold',...
   'Position',[140 488 24 18], ...
   'String','In', ...
   'Style','text', ...
   'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
   'BackgroundColor',main_frame_color, ...
   'fontweight','bold',...
   'Position',[193 488 46 18], ...
   'String','Out', ...
   'Style','text', ...
   'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
   'BackgroundColor',main_frame_color, ...
   'Position',[256 488 57 18], ...
   'fontweight','bold',...
   'String','Loss', ...
   'Style','text', ...
   'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
   'Position',[319 488 40 18], ...
   'fontweight','bold',...
   'BackgroundColor',main_frame_color, ...
   'String','Eff.', ...
   'Style','text', ...
   'Tag','StaticText2');

%REGEN TITLES
h1 = uicontrol('Parent',h0, ...
   'BackgroundColor',main_frame_color, ...
   'fontweight','bold',...
   'Position',[400 510 140 20], ...
   'String','REGEN MODE', ...
   'Style','text', ...
   'Tag','StaticText83');

h1 = uicontrol('Parent',h0, ...
   'BackgroundColor',main_frame_color, ...
   'fontweight','bold',...
   'Position',[402 488 24 18], ...
   'String','In', ...
   'Style','text', ...
   'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
   'BackgroundColor',main_frame_color, ...
   'fontweight','bold',...
   'Position',[471 488 46 18], ...
   'String','Out', ...
   'Style','text', ...
   'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
   'BackgroundColor',main_frame_color, ...
   'Position',[540 488 57 18], ...
   'fontweight','bold',...
   'String','Loss', ...
   'Style','text', ...
   'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
   'Position',[609 488 40 18], ...
   'BackgroundColor',main_frame_color, ...
   'fontweight','bold',...
   'String','Eff.', ...
   'Style','text', ...
   'Tag','StaticText2');




x=[7 114 183 252 326 395 464 533 602]; %[125 232 301 369 443];
y=466; %275;
w=[130 66 32];
h=18;
for i=1:length(labels)
   % labels
   uicontrol('Parent',h0,'style','text','fontweight','bold','string',labels{i},'position',[x(1) y-(i-1)*18 w(1) h],'backgroundcolor',main_frame_color);
   % values_in
   if ~isnan(values_in(i))
      uicontrol('Parent',h0,'style','text','fontweight','bold','string',num2str(values_in(i)),'position',[x(2) y-(i-1)*18 w(2) h],'backgroundcolor',main_frame_color);
   end
   % values_out
   if ~isnan(values_out(i))
      uicontrol('Parent',h0,'style','text','fontweight','bold','string',num2str(values_out(i)),'position',[x(3) y-(i-1)*18 w(2) h],'backgroundcolor',main_frame_color);
   end
   % values_loss
   if ~isnan(values_loss(i))
      uicontrol('Parent',h0,'style','text','fontweight','bold','string',num2str(values_loss(i)),'position',[x(4) y-(i-1)*18 w(2) h],'backgroundcolor',main_frame_color);
   end
   % efficiencies
   if ~isnan(efficiencies(i))
      uicontrol('Parent',h0,'style','text','fontweight','bold','string',num2str(efficiencies(i)),'position',[x(5) y-(i-1)*18 w(3) h],'backgroundcolor',main_frame_color);
   end
   
   %REGEN MODE variables follow
   
   % values_in_reg
   if ~isnan(values_in_reg(i))
      uicontrol('Parent',h0,'style','text','fontweight','bold','string',num2str(values_in_reg(i)),'position',[x(6) y-(i-1)*18 w(2) h],'backgroundcolor',main_frame_color);
   end
   % values_out_reg
   if ~isnan(values_out_reg(i))
      uicontrol('Parent',h0,'style','text','fontweight','bold','string',num2str(values_out_reg(i)),'position',[x(7) y-(i-1)*18 w(2) h],'backgroundcolor',main_frame_color);
   end
   % values_loss_reg
   if ~isnan(values_loss_reg(i))
      uicontrol('Parent',h0,'style','text','fontweight','bold','string',num2str(values_loss_reg(i)),'position',[x(8) y-(i-1)*18 w(2) h],'backgroundcolor',main_frame_color);
   end
   % efficiencies_reg
   if ~isnan(efficiencies_reg(i))
      uicontrol('Parent',h0,'style','text','fontweight','bold','string',num2str(efficiencies_reg(i)),'position',[x(9) y-(i-1)*18 w(3) h],'backgroundcolor',main_frame_color);
   end
   
end


%remove energy balance check for now
if 0
   % Energy balance check
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',main_frame_color, ...
      'Position',[485 152 101 31], ...
      'String','Energy Balance Check', ...
      'Style','text', ...
      'Tag','StaticText7');
   %want balance check to be in short exponential notation
   format short e
   h1 = uicontrol('Parent',h0, ...
      'BackgroundColor',main_frame_color, ...
      'Position',[500 131 95 20], ...
      'fontweight','bold',...
      'String',num2str(balance_check), ...
      'Style','text', ...
      'Tag','StaticText8');
   %return to default
   format
end;%if 0


% Overall system efficiency
h1 = uicontrol('Parent',h0, ...
   'BackgroundColor',main_frame_color, ...
   'Position',[485 125 101 31], ...
   'String','*Overall System Efficiency', ...
   'Style','text', ...
   'Tag','StaticText7');
h1 = uicontrol('Parent',h0, ...
   'BackgroundColor',main_frame_color, ...
   'Position',[512 104 46 20], ...
   'fontweight','bold',...
   'String',num2str(round(1000*overall_eff)/1000), ...
   'Style','text', ...
   'Tag','StaticText8');

%explanation of overall efficiency calculation
h1 = uicontrol('Parent',h0,...
   'BackgroundColor',main_frame_color,...
   'Position',[485 75 200 30],...
	'HorizontalAlignment','left',...   
	'String',{'*Overall energy efficiency is calculated as:';'(aero + rolling)/(fuel in - ess storage)'},...
   'style','text');


%set everything normalized and set the figure size and center it

h=findobj('type','uicontrol');
g=findobj('type','axes');

set([h; g],'units','normalized')


eval('h=vinf.gui_size; test4exist=1;','test4exist=0;')
if test4exist
   set(gcf,'units','pixels','position',vinf.gui_size);
else
   screensize=get(0,'screensize'); %this should be in pixels(the default)
   if screensize(3)>=1024
      vinf.gui_size=[238 64 768 576];
   set(gcf,'units','pixels','position',vinf.gui_size);
   else
      set(gcf,'units','normalized')
      set(gcf,'position',[.03 .05 .95 .85]);
      set(gcf,'units','pixels');
   end
   
end

%set the figure back on after everything is drawn
set(gcf,'visible','on');

end; %  if nargin<1

if nargin>0
   
switch action
case 'loss_plot'
   h0 = figure('Color',[.8 .8 .8], ...
      'Name','Energy loss plot--', ...
      'Renderer','zbuffer',...
      'menubar','none',...
      'numbertitle','off',...
      'Position',[1 1 700 300],...
      'Visible','off');
   
   %menu bar
   adv_menu('loss_plot')
   
   %axes for bar plot
   h1 = axes('Parent',h0, ...
      'Units','pixels', ...
      'Position',[150 70 404 150], ...
      'Tag','results_axes1');
   axes(gca);
   barh(values_to_plot)
   set(gca,'color',[1 .5 .5])
   set(h1,'YTickLabel',labels4plot)
   title('Energy Usage(Power Mode) (kJ)')
   
   %set everything normalized and set the figure size and center it
   
   h=findobj('type','uicontrol');
   g=findobj('type','axes');
   
   set([h; g],'units','normalized')
   
   set(gcf,'units','normalized')
   if get(0,'screensize')==[1 1 1024 768]
      set(gcf,'position',[.2 .2 .65 .65]);
   else
      set(gcf,'position',[.1 .1 .8 .8]);
   end
   set(gcf,'units','pixels');
   
   %set the figure back on after everything is drawn
	set(gcf,'visible','on');

case 'regen_plot'
   h0 = figure('Color',[.8 .8 .8], ...
      'Name','Energy loss in regen plot', ...
      'Renderer','zbuffer',...
      'menubar','none',...
      'numbertitle','off',...
      'Position',[1 1 700 300],...
      'Visible','off');
   
   %menu bar
   adv_menu('loss_plot')
   
   %axes for bar plot
   h1 = axes('Parent',h0, ...
      'Units','pixels', ...
      'Position',[150 70 404 150], ...
      'Tag','results_axes1');
   axes(gca);
   barh(values_to_plot_reg)
   set(gca,'color',[1 .5 .5])
   set(h1,'YTickLabel',labels4plot_reg)
   title('Energy Usage(Regen Mode) (kJ)')
   
   %set everything normalized and set the figure size and center it
   
   h=findobj('type','uicontrol');
   g=findobj('type','axes');
   
   set([h; g],'units','normalized')
   
   set(gcf,'units','normalized')
   if get(0,'screensize')==[1 1 1024 768]
      set(gcf,'position',[.2 .2 .65 .65]);
   else
      set(gcf,'position',[.1 .1 .8 .8]);
   end
   set(gcf,'units','pixels');
   
   %set the figure back on after everything is drawn
	set(gcf,'visible','on');

   
   
otherwise
end

end;%if nargin>0

% REVISION HISTORY
% 3/19/99-ss: finishing touches for A2.1 release
% 4/6/99 ss: set 'visible' to 'off' while creating and turned back 'on' when created
% 5/26/99 ss: changed the way the figure size is determined.  If screensize is 1024x___ or bigger it uses
%             a predefined size in pixels else it uses normalized units.  Size is still saved between
%             figures.
% 11/8/99 ss: added explanation of overall efficiency calculation and added a decimal place.
% 7/21/00 ss: updated name for version info to advisor_ver.
% 8/16/00:tm added conditional to set all ess data to nan if ess disabled (ess_on=0)
% 8/16/00:tm added statements to set ess_storage_kj to zero if nan for overall eff calc
% 10/23/00:tm added parallel_sa to conditional to display hybrid data
% 10/27/00:tm revised the conditionals for hybrid component from drivetrain specific to component specific
% 11/6/00:tm added evalin('base',' to component conditionals
% 2/1/01:ss changed if statement for generator to be based on existence of 'gc_out_kj' instead of 'gc_trq_out_a'
