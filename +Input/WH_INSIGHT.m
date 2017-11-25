% ADVISOR data file:  WH_INSIGHT.m
%
% Data source: All data copied from WH_SMCAR except wheel radius.
%
% Data confirmation:
%
% Notes:
% File copied from WH_SMCAR.m 
%
% Defines tire, wheel, and axle assembly parameters for use with ADVISOR 2, for
% a hypothetical small car.
%
% Created on: 2/10/00
% By:  KJK, NREL, ken_kelly@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wh_description='Wheel/axle assembly for small car (Honda Insight)';
wh_version=2003; % version of ADVISOR for which the file was generated
wh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
wh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: WH_INSIGHT - ',wh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORCE AND MASS RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% vehicle test mass vector used in tandem with "wh_axle_loss_trq" to estimate
% wheel and axle bearing and brake drag
wh_axle_loss_mass=[0 2000];   % (kg)
% (tractive force on the front tires)/(weight on front axle), used in tandem
% with "wh_slip" to estimate tire slip at any time
wh_slip_force_coeff=[0 0.3913 0.6715 0.8540 0.9616 1.0212];  % (--)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS parameters		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% drag torque applied at the front (drive) axle, used with "wh_axle_loss_mass"
wh_axle_loss_trq=[4 24]*.4;   % (Nm)
% slip=(omega * r)/v -1; used with "wh_slip_force_coeff"
wh_slip=[0.0 0.025 0.050 0.075 0.10 0.125];  % (--)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wh_radius=0.275;     % Taken from mph/1000rpm data from Car&Driver 1/2000
							%	Gear I 5.8 mph/1000rpm, 3.46 gear ratio
							%	Gear II 11.5 mph/1000rpm, 1.75 gear ratio
                     %	Gear III 18.3 mph/1000rpm, 1.10 gear ratio
							%	Gear IV 23.4 mph/1000rpm, 0.86 gear ratio
							%	Gear V 28.3 mph/1000rpm, 0.71 gear ratio

							% (m), Honda Insight wheels P165/65R14 78S low rolling resistance
							% wheel diameter = (2*165*.65)+ 14"(25.4)= 570.1 mm
							% wh_radius = wheel diameter/2 - squish (assumed squish of 10 mm)
% rotational inertia of all wheels, tires, and axles
% below uses OTA's '94 estimate of Taurus wheel, tire & tool mass as mass of
% solid cylinders of radius wh_radius, rotating at wheel speed in this vehicle
wh_inertia=181/2.205*wh_radius^2/2;  % (kg*m^2) 

% fraction of braking done by driveline, indexed by wh_fa_dl_brake_mph
wh_fa_dl_brake_frac=[0 0 1 1 1];  % (--)
% Here, we send the whole regen braking command to the Driveline (EM+ICE).
% In the control strategy, the amount of Regen is then decided by the strategy, 
% and the remaning is passed on to the Brakes again, due to the backward facing 
% architecture of the simulator.

% (--), fraction of braking done by front friction brakes,
% indexed by wh_fa_fric_brake_mph
wh_fa_fric_brake_frac=[0.8 0.8 0 0 0];  % (--)
wh_fa_dl_brake_mph=[-1 0 10 60 1000];   % (mph)
wh_fa_fric_brake_mph=wh_fa_dl_brake_mph; % (mph)

wh_1st_rrc=0.0054; % (--), rolling resistance coefficient calculated from (0.009 -0.40*0.009) based on Honda's reported 40% lower rolling resistance 
wh_2nd_rrc=0; % (s/m)

wh_mass=0;

%%%%%%%%%%%%%%%%%
% Error checking
%%%%%%%%%%%%%%%%%
% dl+fa_fric must add up to <= 1 for all speeds.  Give user warning if in error
temp_total_braking=wh_fa_dl_brake_frac+wh_fa_fric_brake_frac;
if any(temp_total_braking>1)
    disp('Warning: Driveline and Front Friction Braking need to add to less than or equal to 1 for')
    disp('         all speeds.  Please edit either wh_fa_dl_brake_frac or wh_fa_fric_brake_frac');
    disp('         in WH_*.m.  See Chapter 3.2.4, Braking of the documentation for more info.');
end
clear temp_total_braking

% front or rear or both axles driving?
wh_front_active_bool=1; % 0==> inactive; 1==> active
wh_rear_active_bool=0; % 0==> inactive; 1==> active

% braking force limits
wh_max_front_brake_force=-inf;% (N)
wh_max_rear_brake_force=-inf;% (N)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%  WH_SMCAR revision history %%%%%%%
%9/17/98-ss added wh_mass=0;
%01/21/99:mc updated wh_slip and wh_slip_force_coeff per DB's suggestion
% 3/15/99:ss updated *_version to 2.1 from 2.0

% 11/03/99:ss updated version from 2.2 to 2.21

%%%%%% WH_INSIGHT revision history %%%%%%%
%
% 2/10/00 (kjk): WH_INSIGHT created from WH_SMCAR.m
% 7/12/00 (kjk): modified tire radius, added notes
% 01/10/01: vhj added error checking (warning to user about incorrect braking numbers)
% 07/02/01: ar modified the vectors wh_fa_fric_brake_frac & wh_fa_dl_brake_frac for allowing
% more regen into the driveline.
% 4/4/02: mpo added rolling resistance coefficient data to this file (from vehicle wh_1st_rrc wh_2nd_rrc)
% 3/3/03:tm added *active_bool and wh_max* parameters to work with updated models