function [Pos_DS , Nudge_i] = StickNudge_8deg(Pos_DS,ifi,i,Nudge_Signal,Nudge_i)


if i ~= 1 % Only run script if not on the very first frame of the experiment.
    
    %% % Calculate parameters of nudge if at beginning of nudge signal
    if Nudge_i == 0
        
        % Create the X and Y force to deliver a 360 degree forces
%         time = linspace( 0 , 1 , 360); % 1 second signal
%         Xsig = sin(2 * pi * (time - 1)); % 1 occilation a second with phase shift
%         Ysig = sin(2 * pi * (time - 0.25)); % 1 occilation a second
%         
%         Angle = 0:1:359;
        %         plot(Angle,Xsig); hold on;
        %         plot(Angle,Ysig);
        %         legend('X','Y');
        %
%         Pos_DS.StickNudge_Direction_Xf(i) =  Xsig(floor(Pos_DS.Dist_Angle(i)) == Angle);
%         Pos_DS.StickNudge_Direction_Yf(i) =  Ysig(floor(Pos_DS.Dist_Angle(i)) == Angle);
        
        
        if  Pos_DS.Dist_Angle(i) >= 22.5 && Pos_DS.Dist_Angle(i) <= 67.5 % NE
            Pos_DS.StickNudge_Direction_Xf(i) = 1;
            Pos_DS.StickNudge_Direction_Yf(i) = -1;
            
        elseif  Pos_DS.Dist_Angle(i) > 67.5 && Pos_DS.Dist_Angle(i) <= 112.5 % E
            Pos_DS.StickNudge_Direction_Xf(i) = 1;
            Pos_DS.StickNudge_Direction_Yf(i) = 0;
            
        elseif  Pos_DS.Dist_Angle(i) > 112.5 && Pos_DS.Dist_Angle(i) <= 157.5 %SE
            Pos_DS.StickNudge_Direction_Xf(i) = 1;
            Pos_DS.StickNudge_Direction_Yf(i) = 1;
            
        elseif  Pos_DS.Dist_Angle(i) > 157.5 && Pos_DS.Dist_Angle(i) <= 202.5 % S
            Pos_DS.StickNudge_Direction_Xf(i) = 0;
            Pos_DS.StickNudge_Direction_Yf(i) = 1;
                        
        elseif  Pos_DS.Dist_Angle(i) > 202.5 && Pos_DS.Dist_Angle(i) <= 247.5 %SW
            Pos_DS.StickNudge_Direction_Xf(i) = -1;
            Pos_DS.StickNudge_Direction_Yf(i) = 1;
            
        elseif  Pos_DS.Dist_Angle(i) > 247.5 && Pos_DS.Dist_Angle(i) <= 292.5 %W
            Pos_DS.StickNudge_Direction_Xf(i) = -1;
            Pos_DS.StickNudge_Direction_Yf(i) = 0;
            
        elseif  Pos_DS.Dist_Angle(i) > 292.5 && Pos_DS.Dist_Angle(i) <= 337.5 %NW
            Pos_DS.StickNudge_Direction_Xf(i) = -1;
            Pos_DS.StickNudge_Direction_Yf(i) = -1;
            
        elseif Pos_DS.Dist_Angle(i) > 337.5 Pos_DS.Dist_Angle(i) <= 359 ||...
                Pos_DS.Dist_Angle(i) >= 0 && Pos_DS.Dist_Angle(i) < 22.5 %NW
            Pos_DS.StickNudge_Direction_Xf(i) = 0; %N
            Pos_DS.StickNudge_Direction_Yf(i) = -1;
        end
        
        Pos_DS.OnNudge(i) = 1;
        
    else
        
        Pos_DS.StickNudge_Direction_Xf(i) = Pos_DS.StickNudge_Direction_Xf(i-1);
        Pos_DS.StickNudge_Direction_Yf(i) =  Pos_DS.StickNudge_Direction_Yf(i-1);
        Pos_DS.OnNudge(i) = 1;
    end
    
    %% Depending on the time since cue onset the size of these forces need to be adjusted
    
    Pos_DS.TimeOnNudge(i) = Pos_DS.TimeOnNudge(i-1) + ifi;
    Nudge_i = Nudge_i + 1;
    
    Pos_DS.StickNudge_Xf(i) = Pos_DS.StickNudge_Direction_Xf(i) * Nudge_Signal(Nudge_i);
    Pos_DS.StickNudge_Yf(i) = Pos_DS.StickNudge_Direction_Yf(i) * Nudge_Signal(Nudge_i);
    
    if Nudge_i == length(Nudge_Signal)
        Nudge_i = 0;
    end
    
end
