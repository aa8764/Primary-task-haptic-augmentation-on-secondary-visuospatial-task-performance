function [stick_def, xp, yp] =  setCentreforceProfile(x1, x2 , y1 , y2, xscale , yscale)

% This is a function that uses stick forces to mimic spring centring. I.e.
% larger forces on larger stick deflections.

% Could be linear but have been toying with Shaped functions too using
% matlab SMF function (see below).

%% Create the x- and y-axis force profiles

stick_def = 0:0.01:1;

xp = smf(stick_def,[x1 x2]);
xp = xp * xscale;

yp = smf(stick_def,[y1 y2]);
yp = yp * yscale;


%% Create the force profile for the other direction.

x_ = flip(-stick_def); 
xp_ = flip(-xp);
yp_ = flip(-yp);


x_(end) = [];
xp_(end) = [];
yp_(end) = [];


stick_def = [x_ stick_def]; 
xp = [xp_ xp];
yp = [yp_ yp];

%% 
% figure(); 
% hold on; 
% grid on;
% plot(stick_def,xp); 
% plot(stick_def,yp);
% legend
