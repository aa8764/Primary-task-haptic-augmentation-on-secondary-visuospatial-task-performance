function [stick_def , XforceProfile , YforceProfile] =  setGraidentComplexProfile( x1 , x2 , x3 ,x4 , x5 , x6, y1 , y2 ,y3, y4 , y5 , y6, xscale, yscale)

% This is a function that uses stick forces to mimic spring centring. I.e.
% larger forces on larger stick deflections.

% Could be linear but have been toying with Shaped functions too using
% matlab SMF function (see below).


x1 = 0;
x2 = 0.034;
x3 = 0.267;
x4 = 0.267;
x5 = 0.467;
x6 = 0.5;

y1 = 0;
y2 = 0;
y3 = 0.327;
y4 = 0.393;
y5 = 0.693;
y6 = 1;

xscale = 0.4 ;
yscale = 0.4 ; 

% % data from the force profile papergraphone.m
% srx=[0 5 40 40 70 75];
% sry=[0 0 49 59 104 150]; %stick resistance
% % converted to a range 0 to 1
% srx=[0 0.04 0.27 0.27 0.47 0.5];
% sry=[0 0 0.32 0.393 0.693 1]; %stick resistance


%% Create the x- and y-axis force profiles

stick_def = 0:0.01:1;

XforceProfile = smf(stick_def,[x1 x2 x3 x4 x5 x6]);
XforceProfile = XforceProfile * xscale;

YforceProfile = smf(stick_def,[y1 y2 y3 y4 y5 y6]);
YforceProfile = YforceProfile * yscale;




%% Create the force profile for the other direction.

x_ = flip(-stick_def); 
XforceProfile_ = flip(-XforceProfile);
YforceProfile_ = flip(-YforceProfile);


x_(end) = [];
XforceProfile_(end) = [];
YforceProfile_(end) = [];


stick_def = [x_ stick_def]; 
XforceProfile = [XforceProfile_ XforceProfile];
YforceProfile = [YforceProfile_ YforceProfile];

%% 
% figure(); hold on; 
% plot(stick_def,XforceProfile); plot(stick_def,YforceProfile);
