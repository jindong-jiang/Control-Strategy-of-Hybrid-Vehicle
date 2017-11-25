% clear all;
% clc;
%% 路谱载入选择
% cyc_flag=1 载入所需要研究的红绿灯数据 
% cyc_flag=2  载入标准路谱
% 标准路谱载入，在载入标准路谱之前，请核实标准路谱的单位,有些路谱单位不为mph，在此，没有细分

cyc_flag = 2;

%% 路谱载入数据分预处理 
if cyc_flag==1
    TrafficData.Test;                        % 载入所需要研究的红绿灯数据
    cyc_mph(:,1) = tarVehicletime;
    cyc_mph(:,2) = tarVehiclespeed;
    cyc_mph(:,2) = 3.6*cyc_mph(:,2);          % m/s -> km/h
else                                          % 载入标准路谱
    load .\+DriveCycle\CYC_WVUSUB.mat      
    cyc_mph(:,2) = 1.6093*cyc_mph(:,2);       % mph -> km/h
end





%% 采取默认，暂时不用考虑
% keep key in 'on' position throughout cycle ('1' in the 2nd column => 'on')
vc_key_on=[cyc_mph(:,1) ones(size(cyc_mph,1),1)];
TimeLength = length(cyc_mph);               %计算仿真时长


%% 下面代码暂时不用考虑，后期若涉及到汽车爬坡性能分析，需要进行相关研究
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%													
% Size of 'window' used to filter the trace with centered-in-time averaging;
% higher numbers mean more smoothing and less rigorous following of the
% trace.RRRRR
% Used when cyc_filter_bool=1
cyc_avg_time=3;  % (s)
cyc_filter_bool=0;	% 0=> no filtering, follow trace exactly; 1=> smooth trace
cyc_grade=0;	%no grade associated with this cycle
cyc_elevation_init=0; %the initial elevation in meters.

if size(cyc_grade,1)<2
   % convert cyc_grade to a two column matrix, grade vs. dist
   cyc_grade=[0 cyc_grade; 1 cyc_grade]; % use this for a constant roadway grade
end

% A constant zero delta in cargo-mass:
% First column is distance (m) second column is mass (kg) 
cyc_cargo_mass=[0 0
   1 0]; 

if size(cyc_cargo_mass,1)<2
   % convert cyc_grade to a two column matrix, grade vs. dist
   cyc_cargo_mass=[0 cyc_cargo_mass; 1 cyc_cargo_mass]; % use this for a constant roadway grade
end

if exist('cyc_coast_gb_shift_delay')
    gb_shift_delay=cyc_coast_gb_shift_delay; % restore the original gb_shift_delay which may have been changed by cyc_coast
end
