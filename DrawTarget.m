function [Pos_DS , centeredOval] = DrawTarget(Pos_DS,joy,window,ifi,i,RHCenter,yCenter,VAtopix,baseOval,stick_def,xp,yp,CH_XsigPix,CH_XsigVA,CH_YsigPix,CH_YsigVA,WaveSpeedDuration_Up,WaveSpeedDuration_Dn,InZone,NudgeZone)




% Calculate CH Speed measures
if i > 1

    Pos_DS.InputSignal_Dist_Pix_X(i) =   Pos_DS.InputSignal_Pix_X(i) - Pos_DS.InputSignal_Pix_X(i-1);
    Pos_DS.InputSignal_Dist_Pix_Y(i) =  Pos_DS.InputSignal_Pix_Y(i) - Pos_DS.InputSignal_Pix_Y(i-1);
    Pos_DS.InputSignal_Dist_VA_X(i) =  Pos_DS.InputSignal_VA_X(i) - Pos_DS.InputSignal_VA_X(i-1);
    Pos_DS.InputSignal_Dist_VA_Y(i) =  Pos_DS.InputSignal_VA_Y(i) - Pos_DS.InputSignal_VA_Y(i-1);

    Pos_DS.InputSignal_Targ_Speed_Pix_X(i) =  Pos_DS.InputSignal_Dist_Pix_X(i) / ifi;
    Pos_DS.InputSignal_Targ_Speed_Pix_Y(i) =  Pos_DS.InputSignal_Dist_Pix_Y(i) / ifi;
    Pos_DS.InputSignal_Targ_Speed_VA_X(i) =  Pos_DS.InputSignal_Dist_VA_X(i) / ifi;
    Pos_DS.InputSignal_Targ_Speed_VA_Y(i) =  Pos_DS.InputSignal_Dist_VA_Y(i) / ifi;

    Pos_DS.InputSignal_Targ_Acc_Pix_X(i) =   Pos_DS.InputSignal_Targ_Speed_Pix_X(i) / ifi;
    Pos_DS.InputSignal_Targ_Acc_Pix_Y(i) =  Pos_DS.InputSignal_Targ_Speed_Pix_Y(i) / ifi;
    Pos_DS.InputSignal_Targ_Acc_VA_X(i) =  Pos_DS.InputSignal_Targ_Speed_VA_X(i) / ifi;
    Pos_DS.InputSignal_Targ_Acc_VA_Y(i) =  Pos_DS.InputSignal_Targ_Speed_VA_Y(i) / ifi;

end

%% Read stick positions

Pos_DS.StickPos_X(i)= axis(joy, 1);
Pos_DS.StickPos_Y(i)= axis(joy, 2);


%% Calculate Target Position

% Add this position to the screen center coordinate.
Pos_DS.Oval_Pos_Pix_X(i) = Pos_DS.StickPos_X(i) * VAtopix * 4 + RHCenter;
Pos_DS.Oval_Pos_Pix_Y(i) = Pos_DS.StickPos_Y(i) * VAtopix * 4 + yCenter;

% Calculate Target Speed measures
if i > 1
    Pos_DS.Oval_Dist_Pix_X(i) = Pos_DS.Oval_Pos_Pix_X(i) - Pos_DS.Oval_Pos_Pix_X(i-1);
    Pos_DS.Oval_Dist_Pix_Y(i) = Pos_DS.Oval_Pos_Pix_Y(i) - Pos_DS.Oval_Pos_Pix_Y(i-1);
    Pos_DS.Oval_Dist_VA_X(i) = Pos_DS.Oval_Dist_Pix_X(i) / VAtopix;
    Pos_DS.Oval_Dist_VA_Y(i) = Pos_DS.Oval_Dist_Pix_Y(i) / VAtopix;

    Pos_DS.Oval_Speed_Pix_X(i) = Pos_DS.Oval_Dist_Pix_X(i) / ifi;
    Pos_DS.Oval_Speed_Pix_Y(i) = Pos_DS.Oval_Dist_Pix_Y(i) / ifi;
    Pos_DS.Oval_Speed_VA_X(i) = Pos_DS.Oval_Dist_VA_X(i) / ifi;
    Pos_DS.Oval_Speed_VA_Y(i) = Pos_DS.Oval_Dist_VA_Y(i) / ifi;

    Pos_DS.Oval_Acc_Pix_X(i) = Pos_DS.Oval_Speed_Pix_X(i) / ifi;
    Pos_DS.Oval_Acc_Pix_Y(i) = Pos_DS.Oval_Speed_Pix_Y(i) / ifi;
    Pos_DS.Oval_Acc_VA_X(i) = Pos_DS.Oval_Speed_VA_X(i) / ifi;
    Pos_DS.Oval_Acc_VA_Y(i) = Pos_DS.Oval_Speed_VA_Y(i) / ifi;
end

% Center the oval on the centre of the screen
centeredOval = CenterRectOnPointd(baseOval, Pos_DS.Oval_Pos_Pix_X(i),  Pos_DS.Oval_Pos_Pix_Y(i));



%% Calculate Target and Crosshair differences

Pos_DS.Dist_Pix_X(i) =  mean([centeredOval(1),centeredOval(3)]) - Pos_DS.InputSignal_Pix_X(i);
Pos_DS.Dist_Pix_Y(i) =  mean([centeredOval(2),centeredOval(4)]) - Pos_DS.InputSignal_Pix_Y(i);

Pos_DS.Dist_VA_X(i) =  Pos_DS.Dist_Pix_X(i) / VAtopix;
Pos_DS.Dist_VA_Y(i) =  Pos_DS.Dist_Pix_Y(i) / VAtopix;

% Calculate CH and Target speed differences measures
if i > 1
    Pos_DS.Dist_Dist_Pix_X(i) = Pos_DS.Dist_Pix_X(i) - Pos_DS.Dist_Pix_X(i-1);
    Pos_DS.Dist_Dist_Pix_Y(i) = Pos_DS.Dist_Pix_Y(i) - Pos_DS.Dist_Pix_Y(i-1);
    Pos_DS.Dist_Dist_VA_X(i) = Pos_DS.Dist_Dist_Pix_X(i) / VAtopix;
    Pos_DS.Dist_Dist_VA_Y(i) = Pos_DS.Dist_Dist_Pix_Y(i) / VAtopix;

    Pos_DS.Dist_Speed_Pix_X(i) = Pos_DS.Dist_Dist_Pix_X(i) / ifi;
    Pos_DS.Dist_Speed_Pix_Y(i) = Pos_DS.Dist_Dist_Pix_Y(i) / ifi;
    Pos_DS.Dist_Speed_VA_X(i) = Pos_DS.Dist_Dist_VA_X(i) / ifi;
    Pos_DS.Dist_Speed_VA_Y(i) = Pos_DS.Dist_Dist_VA_Y(i) / ifi;

    Pos_DS.Dist_Acc_Pix_X(i) = Pos_DS.Dist_Speed_Pix_X(i) / ifi;
    Pos_DS.Dist_Acc_Pix_Y(i) = Pos_DS.Dist_Speed_Pix_Y(i) / ifi;
    Pos_DS.Dist_Acc_VA_X(i) = Pos_DS.Dist_Speed_VA_X(i) / ifi;
    Pos_DS.Dist_Acc_VA_Y(i) = Pos_DS.Dist_Speed_VA_Y(i) / ifi;
end

% Is the target in the "crosshair zone"?
if (Pos_DS.Dist_VA_X(i) <= InZone && Pos_DS.Dist_VA_X(i) >= -InZone) && (Pos_DS.Dist_VA_Y(i) <= InZone && Pos_DS.Dist_VA_Y(i) >= -InZone)
    Pos_DS.InZone(i) = 1;
    Screen('FillOval',window, [0 1 0], centeredOval);

    if i > 1 % Only count time on target from 2nd frame of the experiment
        Pos_DS.TimeOnTargetCum(i) = Pos_DS.TimeOnTargetCum(i-1) + ifi;
        Pos_DS.TimeOffTargetCum(i) = Pos_DS.TimeOffTargetCum(i-1);
        Pos_DS.TimeOnTarget(i) = Pos_DS.TimeOnTarget(i-1) + ifi;
    end
else
    Pos_DS.InZone(i) = 0;
    Screen('FillOval',window, [0 1 0], centeredOval);

    if i > 1
        Pos_DS.TimeOffTargetCum(i) = Pos_DS.TimeOffTargetCum(i-1) + ifi;
        Pos_DS.TimeOnTargetCum(i) = Pos_DS.TimeOnTargetCum(i-1);
        Pos_DS.TimeOffTarget(i) = Pos_DS.TimeOffTarget(i-1) + ifi;
    end
end


% direction that the "crosshair" is from the target (degrees)

if  Pos_DS.Dist_Pix_X(i) > 0 && Pos_DS.Dist_Pix_Y(i) < 0 % "Crosshair" is SW
    Pos_DS.Dist_Angle(i) = 180+(atan(Pos_DS.Dist_Pix_X(i)/-Pos_DS.Dist_Pix_Y(i)))*180/pi;

elseif  Pos_DS.Dist_Pix_X(i) < 0 && Pos_DS.Dist_Pix_Y(i) < 0 % "Crosshair" is SE
    Pos_DS.Dist_Angle(i) = 180 +(atan(-Pos_DS.Dist_Pix_X(i)/Pos_DS.Dist_Pix_Y(i)))*180/pi;

elseif  Pos_DS.Dist_Pix_X(i) < 0 && Pos_DS.Dist_Pix_Y(i) > 0 %"Crosshair" is NE
    Pos_DS.Dist_Angle(i) = (atan(-Pos_DS.Dist_Pix_X(i)/Pos_DS.Dist_Pix_Y(i)))*180/pi;

else % "Crosshair" is NW
    Pos_DS.Dist_Angle(i) = 360+(atan(-Pos_DS.Dist_Pix_X(i)/Pos_DS.Dist_Pix_Y(i)))*180/pi;

end


% Check if the difficulty of tracking task needs increasing
if mod(Pos_DS.TimeOnTarget(i),WaveSpeedDuration_Up) >= WaveSpeedDuration_Up - (ifi) && Pos_DS.TrackingLevel(i) ~= length(CH_XsigPix(1,:))
    Pos_DS.TrackingLevel(i:end) = Pos_DS.TrackingLevel(i) + 1;

    ChangeSize = length(Pos_DS.InputSignal_Pix_X(i:end)) - 1; % size of the remainder of the Pos_DS file that needs alterating

    % Change the X signal
    if (Pos_DS.InputSignal_Pix_X(i) - Pos_DS.InputSignal_Pix_X(i-1)) >= 0 % if current signal is moving right

        idx = find ([false ; (CH_XsigPix(2:end,Pos_DS.TrackingLevel(i)) - CH_XsigPix(1:end-1,Pos_DS.TrackingLevel(i))) >= 0] & ...
            CH_XsigPix(:,Pos_DS.TrackingLevel(i)) <= Pos_DS.InputSignal_Pix_X(i) + .5 & ...
            CH_XsigPix(:,Pos_DS.TrackingLevel(i)) >= Pos_DS.InputSignal_Pix_X(i) - .5) ;
        idx = idx(1);

    else % if current signal is moving left

        idx = find ([false ; (CH_XsigPix(2:end,Pos_DS.TrackingLevel(i)) - CH_XsigPix(1:end-1,Pos_DS.TrackingLevel(i))) <= 0] & ...
            CH_XsigPix(:,Pos_DS.TrackingLevel(i)) <= Pos_DS.InputSignal_Pix_X(i) + .5 & ...
            CH_XsigPix(:,Pos_DS.TrackingLevel(i)) >= Pos_DS.InputSignal_Pix_X(i) - .5) ;
        idx = idx(1);
    end
    Pos_DS.InputSignal_Pix_X(i:end) =  CH_XsigPix(idx:idx+ChangeSize,Pos_DS.TrackingLevel(i)); % CH X signal
    Pos_DS.InputSignal_VA_X(i:end) =  CH_XsigVA(idx:idx+ChangeSize,Pos_DS.TrackingLevel(i)); % CH X signal

    % Change the Y signal
    if (Pos_DS.InputSignal_Pix_Y(i) - Pos_DS.InputSignal_Pix_Y(i-1)) >= 0 % if current Y signal is moving Down

        idx = find ([false ; (CH_YsigPix(2:end,Pos_DS.TrackingLevel(i)) - CH_YsigPix(1:end-1,Pos_DS.TrackingLevel(i))) >= 0] & ...
            CH_YsigPix(:,Pos_DS.TrackingLevel(i)) <= Pos_DS.InputSignal_Pix_Y(i) + .5 & ...
            CH_YsigPix(:,Pos_DS.TrackingLevel(i)) >= Pos_DS.InputSignal_Pix_Y(i) - .5) ;
        idx = idx(1);

    else % if current Y signal is moving Top

        idx = find ([false ; (CH_YsigPix(2:end,Pos_DS.TrackingLevel(i)) - CH_YsigPix(1:end-1,Pos_DS.TrackingLevel(i))) <= 0] & ...
            CH_YsigPix(:,Pos_DS.TrackingLevel(i)) <= Pos_DS.InputSignal_Pix_Y(i) + .5 & ...
            CH_YsigPix(:,Pos_DS.TrackingLevel(i)) >= Pos_DS.InputSignal_Pix_Y(i) - .5) ;
        idx = idx(1);
    end

    Pos_DS.InputSignal_Pix_Y(i:end) =  CH_YsigPix(idx:idx+ChangeSize,Pos_DS.TrackingLevel(i)); % CH Y signal
    Pos_DS.InputSignal_VA_Y(i:end) =  CH_YsigVA(idx:idx+ChangeSize,Pos_DS.TrackingLevel(i)); % CH Y signal

end

% Check if the difficulty of tracking task needs decreasing
if mod(Pos_DS.TimeOffTarget(i),WaveSpeedDuration_Dn) >= WaveSpeedDuration_Dn - (ifi) && Pos_DS.TrackingLevel(i) ~= 1
    Pos_DS.TrackingLevel(i:end) = Pos_DS.TrackingLevel(i) - 1;

    ChangeSize = length(Pos_DS.InputSignal_Pix_X(i:end)) - 1; % size of the remainder of the Pos_DS file that needs alterating

    % Change the X signal
    if (Pos_DS.InputSignal_Pix_X(i) - Pos_DS.InputSignal_Pix_X(i-1)) >= 0 % if current signal is moving right

        idx = find ([false ; (CH_XsigPix(2:end,Pos_DS.TrackingLevel(i)) - CH_XsigPix(1:end-1,Pos_DS.TrackingLevel(i))) >= 0] & ...
            CH_XsigPix(:,Pos_DS.TrackingLevel(i)) <= Pos_DS.InputSignal_Pix_X(i) + .5 & ...
            CH_XsigPix(:,Pos_DS.TrackingLevel(i)) >= Pos_DS.InputSignal_Pix_X(i) - .5) ;
        idx = idx(1);

    else % if current signal is moving left

        idx = find ([false ; (CH_XsigPix(2:end,Pos_DS.TrackingLevel(i)) - CH_XsigPix(1:end-1,Pos_DS.TrackingLevel(i))) <= 0] & ...
            CH_XsigPix(:,Pos_DS.TrackingLevel(i)) <= Pos_DS.InputSignal_Pix_X(i) + .5 & ...
            CH_XsigPix(:,Pos_DS.TrackingLevel(i)) >= Pos_DS.InputSignal_Pix_X(i) - .5) ;
        idx = idx(1);
    end
    Pos_DS.InputSignal_Pix_X(i:end) =  CH_XsigPix(idx:idx+ChangeSize,Pos_DS.TrackingLevel(i)); % CH X signal
    Pos_DS.InputSignal_VA_X(i:end) =  CH_XsigVA(idx:idx+ChangeSize,Pos_DS.TrackingLevel(i)); % CH X signal

    % Change the Y signal
    if (Pos_DS.InputSignal_Pix_Y(i) - Pos_DS.InputSignal_Pix_Y(i-1)) >= 0 % if current Y signal is moving Down

        idx = find ([false ; (CH_YsigPix(2:end,Pos_DS.TrackingLevel(i)) - CH_YsigPix(1:end-1,Pos_DS.TrackingLevel(i))) >= 0] & ...
            CH_YsigPix(:,Pos_DS.TrackingLevel(i)) <= Pos_DS.InputSignal_Pix_Y(i) + .5 & ...
            CH_YsigPix(:,Pos_DS.TrackingLevel(i)) >= Pos_DS.InputSignal_Pix_Y(i) - .5) ;
        idx = idx(1);

    else % if current Y signal is moving Top

        idx = find ([false ; (CH_YsigPix(2:end,Pos_DS.TrackingLevel(i)) - CH_YsigPix(1:end-1,Pos_DS.TrackingLevel(i))) <= 0] & ...
            CH_YsigPix(:,Pos_DS.TrackingLevel(i)) <= Pos_DS.InputSignal_Pix_Y(i) + .5 & ...
            CH_YsigPix(:,Pos_DS.TrackingLevel(i)) >= Pos_DS.InputSignal_Pix_Y(i) - .5) ;
        idx = idx(1);
    end

    Pos_DS.InputSignal_Pix_Y(i:end) =  CH_YsigPix(idx:idx+ChangeSize,Pos_DS.TrackingLevel(i)); % CH Y signal
    Pos_DS.InputSignal_VA_Y(i:end) =  CH_YsigVA(idx:idx+ChangeSize,Pos_DS.TrackingLevel(i)); % CH Y signal

end


% Is target with nudge distance of the SH?
if (Pos_DS.Dist_VA_X(i) <= NudgeZone && Pos_DS.Dist_VA_X(i) >= -NudgeZone) && (Pos_DS.Dist_VA_Y(i) <= NudgeZone && Pos_DS.Dist_VA_Y(i) >= -NudgeZone)
    Pos_DS.InNudgeZone(i) = 1;
else
    Pos_DS.InNudgeZone(i) = 0;
end

%% Calculate stick centering forcefeedback

[Xf_loc , Yf_loc] = getCentreforce(Pos_DS.StickPos_X(i),Pos_DS.StickPos_Y(i),stick_def);
Pos_DS.StickCentreForce_X(i) = xp(Xf_loc);
Pos_DS.StickCentreForce_Y(i) = yp(Yf_loc);