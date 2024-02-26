function [Nudge]  = StickNudgeY(i, ifi , TposY_diff)

% function [Nudge]  = StickNudge(i, time , startPhase , ifi ,Xperiod , Xamplitude)
%% Nudger

Hz = 4; % Frequency of the nudge
Amp = 0.25; % size of the nudge force

% Define the shape of a single period.
t = 0: ifi : 1 / Hz ;
y = linspace( Amp , 0 , floor(length(t) * 0.9)); y = [ y , zeros(1,(length(t) - length(y)))];

% glue together into a single 60 second frame;
y = repmat(y,1,Hz * 60);
t = 0:ifi:(length(y)-1)*ifi;

% plot(t,x); set(gca,'Ylim',[-1 1]);

%% Specify the direction the nudge should be in.

% TposX = Xamplitude * sin(Xperiod * ([time-ifi , time] + startPhase)); % Get the target position for current and previous frame

if TposY_diff < 0
    y = -y;
end

%% Output the nudge force
Nudge = y(i);


