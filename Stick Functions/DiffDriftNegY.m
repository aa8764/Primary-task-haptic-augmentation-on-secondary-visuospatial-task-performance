function [Yperiod , Yfrequency, startPhaseY] = DiffDriftNegY( time, ifi, Yamplitude, Pos_time , startPhaseY , TposY , Yfrequency )




Yperiod = 2 * pi * Yfrequency;
TposYsig_old = Yamplitude * sin(Yperiod * (Pos_time + startPhaseY)); % What does the existing signal look like?
TposY_old = Yamplitude * sin(Yperiod * ([time-ifi , time] + startPhaseY)); % Get the target position for current and previous frame

% Check with plot
% plot(Pos_time,TposXsig_old); hold on;  scatter([time-ifi , time],TposX_old,'r','filled')


% Calculate the more difficult signal
Yfrequency = Yfrequency - 0.025;
Yperiod = 2 * pi * Yfrequency;

TposYsig_new = Yamplitude * sin(Yperiod * (Pos_time + startPhaseY));
TposYloc_new = Yamplitude * sin(Yperiod * ([time-ifi , time] + startPhaseY));

% check on the same plot
% plot(Pos_time,TposXsig_new); scatter([time-ifi , time],TposXloc_new,'g','filled')


% Define the direction of the signal
TposY_old_diff = diff(TposY_old);
if TposY_old_diff > 0 % 0 == 'up' & 1 == 'down'
    D = 1;
else
    D = -1;
end

% Now find points on the new signal that match where we currently are on
% the old signal. Need to use a pixel window to get enough samples
piy_win = 5;
idx = find(TposYsig_new >= TposY - piy_win & TposYsig_new <= TposY + piy_win);
if isempty(idx)
    piy_win = piy_win + 5;
    idx = find(TposYsig_new >= TposY - piy_win & TposYsig_new <= TposY + piy_win);
end

% Filter out the positions that are in the wrong direction
idx_time = Pos_time(idx);
TposYpos_new_diff = diff([Yamplitude * sin(Yperiod * ([idx_time-ifi] + startPhaseY))',...
    Yamplitude * sin(Yperiod * (idx_time + startPhaseY))'],[],2);
if D > 0
    idx(TposYpos_new_diff < 0) = [];  
elseif D < 0
    idx(TposYpos_new_diff > 0) = [];
end


if length(idx) > 1 % If there are several suitable points in idx choose the first oone
    idx = idx(1);
end

%% Calculate the difference in time between the current point on the old signal ('time')
% and the position on the new signal.

startPhaseY =  (Pos_time(idx) - time) + startPhaseY;

% TposXsig_new_adjust = Xamplitude * sin(Xperiod * (Pos_time + startPhase));
% 
% plot(Pos_time , TposXsig_new_adjust)




