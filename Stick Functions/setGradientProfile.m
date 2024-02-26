function [stick_def , XforceProfile , YforceProfile] =  setGradientProfile(x1, x2 , x3, y1 , y2, y3, xscale , yscale)

% This is a function that uses stick forces to mimic spring centring. I.e.
% larger forces on larger stick deflections.

% Could be linear but have been toying with Shaped functions too using
% matlab SMF function (see below).

%% Create the x- and y-axis force profiles

stick_def = 0:0.01:1;

XforceProfile = [x1 x2 x3];
XforceProfile = XforceProfile * xscale;

YforceProfile = [y1 y2 y3];
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
