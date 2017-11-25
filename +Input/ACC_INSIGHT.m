% ADVISOR data file:  ACC_INSIGHT.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% Defines standard accessory load data for use with a hybrid in ADVISOR.
%
% Created on: 14-Jul-2000
% By:  ss, NREL
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
acc_description='200-W constant electric load - based on data from the HONDA INSIGHT tests';
acc_version=2003; % version of ADVISOR for which the file was generated
acc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
acc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: ACC_INSIGHT - ',acc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOSS parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
acc_mech_pwr=0;  % (W), mechanical accessory load, drawn from the engine
acc_elec_pwr=200; % (W), electrical acc. load, drawn from the voltage/power bus
acc_mech_eff=1; %efficiency of accessory
acc_elec_eff=1; %
acc_mech_trq=0; % (Nm), constant accessory torque load on engine

vinf.AuxLoads=load('Default_aux.mat');
vinf.AuxLoadsOn=0;

acc_dcdc_eff=1; % dc to dc converter efficiency applied to the 14v loads

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%7/14/00 ss: created from acc_hybrid as a placeholder for INSIGHT.
%2/9/01 kjk: modified acc_elec_pwr based on NREL test data
%8/3/01 ar: modified acc_elec_pwr based on NREL test data
%8/3/01 ar: changed version number for 3.2
% 4/18/02:ab updated to load aux loads


