%gui_post_process   ADVISOR 2002
%	This file calculates average efficiencies, 
%	energy balance, input-output powers, etc.  
%  Results of the calculations are displayed using results figure when
%  clicking on the energy balance button
global vinf
drivetrain=vinf.drivetrain.name;

global fc_retard_kj tc_in_regen_kj tc_out_regen_kj tc_regen_loss_kj tc_regen_eff
global gb_in_regen_kj gb_out_regen_kj gb_regen_loss_kj gb_regen_eff fd_in_regen_kj fd_out_regen_kj fd_regen_loss_kj fd_regen_eff
global wh_in_regen_kj wh_out_regen_kj wh_regen_loss_kj wh_regen_eff
global aero_kj rolling_kj
global clutch_regen_in_kj clutch_regen_out_kj clutch_regen_loss_kj clutch_regen_eff
global htc_regen_in_kj htc_regen_out_kj htc_regen_loss_kj htc_regen_eff

%define some new vectors that are in metric units
kpha=mpha*1.6093;
liters=gal*3.785;
cyc_kph_r=cyc_mph_r*1.6093;


%Warning initialization
warn_index=1; %set the index into the warnings cell array to 1
clear warnings; %clear any previous warnings from previous runs
warnings{1}='none'; %start with 'none' in first entry field

%---------Total distance travelled----------------
dist=trapz(t,mpha)/3600; %miles; 3600 is conversion from hours to seconds
%**************

%Display warning if missed trace by too much
trace_miss_allowance=2.0; %mph
trace_miss=abs(mpha-cyc_mph_r);%take absolute value
missed_trace=0; %added 6/23/99 by ss for return back to optimization routine

if find(trace_miss>trace_miss_allowance); %true if any element is greater than allowance
    warnings{warn_index}=['Missed Trace by > ',num2str(trace_miss_allowance),' mph (',num2str(round(10*trace_miss_allowance*1.6093)/10),' km/h)'] ;
    warn_index=warn_index+1;
    missed_trace=1; %added 6/23/99 by ss for return back to optimization routine
end

%---------Fuel Economy-----------------------
% compute fuel economy if fuel has been used.  Otherwise add string 
% to warnings that states that no fuel was used during 
% the simulation run
if ~strcmp(drivetrain,'ev')
    if max(gal)~=0
        mpg = dist/max(gal); 
    elseif strcmp(vinf.cycle.soc,'off') %do not give no fuel warning when SOC correct is on
        warnings{warn_index}='No fuel used.  Your vehicle ran all-electric.';
        warn_index=warn_index+1;
        mpg=0; 
    end
    %only calculate if mpg exists ss:11/10/99 found when running linear soc correct on default series.
    if exist('mpg')
        if exist('cs_charge_deplete_bool')&(cs_charge_deplete_bool>0)
            sim('bd_btyrc',100000)
            gas_lhv=42600;
            gas_dens=749;
            kWhpgal=33.44; % kWh/gal of gasoline
            %charger_eff=1.0; % 100% efficient to be consistent with EV calc
            charger_eff=0.85; % to account for wall charger efficient
            mpgge=max(dist)/(max(gal)/(gas_lhv/fc_fuel_lhv*gas_dens/fc_fuel_den)+recharge_kWh/charger_eff/kWhpgal);
        else
            gas_lhv=42600;
            gas_dens=749;
            mpgge=mpg*gas_lhv/fc_fuel_lhv*gas_dens/fc_fuel_den;%gasoline equivalent
        end
    end
    clear gas_dens gas_lhv charger_eff recharge_kWh kWhpgal
end
if strcmp(drivetrain,'ev')
    mpg=0;
    dE_dt=ess_pwr_out_a+ess_pwr_loss_a; %total power obtained from batteries
    E_J=trapz(t,dE_dt.*(dE_dt>0)); %total energy used from batteries
    if ~exist('ess_coulombic_eff'), ess_coulombic_eff=1; end %added for alternative battery models where coul. eff not defined
    E_J=E_J/mean(mean(ess_coulombic_eff)); %accounts for coulombic losses--mpo 26-april-2002: the extra 'mean' is used for cases where ess_coulombic_eff might be 2-d
    mpgge=dist/E_J*42600*749/.264172; %42600=lhv of fuel(J/g), 749=density of fuel(g/l), .264172gal/l
end
%************

%---------Emissions summary-------------------
%emmissions
% if ~strcmp(drivetrain,'ev')&dist>0
%     hc_gpm=trapz(t,emis(:,1))/dist;% grams/mile
%     co_gpm=trapz(t,emis(:,2))/dist;%grams/mile
%     nox_gpm=trapz(t,emis(:,3))/dist;%grams/mile
%     pm_gpm=trapz(t,emis(:,4))/dist;%grams/mile
% else
%     hc_gpm=0;
%     co_gpm=0;
%     nox_gpm=0;
%     pm_gpm=0;
% end
%*************


%||||||||||||ENERGY ACCOUNTING SECTION FOLLOWS|||||||||||


%----Amount of FUEL energy in (Joules)
%equals amount of gallons used times fuel energy per gallon
if ~strcmp(drivetrain,'ev')
    fuel_energy_per_gal=fc_fuel_lhv*fc_fuel_den*3.785; %J/gal
    fuel_in_kj=max(gal)*fuel_energy_per_gal/1000; %kJ
    %if no fuel used then put NaN for fuel_in_kj
    if fuel_in_kj==0
        fuel_in_kj=NaN;
    end
elseif strcmp(drivetrain,'ev')  
    fuel_in_kj=NaN;
end
%----------------------------


%----Fuel Converter: Useful energy out and lost energy
%followed by average efficiency calculation
%if there was fuel used
if ~isnan(fuel_in_kj)
    if exist('acc_mech_pwr_in_a')
        acc_mech_load_kj=trapz(t,acc_mech_pwr_in_a)/1000;
    else
        acc_mech_load_kj=0;
    end
    if exist('fc_trq_out_a')
        if exist('acc_mech_pwr_in_a') & ~exist('acc_mech_pwr_a') %mpo[6-MAR-2002] old model
            fc_out_kj=trapz(t,fc_trq_out_a.*fc_spd_out_a.*(fc_trq_out_a>0))/1000 + acc_mech_load_kj;
        else
            fc_out_kj=trapz(t,fc_trq_out_a.*fc_spd_out_a.*(fc_trq_out_a>0))/1000; %mpo[6-MAR-2002] fc_trq_out_a now includes mech loads
        end
    else
        if exist('acc_mech_pwr_in_a') & ~exist('acc_mech_pwr_a') %mpo[6-MAR-2002] old model
            fc_out_kj=trapz(t,fc_pwr_out_a.*(fc_pwr_out_a>0))/1000 + acc_mech_load_kj; %mpo[6-MAR-2002] fc_pwr_out_a now includes mech loads
        else
            fc_out_kj=trapz(t,fc_pwr_out_a.*(fc_pwr_out_a>0))/1000; %mpo[6-MAR-2002] fc_pwr_out_a now includes mech loads
        end
    end
    fc_loss_kj=fuel_in_kj-fc_out_kj;
    fc_eff_avg=fc_out_kj/fuel_in_kj;
    if exist('fc_trq_out_a')
        fc_retard_kj=-trapz(t,fc_trq_out_a.*fc_spd_out_a.*(fc_trq_out_a<0))/1000;
    else
        fc_retard_kj=-trapz(t,fc_pwr_out_a.*(fc_pwr_out_a<0))/1000;
    end
else
    fc_retard_kj=NaN;
    fc_out_kj=NaN;
    fc_loss_kj=NaN;
    fc_eff_avg=NaN;
end
%**************************

%---clutch: Energy computations
%if strcmp(vinf.drivetrain.name,'conventional')|strcmp(vinf.drivetrain.name,'parallel')|strcmp(vinf.drivetrain.name,'parallel_sa')
if exist('clutch_pwr_in_a') & (size(clutch_pwr_in_a)==size(t))
    clutch_in_kj=trapz(t,clutch_pwr_in_a.*(clutch_pwr_in_a>0))/1000;
    clutch_out_kj=trapz(t,clutch_pwr_out_a.*(clutch_pwr_out_a>0))/1000;
    clutch_loss_kj=clutch_in_kj-clutch_out_kj;
    if clutch_in_kj==0
        clutch_in_kj=NaN;
    end
    clutch_eff=clutch_out_kj/clutch_in_kj;
    
    %maybe add braking effect of clutch here.
    clutch_regen_in_kj=-trapz(t,clutch_pwr_out_a.*(clutch_pwr_out_a<0))/1000;
    if exist('clutch_state') & (size(clutch_state)==size(t)) %mpo[6-MAR-2002]clutch cannot regen if disengaged...
        clutch_regen_out_kj=-trapz(t,clutch_pwr_in_a.*and(clutch_pwr_in_a<0,clutch_state~=1))/1000;
    else
        clutch_regen_out_kj=-trapz(t,clutch_pwr_in_a.*(clutch_pwr_in_a<0))/1000;
    end
    clutch_regen_loss_kj=clutch_regen_in_kj-clutch_regen_out_kj;
    if clutch_regen_in_kj==0
        clutch_regen_in_kj=NaN;
    end
    clutch_regen_eff=clutch_regen_out_kj/clutch_regen_in_kj;
    
else
    clutch_in_kj=NaN;
    clutch_out_kj=NaN;
    clutch_loss_kj=NaN;
    clutch_eff=NaN;
    clutch_regen_in_kj=NaN;
    clutch_regen_out_kj=NaN;
    clutch_regen_loss_kj=NaN;
    clutch_regen_eff=NaN;
    
end
%else
%   clutch_in_kj=NaN;
%   clutch_out_kj=NaN;
%   clutch_loss_kj=NaN;
%   clutch_eff=NaN;
%      clutch_regen_in_kj=NaN;
%      clutch_regen_out_kj=NaN;
%      clutch_regen_loss_kj=NaN;
%      clutch_regen_eff=NaN;
%end

%---hydraulic torque converter
if exist('htc_trq_in_a')
    htc_in_kj=trapz(t,htc_trq_in_a.*htc_spd_in_a.*(htc_trq_in_a>0))/1000;
    htc_out_kj=trapz(t,htc_trq_out_a.*htc_spd_out_a.*(htc_trq_out_a>0))/1000;
    htc_loss_kj=htc_in_kj-htc_out_kj;
    htc_eff=htc_out_kj/htc_in_kj;
    
    %maybe add braking effect of htc here
    htc_regen_in_kj=-trapz(t,htc_trq_out_a.*htc_spd_out_a.*(htc_trq_out_a<0))/1000;
    htc_regen_out_kj=-trapz(t,htc_trq_in_a.*htc_spd_in_a.*(htc_trq_in_a<0))/1000;
    htc_regen_loss_kj=htc_regen_in_kj-htc_regen_out_kj;
    htc_regen_eff=htc_regen_out_kj/(htc_regen_in_kj+eps);
    
else
    htc_in_kj=NaN;
    htc_out_kj=NaN;
    htc_loss_kj=NaN;
    htc_eff=NaN;
    htc_regen_in_kj=NaN;
    htc_regen_out_kj=NaN;
    htc_regen_loss_kj=NaN;
    htc_regen_eff=NaN;
end

%----Generator/Controller: energy in, useful energy out and lost energy
% followed by average efficiency calculation if the generator was used
%if strcmp(vinf.drivetrain.name,'series')
if exist('gc_trq_in_a') & ~exist('gc_trq_out_a') %changed this on 1/5/01 ss for prius
    gc_in_kj=trapz(t,gc_spd_in_a.*gc_trq_in_a)/1000;
    if gc_in_kj==0
        gc_in_kj=NaN;
    end   
    gc_out_kj=trapz(t,gc_pwr_out_a)/1000;
    gc_loss_kj=gc_in_kj-gc_out_kj;
    gc_eff=gc_out_kj/gc_in_kj ;
else
    gc_in_kj=NaN;
    gc_out_kj=NaN;
    gc_loss_kj=NaN;
    gc_eff=NaN;
end

if strcmp(vinf.drivetrain.name,'prius_jpn')
    gc_in_kj=trapz(t,gc_pwr_in_a.*(gc_pwr_in_a>0))/1000;
    % kilojoules
    gc_out_kj=trapz(t,(gc_trq_out_a.*gc_spd_out_a).*((gc_trq_out_a.*gc_spd_out_a)>0))/1000;
    if gc_in_kj==0
        gc_in_kj=NaN;
    end
    gc_loss_kj=gc_in_kj-gc_out_kj;
    gc_eff=gc_out_kj/gc_in_kj;
    
end; %stcmp(vinf.drivetrain.name,'prius_jpn')   



%----Torque Coupling:   Energy Computations
%if strcmp(vinf.drivetrain.name,'parallel')
if exist('tc_pwr_in_a') %changed this on 6/25/99 for prius ss
    
    %the following two statements are the old ones
    %tc_in_kj=trapz(t,tc_pwr_in_a)/1000;
    %tc_out_kj=trapz(t,tc_trq_out_a.*tc_spd_out_a)/1000;
    
    %the following statements are in testing to more accurately calculate power 
    %seperately during normal power flow and during regenerative braking.
    tc_in_kj=trapz(t,tc_pwr_in_a.*(tc_pwr_in_a>0))/1000;
    tc_out_kj=trapz(t,(tc_trq_out_a.*tc_spd_out_a).*(tc_trq_out_a>0))/1000;
    tc_in_regen_kj=-trapz(t,tc_trq_out_a.*tc_spd_out_a.*(tc_trq_out_a<0))/1000;
    tc_out_regen_kj=-trapz(t,tc_pwr_in_a.*(tc_pwr_in_a<0))/1000;
    tc_regen_loss_kj=tc_in_regen_kj-tc_out_regen_kj;
    if tc_in_regen_kj==0
        tc_in_regen_kj=NaN;
    end
    tc_regen_eff=tc_out_regen_kj/tc_in_regen_kj;
    % tc efficiency during regeneration
    %end of testing section
    
    
    tc_loss_kj=tc_in_kj-tc_out_kj;
    tc_eff=tc_out_kj/tc_in_kj;
else
    tc_in_kj=NaN;
    tc_out_kj=NaN;
    
    %following three statements are new
    tc_in_regen_kj=NaN;
    tc_out_regen_kj=NaN;
    tc_regen_loss_kj=NaN;
    tc_regen_eff=NaN;
    
    tc_loss_kj=NaN;
    tc_eff=NaN;
end 


%----Motor/Controller: energy in, useful energy out and lost energy
% followed by average efficiency calculation if the motor was used
%special attention to the use of the motor as a generator 
%(by taking note of negative values for mc_trq_out_a.)

%if strcmp(vinf.drivetrain.name,'parallel_sa')|strcmp(vinf.drivetrain.name,'parallel')|strcmp(vinf.drivetrain.name,'series')|strcmp(drivetrain,'ev')|strcmp(drivetrain,'fuel_cell')|strcmp(drivetrain,'prius_jpn')
if exist('mc_trq_out_a')   % kilojoules
    mc_in_kj=trapz(t,mc_pwr_in_a.*(mc_pwr_in_a>0))/1000;   % kilojoules
    mc_out_kj=trapz(t,(mc_trq_out_a.*mc_spd_out_a).*(mc_trq_out_a>0))/1000;
    if mc_in_kj==0
        mc_in_kj=NaN;
    end
    mc_loss_kj=mc_in_kj-mc_out_kj;
    mc_eff=mc_out_kj/mc_in_kj;
    
    %the generator mode of the motor
    mot_as_gen_in_kj=-trapz(t,mc_trq_out_a.*mc_spd_out_a.*(mc_trq_out_a<0))/1000;
    mot_as_gen_out_kj=-trapz(t,mc_pwr_in_a.*(mc_pwr_in_a<0))/1000;
    mot_as_gen_loss_kj=mot_as_gen_in_kj-mot_as_gen_out_kj;
    if mot_as_gen_in_kj==0
        mot_as_gen_in_kj=NaN;
    end
    mot_as_gen_eff=mot_as_gen_out_kj/(mot_as_gen_in_kj+eps);
    % motor efficiency when acting as a generator
end

%----Energy Storage   loss/eff
%if ~strcmp(vinf.drivetrain.name,'conventional') & ess_on & isfield(vinf,'energy_storage')
if exist('ess_pwr_out_a') & ess_on %& isfield(vinf,'energy_storage')
    %%%%%% ESS efficiency ------------------------
    % ess_pwr_out_a = actual electrical power output by the energy storage system
    dE_dt_stored=-ess_pwr_out_a-ess_pwr_loss_a;
    into_storage_kj=trapz(t,dE_dt_stored.*(dE_dt_stored>0))/1000;  %useful energy coming into the batteries
    out_of_storage_kj=-trapz(t,dE_dt_stored.*(dE_dt_stored<0))/1000;  %energy leaving the batteries when power is flowing out (useful out+losses out)
    ess_in_kj=-trapz(t,ess_pwr_out_a.*(ess_pwr_out_a<0))/1000;  %all energy coming into the batteries
    ess_out_kj=trapz(t,ess_pwr_out_a.*(ess_pwr_out_a>0))/1000;  %useful energy leaving the batteries
    ess_stored_kj=into_storage_kj-out_of_storage_kj;
    ess_loss_kj=ess_in_kj-ess_out_kj-ess_stored_kj;
    eta_ess_dis=ess_out_kj/(out_of_storage_kj+eps);	% discharge efficiency
    if ess_in_kj>0 
        eta_ess_chg=into_storage_kj/ess_in_kj;		% recharge efficiency, accounting for losses correctly??
    else %for ev case, no input charge
        eta_ess_chg=1;
    end
    ess_eff=eta_ess_dis*eta_ess_chg;			% round-trip efficiency
end

if ~strcmp(vinf.drivetrain.name,'conventional')
    
    %amount of energy into battery from regen
    % while vehicle is decelerating, find out total energy to motor and fraction coming from fc.  Then
    % use this fraction to determine how much is regen from amount stored in battery during the deceleration
    % find out at what times the vehicle is decelerating
    %regen_times=veh_force_a<0;
end; %end if ~strcmp(vinf.drivetrain.name,'conventional')



%-----Gearbox loss/eff
if exist('gb_spd_in_a')
    %following two statements are the old ones.
    %gb_in_kj=trapz(t,gb_spd_in_a.*gb_trq_in_a)/1000;
    %gb_out_kj=trapz(t,gb_spd_out_a.*gb_trq_out_a)/1000;
    
    %the following statements are in testing to more accurately calculate power 
    %seperately during normal power flow and during regenerative braking.
    gb_in_kj=trapz(t,gb_spd_in_a.*gb_trq_in_a.*(gb_trq_in_a>0))/1000;
    gb_out_kj=trapz(t,(gb_trq_out_a.*gb_spd_out_a).*(gb_trq_out_a>0))/1000;
    gb_in_regen_kj=-trapz(t,gb_spd_out_a.*gb_trq_out_a.*(gb_trq_out_a<0))/1000;
    gb_out_regen_kj=-trapz(t,gb_trq_in_a.*gb_spd_in_a.*(gb_trq_in_a<0))/1000;
    gb_regen_loss_kj=gb_in_regen_kj-gb_out_regen_kj;
    if gb_in_regen_kj==0
        gb_in_regen_kj=NaN;
    end
    gb_regen_eff=gb_out_regen_kj/gb_in_regen_kj;
    % gb efficiency during regeneration
    %end of testing section
    
    
    gb_loss_kj=gb_in_kj-gb_out_kj;
    gb_eff=gb_out_kj/gb_in_kj;
else
    gb_in_kj=NaN;
    gb_out_kj=NaN;
    gb_in_regen_kj=NaN;
    gb_out_regen_kj=NaN;
    gb_eff=NaN;
    gb_regen_eff=NaN;
    gb_loss_kj=NaN;
    gb_regen_loss_kj=NaN;
end

%----Final Drive loss/eff
%fd_in_kj=trapz(t,fd_spd_in_a.*fd_trq_in_a)/1000;
%fd_out_kj=trapz(t,fd_spd_out_a.*fd_trq_out_a)/1000;

%the following statements are in testing to more accurately calculate power 
%seperately during normal power flow and during regenerative braking.
fd_in_kj=trapz(t,fd_spd_in_a.*fd_trq_in_a.*(fd_trq_in_a>0))/1000;
fd_out_kj=trapz(t,(fd_trq_out_a.*fd_spd_out_a).*(fd_trq_out_a>0))/1000;
fd_in_regen_kj=-trapz(t,fd_spd_out_a.*fd_trq_out_a.*(fd_trq_out_a<0))/1000;
fd_out_regen_kj=-trapz(t,fd_trq_in_a.*fd_spd_in_a.*(fd_trq_in_a<0))/1000;
fd_regen_loss_kj=fd_in_regen_kj-fd_out_regen_kj;
if fd_in_regen_kj==0
    fd_in_regen_kj=NaN;
end
fd_regen_eff=fd_out_regen_kj/fd_in_regen_kj;
% fd efficiency during regeneration
%end of testing section

fd_loss_kj=fd_in_kj-fd_out_kj;
fd_eff=fd_out_kj/fd_in_kj;

%----Braking loss/eff
brake_loss_kj=trapz(t,wh_brake_loss_pwr)/1000;

%----Wheel/Axle loss/eff
%wh_in_kj=trapz(t,wh_spd_a.*wh_trq_a)/1000;
%wh_out_kj=trapz(t,veh_force_a.*veh_spd_a)/1000+brake_loss_kj;

%the following statements are in testing to more accurately calculate power 
%seperately during normal power flow and during regenerative braking.
wh_in_kj=trapz(t,wh_spd_a.*wh_trq_a.*(wh_trq_a>0))/1000;
wh_out_kj=trapz(t,(veh_force_a.*veh_spd_a).*(veh_force_a>0))/1000;
wh_in_regen_kj=-trapz(t,veh_force_a.*veh_spd_a.*(veh_force_a<0))/1000;
wh_out_regen_kj=-trapz(t,wh_spd_a.*wh_trq_a.*(wh_trq_a<0))/1000+brake_loss_kj;
wh_regen_loss_kj=wh_in_regen_kj-wh_out_regen_kj;
if wh_in_regen_kj==0
    wh_in_regen_kj=NaN;
end
wh_regen_eff=wh_out_regen_kj/wh_in_regen_kj;
% wh efficiency during regeneration
%end of testing section


wh_loss_kj=wh_in_kj-wh_out_kj;
wh_eff=wh_out_kj/wh_in_kj;

%----Road Load (rolling, air drag) loss/eff
if exist('Fr_out')
    Fr = Fr_out.signals.values;
    rolling_kj=trapz(t,veh_spd_a.*Fr)/1000;
else 
    rolling_kj=trapz(t,veh_spd_a.*(veh_mass+veh_cargo_mass_vs_time).*(veh_gravity*(wh_1st_rrc+wh_2nd_rrc.*veh_spd_a)))/1000;
    % 28 June 2001--mpo--changing veh_mass calculation to account for fact that a variable cargo...
    % ...load may have been used
end

aero_kj=trapz(t,(0.5*veh_CD*veh_FA*veh_air_density*veh_spd_a.^3))/1000;

road_load_kj=trapz(t,veh_spd_a.*veh_force_a)/1000;%not used anymore?


%----aux loads
if exist('acc_elec_pwr_in_a')&exist('acc_mech_pwr_in_a')
    aux_load_in_kj=trapz(t,acc_mech_pwr_in_a+acc_elec_pwr_in_a)/1000; 
    aux_load_out_kj=trapz(t,acc_mech_pwr_out_a+acc_elec_pwr_out_a)/1000;%mpo[6-MAR-2002]out=in? set to zero below...
elseif exist('acc_elec_pwr_in_a')
    aux_load_in_kj=trapz(t,acc_elec_pwr_in_a)/1000;
    aux_load_out_kj=trapz(t,acc_elec_pwr_out_a)/1000;
elseif exist('acc_mech_pwr_in_a')
    aux_load_in_kj=trapz(t,acc_mech_pwr_in_a)/1000;
    aux_load_out_kj=trapz(t,acc_mech_pwr_out_a)/1000;
else
    aux_load_in_kj=0;
    aux_load_out_kj=0;
end
%aux_load_loss_kj=aux_load_in_kj; % removed tm:10/27/00
aux_load_out_kj=0; % no useful work % added tm:10/27/00
aux_load_loss_kj=aux_load_in_kj-aux_load_out_kj; % added tm:10/27/00
aux_load_eff=aux_load_out_kj/(aux_load_in_kj+eps);
%for now set these to NaN
%aux_load_in_kj=NaN; % removed tm:10/27/00
%aux_load_out_kj=NaN; % removed tm:10/27/00
%aux_load_eff=NaN; % removed tm:10/27/00

% Summary Calculations
% added: tm 10/27/00
road_load_pos_kj=trapz(t,veh_spd_a.*veh_force_a.*(veh_force_a>0))/1000;
road_load_neg_kj=-trapz(t,veh_spd_a.*veh_force_a.*(veh_force_a<0))/1000;
%if ~strcmp(drivetrain,'conventional') % first cut at calculating true regen
if isfield(vinf,'energy_storage') & exist('ess_pwr_out_a') %tm:2/6/01 added to allow custom to be a conventional vehicle
    if isfield(vinf,'fuel_converter')%~strcmp(drivetrain,'ev') % first cut at calculating true regen
        if strcmp(vinf.fuel_converter.ver,'fcell') % first cut at calculating true regen
            fc_charging_during_regen_kj=trapz(t,fc_pwr_out_a.*(veh_force_a<0).*(fc_pwr_out_a>0));
        else
            fc_charging_during_regen_kj=trapz(t,fc_trq_out_a.*fc_spd_out_a.*(veh_force_a<0).*(fc_trq_out_a>0));
        end
    else
        fc_charging_during_regen_kj=0;
    end
    % need to include an efficiency of clutch, torque coupling, and motor
    ess_in_during_regen_kj=-trapz(t,ess_pwr_out_a.*(veh_force_a<0));
    % check to make sure this is after coloumbic losses
else
    ess_in_during_regen_kj=0; 
    fc_charging_during_regen_kj=0;
end
regen_captured_kj=ess_in_during_regen_kj-fc_charging_during_regen_kj;
regen_available_kj=road_load_neg_kj;
regen_eff=regen_captured_kj/(regen_available_kj+eps);
total_energy_in_kj=fuel_in_kj+regen_captured_kj;
total_energy_out_kj=road_load_pos_kj+aux_load_out_kj;
total_eff=total_energy_out_kj/(total_energy_in_kj+eps);
% end added: tm 10/27/00


%---------Warnings------------
%There may be several or no warnings to display regarding the simulation run
%Initialize the warnings index and string(note: that each time a  warning is added the index
%needs to be increased by 1.
