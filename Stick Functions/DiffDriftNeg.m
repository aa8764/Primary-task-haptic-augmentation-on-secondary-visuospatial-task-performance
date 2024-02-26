function [Xperiod , Xfrequency, startPhaseX] = DiffDriftNeg( time, ifi, Xamplitude, Pos_time , startPhaseX , TposX , Xfrequency )




Xperiod = 2 * pi * Xfrequency;
TposXsig_old = Xamplitude * sin(Xperiod * (Pos_time + startPhaseX)); % What does the existing signal look like?
TposX_old = Xamplitude * sin(Xperiod * ([time-ifi , time] + startPhaseX)); % Get the target position for current and previous frame

% Check with plot
% plot(Pos_time,TposXsig_old); hold on;  scatter([time-ifi , time],TposX_old,'r','filled')


% Calculate the more easier signal
Xfrequency = Xfrequency - 0.025;
Xperiod = 2 * pi * Xfrequency;

Run_X = 1+1; % =1 each time you level up.

Run_Freq_X = RandFeqX(1,Run_X);
AmpX = Xamp(1,Run_Freq_X);
Xamplitude = screenXpixels * (AmpX/1.351);
Xfrequency = Xfreq(1,Run_Freq_X);
Xperiod = 2 * pi * (Xfrequency); % omega rads/s

TposXsig_new = Xamplitude * sin(Xperiod * (Pos_time + startPhaseX));
TposXloc_new = Xamplitude * sin(Xperiod * ([time-ifi , time] + startPhaseX));

% check on the same plot
% plot(Pos_time,TposXsig_new); scatter([time-ifi , time],TposXloc_new,'g','filled')


% Define the direction of the signal
TposX_old_diff = diff(TposX_old);
if TposX_old_diff > 0 % 0 == 'left' & 1 == 'right'
    D = 1;
else
    D = -1;
end

% Now find points on the new signal that match where we currently are on
% the old signal. Need to use a pixel window to get enough samples
pix_win = 5;
idx = find(TposXsig_new >= TposX - pix_win & TposXsig_new <= TposX + pix_win);
if isempty(idx)
    pix_win = pix_win + 5;
    idx = find(TposXsig_new >= TposX - pix_win & TposXsig_new <= TposX + pix_win);
end

% Filter out the positions that are in the wrong direction
idx_time = Pos_time(idx);
TposXpos_new_diff = diff([Xamplitude * sin(Xperiod * ([idx_time-ifi] + startPhaseX))',...
    Xamplitude * sin(Xperiod * (idx_time + startPhaseX))'],[],2);
if D > 0
    idx(TposXpos_new_diff < 0) = [];  
elseif D < 0
    idx(TposXpos_new_diff > 0) = [];
end


if length(idx) > 1 % If there are several suitable points in idx choose the first oone
    idx = idx(1);
end

%% Calculate the difference in time between the current point on the old signal ('time')
% and the position on the new signal.

startPhaseX =  (Pos_time(idx) - time) + startPhaseX;

% TposXsig_new_adjust = Xamplitude * sin(Xperiod * (Pos_time + startPhase));
% 
% plot(Pos_time , TposXsig_new_adjust)




