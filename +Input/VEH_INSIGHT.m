% ADVISOR data file:  VEH_INSIGHT.m
%
% Data source:
%
% Data confirmation:
%
% Notes:  Defines road load parameters for a the Honda Insight 2000
% 
% Created on: 26-Oct-1999
% By:  Ken Kelly of NREL, ken_kelly@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_description='Honda Insight 2000';
veh_version=2003; % version of ADVISOR for which the file was generated
veh_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
veh_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 						  2=> data matches source data and data collection methods have been verified
disp(['Data loaded: VEH_INSIGHT - ',veh_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PHYSICAL CONSTANTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
veh_gravity=9.81;    % m/s^2
veh_air_density=1.2; % kg/m^3


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VEHICLE PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note on vehicle mass:
%		The actual average vehicle mass of a 2000 Honda Insight with manual 5 spd is 1887 lbs (856 kg - curb weight with AC).
%		If you wish to accurately set your total vehicle mass
% 	 	to this value in the A2 GUI, you should use the mass override
%		checkbox and enter in the value 992, which is (1887+300)/2.2046) = 992 kg, which comes from
%		adding on 300 lbs of EPA test mass (converted to kilograms).
%		The glider mass below is an guestimate using the overall vehicle mass 800 kg less 60 kg for
%		the engine, less 20 kg for the battery, less 200 kg for the rest of the propulsion system
%
veh_mass = 800; % (kg), vehicle mass 1887 lbs (curb weight) with AC, Automotive Engineering, Oct '99
battery_mass = 44/2.2046; % 44 lbs converted to kg, Automotive News, July 12, 99
engine_mass = 60; % (kg), Automotive Engineering, Oct '99
vehicle_height = 1.325; % (m), Automotive Engineering, Oct '99
vehicle_width = 1.695; % (m), Automotive Engineering, Oct '99
%
veh_glider_mass = veh_mass - engine_mass - battery_mass - 200; % (kg), estimated vehicle mass w/o propulsion system (fuel converter,
                     % exhaust aftertreatment, drivetrain, motor, ESS, generator)
veh_CD=0.25;  % (--), coefficient of aerodynamic drag, Automotive Engineering, Oct '99

veh_FA=1.9;    % (m^2), Car & Driver, Jan '00
% for the eq'n:  rolling_drag=mass*gravity*(veh_1st_rrc+veh_2nd_rrc*v)
%veh_1st_rrc=0.0054;  % (--), calculated from (0.009 -0.40*0.009) based on Honda's reported 40% lower rolling resistance 
%veh_2nd_rrc=0;		% (s/m),taken from VEH_SMCAR 
% fraction of vehicle weight on front axle when standing still
veh_front_wt_frac=0.6;  % (--), taken from VEH_SMCAR 
% height of vehicle center-of-gravity above the road
veh_cg_height=0.5;	% (m), estimated for 1995 Saturn SL
% vehicle wheelbase, from center of front tire patch to center of rear patch
veh_wheelbase=2.4; % (m), Automotive Engineering, Oct '99

veh_cargo_mass=136; %kg  cargo mass, taken from VEH_SMCAR 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 10/27/99 VEH_INSIGHT Created by KJK from copy of VEH_SMCAR
% 8/17/00, kjk, modified frontal area and rolling resistance
% 04-Apr-2002: mpo moving veh_1st_rrc and veh_2nd_rrc over to the wheel files as wh_1st_rrc and wh_2nd_rrc