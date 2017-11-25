%% 工作空间清理
clc
close all
clear warnings;
%% 基础变量加载
CheckLoadFirst;

%% 数据分析结果图标显示
CheckFuelConverterOperation;
CheckFuelConverterEfficiency;
CheckMotorControllerOperation;
CheckMotorControllerEfficiency;
CheckShiftDiagram;
CheckEssChargeEfficiency;
CheckDrivetrain;
CheckOut;

%% 能量流统计分析
GuiPostProcess;
EnergyFigure;
