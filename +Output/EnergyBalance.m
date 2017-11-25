% bal.m
% Uses the results developed by gui_post_process.m to compare energy input to
% losses.  Displays imbalance in kJ.

% collect inputs
input_kj=0;
if ~isnan(fuel_in_kj)
   input_kj=input_kj+fuel_in_kj;
end
if exist('ess_stored_kj') & ~isnan('ess_stored_kj')
   input_kj=input_kj-ess_stored_kj;
end

% collect losses
loss_kj=0;
if ~isnan(fc_loss_kj)
   loss_kj=loss_kj+fc_loss_kj;
end
if ~isnan(fc_retard_kj)
   loss_kj=loss_kj+fc_retard_kj;
end
if ~isnan(clutch_loss_kj)
   loss_kj=loss_kj+clutch_loss_kj;
end
if ~isnan(htc_loss_kj)
   loss_kj=loss_kj+htc_loss_kj;
end
if ~isnan(htc_regen_loss_kj)
   loss_kj=loss_kj+htc_regen_loss_kj;
end
if ~isnan(gc_loss_kj)
   loss_kj=loss_kj+gc_loss_kj;
end
if ~isnan(tc_regen_loss_kj)
   loss_kj=loss_kj+tc_regen_loss_kj;
end
if ~isnan(tc_loss_kj)
   loss_kj=loss_kj+tc_loss_kj;
end
if exist('mc_loss_kj') & ~isnan(mc_loss_kj)
   loss_kj=loss_kj+mc_loss_kj;
end
if exist('mot_as_gen_loss_kj') & ~isnan(mot_as_gen_loss_kj)
   loss_kj=loss_kj+mot_as_gen_loss_kj;
end
if exist('ess_loss_kj') & ~isnan(ess_loss_kj)
   loss_kj=loss_kj+ess_loss_kj;
end
if ~isnan(gb_regen_loss_kj)
   loss_kj=loss_kj+gb_regen_loss_kj;
end
if ~isnan(gb_loss_kj)
   loss_kj=loss_kj+gb_loss_kj;
end
loss_kj=loss_kj+fd_regen_loss_kj...
   +fd_loss_kj...
   +brake_loss_kj...
   +wh_regen_loss_kj...
   +wh_loss_kj...
   +aero_kj...
   +rolling_kj...
   +aux_load_loss_kj;

% compute and display imbalance
imbalance_kj=input_kj-loss_kj;
disp(' ')
disp('Energy Balance')
disp('==============')
disp([num2str(round(imbalance_kj*10)/10),' kJ are missing--input to the vehicle'])
disp('but not accounted for in any component loss')
disp(' ')
disp(['This is ',num2str(round(imbalance_kj/input_kj*10000)/100),'% of the energy input to the vehicle.'])
disp(' ')