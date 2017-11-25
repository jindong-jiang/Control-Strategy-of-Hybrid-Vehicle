% INSIGHT_defaults_in.m  ADVISOR 3.1 input file created: 07-February-2001 11:00:00

global vinf 

vinf.name='INSIGHT_defaults_in';
vinf.drivetrain.name='insight';
vinf.fuel_converter.name='FC_INSIGHT';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='si';
vinf.torque_coupling.name='TC_INSIGHT';
vinf.motor_controller.name='MC_INSIGHT_draft';
vinf.energy_storage.name='ESS_NIMH6';
vinf.energy_storage.ver='rint';
vinf.energy_storage.type='nimh';
vinf.transmission.name='TX_5SPD_SI_INSIGHT';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='WH_INSIGHT';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_INSIGHT';
vinf.exhaust_aftertreat.name='EX_SI_CC';
vinf.powertrain_control.name='PTC_INSIGHT';
vinf.powertrain_control.ver='insight';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_INSIGHT';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';
vinf.variables.name{1}='ess_module_num';
vinf.variables.value(1)=20;
vinf.variables.default(1)=0;
vinf.variables.name{2}='veh_mass';
vinf.variables.value(2)=1000;
vinf.variables.default(2)=962;