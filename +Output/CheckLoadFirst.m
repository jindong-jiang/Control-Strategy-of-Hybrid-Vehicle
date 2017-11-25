global t;
global dist;
global Fuel_100km;
global mpha;
global cyc_mph_r;
global soc;
global vinf 


fc_fuel_lhv = 42600;
dist = 1.6093*trapz(t,mpha)/3600;	% miles
dist = roundn(dist,-3);
fc_fuel_den = 840;
fuel_gal = evalin('base','max(gal)');
Fuel_Energy_Used = fuel_gal*3.785*evalin('base','fc_fuel_lhv*fc_fuel_den'); %Joules
Fuel_100km = 100/dist*Fuel_Energy_Used/(fc_fuel_lhv*fc_fuel_den);
Fuel_100km = roundn(Fuel_100km,-3);