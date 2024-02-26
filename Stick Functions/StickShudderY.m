function [Shudder]  = StickShudderY(ifi,i)

% ID = 1;
% % Create joystick variable
% joy=vrjoystick(ID,'forcefeedback');
% 
% ifi = 1/60;
%% Shudder
Tamplitude = 0.4;
Tfrequency =  8;
TangFreq = 2 * pi * Tfrequency;

t = 0:ifi:60;

% x = Tamplitude * sin(TangFreq * t); plot(t , x); set(gca,'Ylim',[-1 1]);

% for i = 1:length(t)
Shudder = Tamplitude * sin(TangFreq * t(i));

    
% end
