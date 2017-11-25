%%%%% ADVISOR data file:  MC_INSIGHT_draft%
% Data source: Published Honda Insight Articles
%   
% Modified from MC_PM49 (Data Source: Honda R&D Americas) on: 2/7/00
%
% 49kW motor scaled down to 10kW
% Max torque points derived from published speed vs. torque for the Insight engine and engine with 
% integrated motor assist (Honda presentation at UC Davis Ultra-Clean Vehicle Workshop).  
% Torque range of motor scaled to 10kW motor
% All other data from MC_PM49 (Honda 49kW permanent magnet motor)
%
% By: Ken Kelly (NREL) ken_kelly@nrel.gov
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_version=2003;
mc_description='Preliminary Model of Honda 10 KW (continuous), permanent magnet motor/controller';
mc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
mc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: MC_INSIGHT_draft - ',mc_description]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPEED & TORQUE RANGES over which data is defined
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (N*m), torque range of the motor (scaled for 10kW motor)
mc_map_trq=[-36	-32	-28	-24	-20	-16	-12	-8	-4	0	4	8	16	20	24	28	32	36	43.5	46.5];

% (rad/s), speed range of the motor
mc_map_spd=[0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000 8500]*(2*pi)/60;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSSES AND EFFICIENCIES (taken from MC_PM49)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%					
mc_eff_map = 0.01*[...
54.17	56.09	59.74	62.16	64.71	64.88	66.49	68.30	63.07	63.07	87.76	84.71	79.49	78.10	76.56	75.09	73.90	71.33	63.88	59.75
54.17	56.09	59.74	62.16	64.71	64.88	66.49	68.30	63.07	63.07	87.76	84.71	79.49	78.10	76.56	75.09	73.90	71.33	63.88	59.75
70.00	71.77	75.20	78.37	80.62	82.73	84.62	85.31	80.23	80.23	85.98	86.96	87.34	86.64	85.45	84.73	84.03	83.26	80.81	77.35
79.08	80.25	82.73	84.76	86.91	87.56	87.27	87.20	80.24	80.24	87.45	88.53	89.23	89.37	88.36	88.08	87.98	87.33	85.65	82.47
83.36	84.27	86.74	88.36	89.34	90.20	90.39	89.14	81.05	81.05	90.54	90.31	90.33	90.42	90.38	90.13	89.86	89.38	87.95	87.25
86.38	87.62	88.89	90.36	90.71	91.07	91.08	89.20	83.52	83.52	88.41	91.83	91.51	91.56	91.43	91.28	91.02	91.23	90.67	90.67
90.83	90.83	91.04	91.41	92.60	91.95	92.22	90.68	84.90	84.90	90.61	91.38	92.36	92.29	92.35	92.16	92.12	93.52	93.61	93.61
92.78	92.78	92.78	92.78	93.06	93.10	92.21	91.79	84.92	84.92	90.37	92.79	93.59	94.31	94.42	94.68	95.24	95.42	95.42	95.42
93.49	93.49	93.49	93.49	93.49	93.74	93.45	91.19	86.24	86.24	93.14	94.56	95.69	95.67	96.02	96.07	95.88	95.88	95.88	95.88
94.37	94.37	94.37	94.37	94.37	94.24	93.97	91.80	85.70	85.70	90.78	93.73	96.00	96.13	96.39	96.23	96.23	96.23	96.23	96.23
95.03	95.03	95.03	95.03	95.03	94.26	94.29	91.51	82.22	82.22	89.23	93.00	95.29	96.05	96.05	96.05	96.05	96.05	96.05	96.05
94.75	94.75	94.75	94.75	94.75	94.75	93.06	90.49	81.37	81.37	87.75	92.89	95.47	95.83	95.83	95.83	95.83	95.83	95.83	95.83
94.07	94.07	94.07	94.07	94.07	94.07	93.27	89.98	80.69	80.69	86.69	92.47	95.18	95.40	95.40	95.40	95.40	95.40	95.40	95.40
93.84	93.84	93.84	93.84	93.84	93.84	92.95	89.38	79.83	79.83	86.00	92.05	95.06	95.48	95.48	95.48	95.48	95.48	95.48	95.48
93.05	93.05	93.05	93.05	93.05	93.05	93.05	89.16	78.99	78.99	85.00	91.13	94.50	94.70	94.70	94.70	94.70	94.70	94.70	94.70
92.12	92.12	92.12	92.12	92.12	92.12	92.12	88.90	77.41	77.41	84.26	90.75	94.21	94.21	94.21	94.21	94.21	94.21	94.21	94.21
91.27	91.27	91.27	91.27	91.27	91.27	91.27	88.14	76.08	76.08	82.89	90.31	93.49	93.49	93.49	93.49	93.49	93.49	93.49	93.49
90.47	90.47	90.47	90.47	90.47	90.47	90.47	87.80	75.97	75.97	82.22	89.96	93.17	93.17	93.17	93.17	93.17	93.17	93.17	93.17
];

% CONVERT EFFICIENCY MAP TO INPUT POWER MAP
[temp_T,temp_w]=meshgrid(mc_map_trq,mc_map_spd);
temp_mc_outpwr_map=temp_T.*temp_w;
temp_mc_losspwr_map=(1./mc_eff_map-1).*temp_mc_outpwr_map.*(temp_T>0)+...
   (mc_eff_map-1).*temp_mc_outpwr_map.*(temp_T<0);

%% to compute losses in entire operating range
%% ASSUME that losses at zero torque are the same as those at the lowest
%% positive torque, and
%% ASSUME that losses at zero speed are the same as those at the lowest positive
%% speed
temp_zti=find(mc_map_trq==0);
temp_zsi=find(mc_map_spd==0);
if ~isempty(temp_zti)
   temp_mc_losspwr_map(:,temp_zti)=temp_mc_losspwr_map(:,temp_zti+1);
end
if ~isempty(temp_zsi)
   temp_mc_losspwr_map(temp_zsi,:)=temp_mc_losspwr_map(temp_zsi+1,:);
end


%% compute input power (power req'd at electrical side of motor/inverter set)
mc_inpwr_map=temp_mc_outpwr_map+temp_mc_losspwr_map;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIMITS (taken from (MC_PM49)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mc_max_crrnt=400;	% maximum current draw for motor/controller set, A

mc_min_volts=60;	% minimum voltage for motor/controller set, V

% maximum continuous torque corresponding to speeds in mc_map_spd
% Calculated torque between 2500 and 8500 rpm from on constant 10kW power (torque=power/speed).
% This closely follows torque points derived from Honda Insight presentation of speed vs. torque by 
% subtracting engine torque from torque of engine with integrated motor assist.

mc_max_trq=[46.5	46.5	46.5	46.5	46.5	38.2	31.8	27.3	23.9	21.2	19.1	17.4	15.9	14.7	13.6	12.7	11.9	11.2];% (N*m)
mc_max_gen_trq=-1*mc_max_trq;

% maximum overtorque (beyond continuous, intermittent operation only)
% below is quoted (peak intermittent stall)/(peak continuous stall)
mc_overtrq_factor= 49/49;  % (--)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFAULT SCALING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (--), used to scale mc_map_spd to simulate a faster or slower running motor 
mc_spd_scale=1.0;

% (--), used to scale mc_map_trq to simulate a higher or lower torque motor
mc_trq_scale=1.0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA (from MC_PM49)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%													
mc_inertia=0.0507;    % (kg*m^2), rotor's rotational inertia                                                                                                                                        
mc_mass=(45+15);  % (kg), mass of motor and controller

% motor/controller thermal model 
% Note: These values are estimates by NREL, based on Westinghouse 75kW.  Thermal model was not available in A2.0.2
%       at the time Honda entered the original data.
mc_th_calc=1;                             % --     0=no mc thermal calculations, 1=do calc's
mc_cp=430;                                % J/kgK  ave heat capacity of motor/controller (estimate: ave of SS & Cu)
mc_tstat=45;                              % C      thermostat temp of motor/controler when cooling pump comes on
mc_area_scale=(mc_mass/91)^0.7;           % --     if motor dimensions are unknown, assume rectang shape and scale vs AC75
mc_sarea=0.4*mc_area_scale;               % m^2    total module surface area exposed to cooling fluid (typ rectang module)

%the following variable is not used directly in modelling and should always be equal to one
%it's used for initialization purposes
mc_eff_scale=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear temp*


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%%%%%%  MC_PM49 revision history %%%%%%%
% 3/11/99 (KW): converted data from A2.0.2 into A2.1 (added estimated thermal characteristics)
% 3/15/99:ss made sure *_version was updated to  2.1 from 2.0
% 7/29/99:mc removed the T=-0.1 Nm column from the map and removed code that
%            overrode efficiency in the -ive torque quadrant
% 11/03/99:ss updated version from 2.2 to 2.21

%%%%%% MC_PM10_insight revision history %%%%%%%
%
% 2/7/00 (kjk): MC_PM10_insight created from MC_PM49.m
% 11/1/00:tm activated max gen trq data
% 2/2/01:tm revised definition of max gen trq to correspond to max trq curve - old data reference MC_PM49

% Begin added by ADVISOR 3.2 converter: 30-Jul-2001
mc_mass_scale_coef=[1 0 1 0];

mc_mass_scale_fun=inline('(x(1)*mc_trq_scale+x(2))*(x(3)*mc_spd_scale+x(4))*mc_mass','x','mc_spd_scale','mc_trq_scale','mc_mass');

% End added by ADVISOR 3.2 converter: 30-Jul-2001