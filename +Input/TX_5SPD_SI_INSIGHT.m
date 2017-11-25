% ADVISOR data file:  TX_5SPD_SI_insight.m
%
% Modified TX_5SPD_SI to reflect published Honda Insight gear ratios
% Data Source: Car & Driver, Jan '00
% All other data from TX_5SPD_SI (Data source: Mass was taken from "Automotive Technologies 
% 											 to Improve Fuel Economy to 2015" prepared for the Office 
% 										 	 of Technology Assessment by Energy and Environmental 
% 											 Analysis, Inc. Draft report Dec. 1994.
% 											 Gear ratios from ANL for Saturn and from VW brochure for Jetta.)
%
% Data confirmation:
%
% Notes:
% This file defines a 5-speed gearbox by defining gear ratios and gear number,
% and calling TX_VW to define loss characteristics.
%
% Created on: 2/7/00
% By:  Ken Kelly, NREL, ken_kelly@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Description of type of transmission(important in determining what block diagram
%												to run in gui_run_simulation)
%added 12/22/98  types will be: 'manual 1 speed', 'manual 5 speed','cvt','auto 4 speed'
tx_type='manual 5 speed';
tx_version=2003;
disp('Data Loaded: TX_5SPD_SI_INSIGHT - 5-speed transmission for the Honda Insight');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gear ratios taken from data published by Car & Driver 1/00

gb_ratio=[3.46  1.75  1.10  0.86  0.71]*3.21; % 
gb_gears_num=5;


%TX_VW % FILE ID, LOSSES
load tx_insight_26_50_5; % load the tx_map_spd, tx_map_trq, and tx_eff_map efficiency/loss info
% ...for this transmission; note: this data generated using insight gear ratios with vw equation parameters
% ...data generated using tx_eff_mapper.m function in <ADVISOR main directory>/gui. Type "help tx_eff_mapper" 
% ...for details.

gb_mass= 41; % (kg), Honda Insight Facts Book (mass of 5 speed manual)


%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
gb_eff_scale=1;
gb_inertia=0;	% (kg*m^2), gearbox rotational inertia measured at input; unknown

% trq and speed scaling parameters
gb_spd_scale=1;
gb_trq_scale=1; 

%final drive variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fd_loss=0;    % (Nm), constant torque loss in final drive, measured at input


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fd_ratio=1;   % (--), =(final drive input speed)/(f.d. output speed)
fd_inertia=0; % (kg*m^2), rotational inertia of final drive, measured at input
fd_mass=110/2.205; % (kg), mass of the final drive - 1990 Taurus, OTA report

tx_mass=gb_mass+fd_mass;% (kg), mass of the gearbox + final drive=(transmission)

% user definable mass scaling relationship
tx_mass_scale_fun=inline('(x(1)*gb_trq_scale+x(2))*(x(3)*gb_spd_scale+x(4))*(fd_mass+gb_mass)','x','gb_spd_scale','gb_trq_scale','fd_mass','gb_mass');
tx_mass_scale_coef=[1 0 1 0]; % coefficients for mass scaling relationship

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%  TX_5SPD_SI revision history %%%%%%%
% 08/28/98:tm gb_mass added
% 9/30/98:ss added fd variables and added tx_mass
% 10/16/98:ss renamed to TX_5SPD, was GB_5SPD
% 12/22/98:ss added variable tx_type to determine what block diagram to run.
% 04/01/99:mc started w/ TX_5SPD, updated gb_ratio value
% 11/03/99:ss updated version from 2.2 to 2.21
%
%%%%%% TX_5SPD_SI_INSIGHT revision history %%%%%
%
% 2/7/00 (kjk): TX_5SPD_SI_INSIGHT created from TX_5SPD_SI.m
% 9-July-2001 (mpo): insight-specific efficiency map now loads from *.mat file for efficiency via lookup-table
% 10-July-2001(mpo): changed file such that it now runs independently (no need to call TX_VW.m)
% 7/30/01:tm added transmission mass scaling function mass=f(gb_spd_scale,gb_trq_scale,fd_mass,gb_mass)