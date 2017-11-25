% ADVISOR Data file:  FC_INSIGHT.M
%
% Data source: 
% Fuel map from test data provided by Argonne National Laboratory (ANL) 
% Emissions maps are not included in this data file.
% 
% Data confidence level:  
%
% Notes: 
%
% Created on:  10/26/00
% By:  Ken Kelly, National Renewable Energy Laboratory, ken_kelly@nrel.gov
%
% Revision history at end of file.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_description='Honda Insight 1.0L VTEC-E SI Engine from ANL Test Data'; 
fc_version=2003; % version of ADVISOR for which the file was generated
fc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
fc_validation=1; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
fc_fuel_type='Gasoline';
fc_disp=1.0;  % (L), engine displacement
fc_emis=1;      % boolean 0=no emis data; 1=emis data
fc_cold=0;      % boolean 0=no cold data; 1=cold data exists
disp(['Data loaded: FC_INSIGHT - ',fc_description]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (rad/s), speed range of the engine 
fc_map_spd=[800 1273 1745 2218 2691 3164 3636 4109 4582 5055 5527 6000]*2*pi/60; 

% (N*m), torque range of the engine (original data given in lb-ft and converted to N-m)
fc_map_trq=[5.6 11.2 16.8 22.3 27.9 33.5 39.1 44.7 50.3 55.8 61.4 67.0]*1.355818; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUEL USE AND EMISSIONS MAPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fuel use map from Argonne National Laboratory
% (g/s), fuel use map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq 
fc_fuel_map =[
  0.0962  0.1269  0.1576  0.1883  0.2191  0.2498  0.2805  0.3112  0.3610  0.4566  0.4641  0.4641 
 0.1420  0.1909  0.2398  0.2887  0.3375  0.3864  0.4353  0.4842  0.5584  0.7129  0.7383  0.7383 
 0.1871  0.2541  0.3212  0.3882  0.4552  0.5223  0.5893  0.6563  0.7533  0.9683  1.0215  1.0215 
 0.2371  0.3223  0.4075  0.4927  0.5779  0.6630  0.7482  0.8334  0.9524  1.2297  1.3207  1.3207 
 0.2953  0.3987  0.5020  0.6053  0.7087  0.8120  0.9154  1.0187  1.1591  1.5012  1.6278  1.6399 
 0.3656  0.4871  0.6086  0.7301  0.8516  0.9731  1.0946  1.2160  1.3777  1.7875  1.9363  1.9839 
 0.4521  0.5918  0.7314  0.8711  1.0107  1.1504  1.2900  1.4297  1.6124  2.0936  2.2647  2.3577 
 0.5591  0.7169  0.8747  1.0325  1.1903  1.3481  1.5059  1.6637  2.0304  2.4249  2.6182  2.7666 
 0.7038  0.8993  1.1014  1.3102  1.5255  1.7475  1.9760  2.2112  2.4530  2.7014  2.9563  3.2156 
 0.8680  1.0863  1.3123  1.5458  1.7869  2.0356  2.2919  2.5558  2.8272  3.1063  3.3930  3.5433 
 1.0663  1.3087  1.5596  1.8193  2.0877  2.3647  2.6504  2.9448  3.2479  3.5596  3.8801  3.8830 
 1.3032  1.5709  1.8484  2.1357  2.4330  2.7402  3.0572  3.3841  3.7208  4.0675  4.2459  4.2459];

% (g/s), engine out HC emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_hc_map=zeros(size(fc_fuel_map));
% engine out HC in g/kWh (taken from Geo 1.0L engine)

% (g/s), engine out CO emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq 

fc_co_map=zeros(size(fc_fuel_map));
% engine out CO in g/kWh (taken from Geo 1.0L engine)

% (g/s), engine out NOx emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq

fc_nox_map=zeros(size(fc_fuel_map));
% engine out NOx in g/kWh (taken from Geo 1.0L engine)

% (g/s), engine out PM emissions indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_pm_map=zeros(size(fc_fuel_map));

% (g/s), engine out O2 indexed vertically by fc_map_spd and
% horizontally by fc_map_trq
fc_o2_map=zeros(size(fc_fuel_map));

% convert g/kWh maps to g/s maps
[T,w]=meshgrid(fc_map_trq, fc_map_spd);
fc_map_kW=T.*w/1000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cold Engine Maps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_cold_tmp=20; %deg C
fc_fuel_map_cold=zeros(size(fc_fuel_map));
fc_hc_map_cold=zeros(size(fc_fuel_map));
fc_co_map_cold=zeros(size(fc_fuel_map));
fc_nox_map_cold=zeros(size(fc_fuel_map));
fc_pm_map_cold=zeros(size(fc_fuel_map));
%Process Cold Maps to generate Correction Factor Maps
names={'fc_fuel_map','fc_hc_map','fc_co_map','fc_nox_map','fc_pm_map'};
for i=1:length(names)
    %cold to hot raio, e.g. fc_fuel_map_c2h = fc_fuel_map_cold ./ fc_fuel_map
    eval([names{i},'_c2h=',names{i},'_cold./(',names{i},'+eps);'])
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), max torque curve of the engine indexed by fc_map_spd
% Honda Published max horsepower & torque (Honda Insight Facts Book)
%		67 hp @ 5700 rpm (50 kW @ 596.9 rad/s)
%		66 lb-ft @ 5600 4800 rpm (89.5 N-m @ 502.7 rad/s)
%
% other max torque points taken from Honda UC Davis presentation (speed vs. torque graph)
%											 
%(original data given in lb-ft and converted to N-m)
fc_max_trq=[56.9 58.2 59.5 60.7 62.0 63.2 64.5 65.7 67.0 64.3 61.5 58.6]*1.355818; 

% (N*m), closed throttle torque of the engine (max torque that can be absorbed)
% indexed by fc_map_spd -- correlation from JDMA
fc_ct_trq=4.448/3.281*(-fc_disp)*61.02/24 * ...
   (9*(fc_map_spd/max(fc_map_spd)).^2 + 14 * (fc_map_spd/max(fc_map_spd)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (--), used to scale fc_map_spd to simulate a faster or slower running engine 
fc_spd_scale=1.0;
% (--), used to scale fc_map_trq to simulate a higher or lower torque engine
fc_trq_scale=1.0;
fc_pwr_scale=fc_spd_scale*fc_trq_scale;   % --  scale fc power

% user definable mass scaling function
fc_mass_scale_fun=inline('(x(1)*fc_trq_scale+x(2))*(x(3)*fc_spd_scale+x(4))*(fc_base_mass+fc_acc_mass)+fc_fuel_mass','x','fc_spd_scale','fc_trq_scale','fc_base_mass','fc_acc_mass','fc_fuel_mass');
fc_mass_scale_coef=[1 0 1 0]; % coefficients of mass scaling function


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STUFF THAT SCALES WITH TRQ & SPD SCALES (MASS AND INERTIA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_inertia=0.1*fc_pwr_scale;           % (kg*m^2), rotational inertia of the engine (unknown)
fc_max_pwr=(max(fc_map_spd.*fc_max_trq)/1000)*fc_pwr_scale; % kW     peak engine power

fc_base_mass=60;            % (kg), SAE Automotive Engineering, Oct 99
fc_acc_mass=0.8*fc_max_pwr;             % kg    engine accy's, electrics, cntrl's - assumes mass penalty of 0.8 kg/kW (from OTA report)
fc_fuel_mass=0.6*fc_max_pwr;            % kg    mass of fuel and fuel tank (from OTA report)
fc_mass=fc_base_mass+fc_acc_mass+fc_fuel_mass; % kg  total engine/fuel system mass
fc_ext_sarea=0.3*(fc_max_pwr/100)^0.67;       % m^2    exterior surface area of engine


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc_fuel_den=0.749*1000; % (g/l), density of the fuel 
fc_fuel_lhv=42.6*1000; % (J/g), lower heating value of the fuel

%the following was added for the new thermal modeling of the engine 12/17/98 ss and sb 
fc_tstat=96;                  % C      engine coolant thermostat set temperature (typically 95 +/- 5 C)
fc_cp=500;                    % J/kgK  ave cp of engine (iron=500, Al or Mg = 1000)
fc_h_cp=500;                  % J/kgK  ave cp of hood & engine compartment (iron=500, Al or Mg = 1000)
fc_hood_sarea=1.5;            % m^2    surface area of hood/eng compt.
fc_emisv=0.8;                 %        emissivity of engine ext surface/hood int surface
fc_hood_emisv=0.9;            %        emissivity hood ext
fc_h_air_flow=0.0;            % kg/s   heater air flow rate (140 cfm=0.07)
fc_cl2h_eff=0.7;              % --     ave cabin heater HX eff (based on air side)
fc_c2i_th_cond=500;           % W/K    conductance btwn engine cyl & int
fc_i2x_th_cond=500;           % W/K    conductance btwn engine int & ext
fc_h2x_th_cond=10;            % W/K    conductance btwn engine & engine compartment

% calc "predicted" exh gas flow rate and engine-out (EO) temp
fc_ex_pwr_frac=[0.40 0.30];                        % --   frac of waste heat that goes to exhaust as func of engine speed
fc_exflow_map=fc_fuel_map*(1+14.5);                % g/s  ex gas flow map:  for SI engines, exflow=(fuel use)*[1 + (stoic A/F ratio)]
fc_waste_pwr_map=fc_fuel_map*fc_fuel_lhv - T.*w;   % W    tot FC waste heat = (fuel pwr) - (mech out pwr)
spd=fc_map_spd;
fc_ex_pwr_map=zeros(size(fc_waste_pwr_map));       % W   initialize size of ex pwr map
for i=1:length(spd)
 fc_ex_pwr_map(i,:)=fc_waste_pwr_map(i,:)*interp1([min(spd) max(spd)],fc_ex_pwr_frac,spd(i)); % W  trq-spd map of waste heat to exh 
end
fc_extmp_map=fc_ex_pwr_map./(fc_exflow_map*1089/1000) + 20;  % W   EO ex gas temp = Q/(MF*cp) + Tamb (assumes engine tested ~20 C)

%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
fc_eff_scale=1;

% added to define fc_fuel_map_gpkWh for use with series powertrain (9-Aug-2001:mpo)
[T,w]=meshgrid(fc_map_trq, fc_map_spd);
fc_map_kW=T.*w/1000;
fc_fuel_map_gpkWh=fc_fuel_map./fc_map_kW*3600;
% if zero speed is in map, replace associated data with nearest BSFC*4
if min(fc_map_spd)<eps
    fc_fuel_map_gpkWh(1,:)=fc_fuel_map_gpkWh(2,:)*4;
end
% if zero torque is in map, replace associated data with nearest BSFC*4
if min(fc_map_trq)<eps
    fc_fuel_map_gpkWh(:,1)=fc_fuel_map_gpkWh(:,2)*4;
end

% clean up workspace
clear T w fc_waste_pwr_map fc_ex_pwr_map spd fc_map_kW

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%  FC_SI41_emis revision history %%%%%%%
% 06/23/98 (tm): created from a_dodg3l.m
% 07/06/98 (MC): corrected max power calc. in mass calc.
%                renamed fc_init_coolant_temp to fc_coolant_init_temp
% 07/17/98 (tm): file renamed FC_SI102.M
% 07/16/98 (SS): added variable fc_fuel_type under file id section
% 07/17/98 (tm): fc_fuel_den changed from 0.737 to 0.749 and fc_fuel_lhv changed from 42.7 to 42.6
% 07/30/98 (sb): added A/F ratio and split of waste heat variables
% 10/9/98 (vh,sb,ss): added pm and removed init conditions and added new exhaust variables
% 10/13/98 (MC): added variable fc_disp under file id section
%                fc_ct_trq computed according to correlation from JDMA, 5/98
% 10/13/98 (MC): updated equation for fc_ct_trq (convert from ft-lb to Nm)
% 12/17/98 ss,sb: added 12 new variables for engine thermal modelling.
% 01/25/99 (SB): modified thermal section to work with new BD, revised FC mass calc's
% 2/4/99: ss,sb changed fc_ext_sarea=0.3*(fc_max_pwr/100)^0.67  it was 0.3*(fc_max_pwr/100)
%		it now takes into account that surface area increases based on mass to the 2/3 power 
% 3/15/99:ss updated *_version to 2.1 from 2.0
% 7/6/99:tm removed clear statement for all *gpkWh data - now used in plots
% 7/9/99:tm cosmetic changes
% 11/03/99:ss updated version from 2.2 to 2.21
%
%%%%%% FC_INSIGHT_emis revision history %%%%%%%
%
% 10/26/99 (kjk): FC_INSIGHT_emis created from FC_SI41_emis.m
%  2/7/00  (kjk): modified max torque curve to UC Davis presentation data
% 01/31/01: vhj added fc_cold=0, added cold map variables, added +eps to avoid dividing by zero
% 02/26/01: vhj added variable definition of fc_o2_map (used in NOx absorber emis.)
% 07/30/01: mpo changed the order that fc_o2_map is created (original order was trying 
% ..............to create fc_o2_map using variables that hadn't been defined yet...)
% 07/30/01:tm added user definable mass scaling function mass=f(fc_spd_scale,fc_trq_scale,fc_base_mass,fc_acc_mass,fc_fuel_mass)
% 08/09/01: mpo added definition of fc_fuel_map_gpkWh for use with PTC_SER and others...
