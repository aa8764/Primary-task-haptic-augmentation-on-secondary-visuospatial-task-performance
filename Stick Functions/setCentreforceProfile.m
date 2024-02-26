function [stick_def , XforceProfile , YforceProfile] =  setCentreforceProfile(x1, x2 , y1 , y2, xscale , yscale)

% This is a function that uses stick forces to mimic spring centring. I.e.
% larger forces on larger stick deflections.

% Could be linear but have been toying with Shaped functions too using
% matlab SMF function (see below).


x1= 0.02 ;
x2 = 0.3 ;
y1 = 0.02 ;
y2 = 0.3; 
xscale = 0.5 ;
yscale = 0.5 ; 
%% Create the x- and y-axis force profiles

stick_def = 0:0.01:1;

XforceProfile = smf(stick_def,[x1 x2]);
XforceProfile = XforceProfile * xscale;

YforceProfile = smf(stick_def,[y1 y2]);
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
