function [Nudge]  = StickNudge(i, ifi , TposX_diff)

% function [Nudge]  = StickNudge(i, time , startPhase , ifi ,Xperiod , Xamplitude)
%% Nudger

Hz = 4; % Frequency of the nudge
Amp = 0.25; % size of the nudge force

% Define the shape of a single period.
t = 0: ifi : 1 / Hz ;
x = linspace( Amp , 0 , floor(length(t) * 0.9)); x = [ x , zeros(1,(length(t) - length(x)))];

% glue together into a single 60 second frame;
x = repmat(x,1,Hz * 60);
t = 0:ifi:(length(x)-1)*ifi;

% plot(t,x); set(gca,'Ylim',[-1 1]);

%% Specify the direction the nudge should be in.

% TposX = Xamplitude * sin(Xperiod * ([time-ifi , time] + startPhase)); % Get the target position for current and previous frame

if TposX_diff < 0
    x = -x;
end

%% Output the nudge force
Nudge = x(i);


