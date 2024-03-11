function [Xf_loc , Yf_loc] = getCentreforce(stick_xpos,stick_ypos,stick_def)


% find the closest value of x from X
    [~,Xf_loc] = (min(abs(stick_def - stick_xpos)));
        
    % find the closest value of x from Y
    [~,Yf_loc] = (min(abs(stick_def - stick_ypos)));
    