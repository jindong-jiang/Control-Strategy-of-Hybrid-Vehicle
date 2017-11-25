% ADVISOR data file:  PTC_INSIGHT.m
%
% Data source:
%					copied from PTC_PAR, engine idle speed from NREL testing
% Data confirmation:
%
% Notes:
% Defines all powertrain control parameters, including gearbox, clutch, hybrid
% and engine controls, for a parallel hybrid using a 5-spd gearbox.
% 
% Created on: 5-Jul-2000
% By:  KJK, NREL, ken_kelly@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('update_cs_flag')
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ptc_description='Model of Honda Insight Control Strategy, 5-spd parallel integrated motor assist hybrid';
ptc_version=2003; % version of ADVISOR for which the file was generated
ptc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
ptc_validation=0; % 1=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: PTC_INSIGHT - ',ptc_description])

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLUTCH & ENGINE CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vc_idle_spd=94;  % (rad/s), Insight engine's idle speed from NREL testing
% 1=> idling allowed; 0=> engine shuts down rather than
vc_idle_bool=0;  % (--)
% 1=> disengaged clutch when req'd engine torque <=0; 0=> clutch remains engaged
vc_clutch_bool=0; % (--)
% speed at which engine spins while clutch slips during launch
vc_launch_spd=max(fc_map_spd)/6; % (rad/s), 
% fraction of engine thermostat temperature below which the engine will stay on once it is on
vc_fc_warm_tmp_frac=0.85; % (--) 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GEARBOX CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fractional engine load {=(torque)/(max torque at speed)} above which a
% downshift is called for, indexed by gb_gearN_dnshift_spd
gb_gear1_dnshift_load=[0 0.6 0.9 1];  % (--)
gb_gear2_dnshift_load=gb_gear1_dnshift_load;  % (--)
gb_gear3_dnshift_load=gb_gear1_dnshift_load;  % (--)
gb_gear4_dnshift_load=gb_gear1_dnshift_load;  % (--)
gb_gear5_dnshift_load=gb_gear1_dnshift_load;  % (--)
% fractional engine load {=(torque)/(max torque at speed)} below which an
% upshift is called for, indexed by gb_gearN_upshift_spd
gb_gear1_upshift_load=[0 0.3 1];  % (--)
gb_gear2_upshift_load=gb_gear1_upshift_load;  % (--)
gb_gear3_upshift_load=gb_gear1_upshift_load;  % (--)
gb_gear4_upshift_load=gb_gear1_upshift_load;  % (--)
gb_gear5_upshift_load=gb_gear1_upshift_load;  % (--)
gb_gear1_dnshift_spd=[0.21 0.2101 0.45 0.45001]*max(fc_map_spd)*fc_spd_scale;  % (rad/s)
gb_gear2_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear3_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear4_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear5_dnshift_spd=gb_gear1_dnshift_spd;  % (rad/s)
gb_gear1_upshift_spd=[0.36 0.3601 0.98]*max(fc_map_spd)*fc_spd_scale;  % (rad/s)
% 0.98 rather than 1 because engine may not be able to reach the max speed 
% under certain conditions due to speed estimation method
% this setting allows the vehicle to shift before it gets to the max engine speed (tm:11/11/99)
gb_gear2_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
gb_gear3_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
gb_gear4_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)
gb_gear5_upshift_spd=gb_gear1_upshift_spd;  % (rad/s)

% convert old shift commands to new shift commands
gb_upshift_spd={gb_gear1_upshift_spd; ...
      gb_gear2_upshift_spd;...
      gb_gear3_upshift_spd;...
      gb_gear4_upshift_spd;...
      gb_gear5_upshift_spd};  % (rad/s)

gb_upshift_load={gb_gear1_upshift_load; ...
      gb_gear2_upshift_load;...
      gb_gear3_upshift_load;...
      gb_gear4_upshift_load;...
      gb_gear5_upshift_load};  % (--)

gb_dnshift_spd={gb_gear1_dnshift_spd; ...
      gb_gear2_dnshift_spd;...
      gb_gear3_dnshift_spd;...
      gb_gear4_dnshift_spd;...
      gb_gear5_dnshift_spd};  % (rad/s)

gb_dnshift_load={gb_gear1_dnshift_load; ...
      gb_gear2_dnshift_load;...
      gb_gear3_dnshift_load;...
      gb_gear4_dnshift_load;...
      gb_gear5_dnshift_load};  % (--)

clear gb_gear*shift* % remove unnecessary data

% fixes the difference between number of shift vectors and gears in gearbox
if length(gb_upshift_spd)<length(gb_ratio)
   start_pt=length(gb_upshift_spd);
   for x=1:length(gb_ratio)-length(gb_upshift_spd)
      gb_upshift_spd{x+start_pt}=gb_upshift_spd{1};
      gb_upshift_load{x+start_pt}=gb_upshift_load{1};
      gb_dnshift_spd{x+start_pt}=gb_dnshift_spd{1};
      gb_dnshift_load{x+start_pt}=gb_dnshift_load{1};
   end
end

% duration of shift during which no torque can be transmitted
gb_shift_delay=0;  % (s)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HYBRID CONTROL STRATEGY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ess_init_soc=0.7;  % (--), initial battery SOC; this is inputed from the simulation screen now.
cs_hi_soc=0.8;  % (--), highest desired battery state of charge
cs_lo_soc=0.2;  % (--), lowest desired battery state of charge
% vehicle speed below which vehicle operates as ZEV
cs_electric_decel_spd=4.5;  % (m/s) during decel
% 1 => allows engine to be shut off during low speed decel; 0=> keeps engine on 
% (i.e. clutch disengaged and clutch engaged, respectively)
cs_decel_fc_off=1; % boolean

% The following variables bring scalability to the new Insight control strategy
% (Refer to the Honda Insight help file for details on how to use these variables)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VARIABLES FOR ASSIST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Driveline torque threshold below which the electric machine does not assist
cs_dl_assist_trq_threshold=25; % (Nm)
% Minimum Torque normally provided by the electric motor when driveline torque exceeds threshold
% (as a fraction of max torque)
cs_mc_assist_min_frac=0.129; % (Nm)
% Fraction (slope of the line) of the driveline torque provided by the electric motor when 
% the driveline torque exceeds threshold
cs_mc_assist_slope=1/11; %(--)
% Maximum motor torque requested from the motor during assist
% (as a fraction of max torque)
cs_mc_assist_max_frac=0.32; %(--)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VARIABLES FOR REGENERATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Driveline regenerative torque threshold above which the electric machine does not regen at low speeds
cs_dl_regen_trq_threshold=-15; % (Nm)
% Minimum regen Torque normally provided by the electric motor when driveline torque exceeds regen threshold
% (as a fraction of max regen torque)
cs_mc_regen_min_frac=0; % (Nm) (Start from zero in the Insight)
% Fraction (slope of the line) of the negative driveline torque regenerated by the electric motor when 
% the driveline torque exceeds threshold
cs_mc_regen_slope=0.7; %(--)
% Maximum regen motor torque requested from the motor during regeneration/braking
% (as a fraction of max regen torque)
cs_mc_regen_max_frac=1; %(--)
% Speed during deceleration below which the electric motor does not regenerate (all emphasis on friction braking)
cs_decel_regen_threshold=10; %(mph)

%%%%%%%%%%%%%%% START OF SPEED DEPENDENT SHIFTING INFORMATION %%%%%%%%%%%%%

% Data specific for SPEED DEPENDENT SHIFTING in the (PRE_TX) GEARBOX CONTROL 
% BLOCK in VEHICLE CONTROLS <vc>
% --implemented for all powertrains except CVT versions and Toyota Prius (JPN)
%
tx_speed_dep=0;	% Value for the switch in the gearbox control
% 			If tx_speed_dep=1, the speed dependent gearbox is chosen
% 			If tx_speed_dep=0, the engine load dependent gearbox is chosen
%
% Vehicle speed (m/s) where the gearbox has to shift
%tx_1_2_spd=24/3.6;	% converting from km/hr to m/s				
%tx_2_3_spd=40/3.6;
%tx_3_4_spd=64/3.6;
%tx_4_5_spd=75/3.6;
%tx_5_4_spd=75/3.6;
%tx_4_3_spd=64/3.6;
%tx_3_2_spd=40/3.6;
%tx_2_1_spd=tx_1_2_spd;

% first column is speed in m/s, second column is gear number
% note: lookup data should be specified as a step function
% ..... this can be done by repeating values of x (first column, speed)
% ..... for differing values of y (second column, )
% note: division by 3.6 to change from km/hr to m/s

% speeds to use for upshift transition (shifting while accelerating) 
tx_spd_dep_upshift = [
   0/3.6, 1
   24/3.6, 1
   24/3.6, 2
   40/3.6, 2
   40/3.6, 3
   64/3.6, 3
   64/3.6, 4
   75/3.6, 4
   75/3.6, 5
   1000/3.6, 5];

% speeds to use for downshift transition (shifting while decelerating)
tx_spd_dep_dnshift = [
   0/3.6, 1
   24/3.6, 1
   24/3.6, 2
   40/3.6, 2
   40/3.6, 3
   64/3.6, 3
   64/3.6, 4
   75/3.6, 4
   75/3.6, 5
   1000/3.6, 5];
%%%%%%%%%%%%%%% END OF SPEED DEPENDENT SHIFTING %%%%%%%%%%%%%

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PTC_PAR revision history
%8/12/98,vh, cs_charge_trq,initialy =0, set to 20
%8/17/98,vh, changed behavior of cs_charge_trq in block diagram:  only adds this
%            additional torque when SOC < cs_lo_soc
%8/26/98,vh changed behavior of cs_charge_trq in block diagram: now, cscharge_trq*(cs_lo_soc-SOC)=additional torque
%09/15/98:MC set gb_shift_delay=0 for reasonable trace following
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 10/7/99:tm added *fc_spd_scale to shift speed definitions
%10/25/99:mc updated cs_electric_launch_spd and cs_off_trq_frac to improve FE and reduce engine cycling
% 11/03/99:ss updated version from 2.2 to 2.21
% 1/12/00:tm introduced cs_charge_deplete_bool

% PTC_INSIGHT Revision History Below

% 7/5/00,kjk, copied from PTC_PAR, modified engine idle speed
% 8/15/00:tm introduced cs_electric_decel_spd and cs_decel_fc_off
% 8/17/00:tm removed cs_off_trq_frac - not applicable
% 8/17/00:tm set min trq frac to 0 since the insight does not force a min trq that we know of at this time
% 8/18/00:tm introduced vc_fc_warm_tmp_frac to allow control of engine on based on coolant temp
% 8/22/00:kjk, modified gb_gear1_dnshift_spd and gb_gear1_upshift_spd
% 7/25/01:ar modified variables to suit new Insight control strategy
% 7/31/01:mpo added variables for speed dependent shifting
% 8/15/01:ar changed new control strategy for scalability and to perform sensitivity analysis