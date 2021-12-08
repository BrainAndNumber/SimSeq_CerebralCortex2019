function [start_fix,dur_fix,pressed] = Fixation(w,rect,mon_width,v_dist,dur,color,start_trigger)
% Do initial flip...
mon_width   = 50;   % horizontal dimension of viewable screen (cm)
v_dist      = 60;   % viewing distance (cm)
fix_r       = 0.3; % radius of fixation point (deg)
[center(1), center(2)] = RectCenter(rect);
ppd = pi * (rect(3)-rect(1)) / atan(mon_width/v_dist/2) / 360;    % pixels per degree
fix_cord = [center-fix_r*ppd center+fix_r*ppd];
[X,Y] = RectCenter(rect);
FixCross = [X-2,Y-12,X+2,Y+12;X-12,Y-2,X+12,Y+2];
kc_esc = KbName('esc');
% kc_lctrl = KbName('1!');
% kc_rctrl = KbName('4$');
kc_lctrl = KbName('left_control');
kc_rctrl = KbName('right_control');



% Measure the vertical refresh rate of the monitor
ifi = Screen('GetFlipInterval', w);
% Numer of frames to wait when specifying good timing
waitframes = 1;

pressed = 0;



Priority(MaxPriority(w));
vbl = Screen('Flip', w);
% Length of time and number of frames we will use for each drawing test
numSecs = dur;
numFrames = round(numSecs / ifi);


for frame = 1:numFrames
    Screen('FillRect', w, color, FixCross');  
    % Tell PTB no more drawing commands will be issued until the next flip
    Screen('DrawingFinished', w);
    % Flip to the screen
    if frame == 1
        start_fix = vbl + (waitframes - 0.5) * ifi-start_trigger;
    end;
    vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);

    [keyIsDown secs keycodes] = KbCheck();
    if ~isempty(keycodes)
        if keycodes(kc_esc)
            Priority(0);
            ShowCursor;
            Screen('CloseAll');
        elseif keycodes(kc_lctrl) || keycodes(kc_rctrl)
            pressed = 1;
        end;
    end;
end
Priority(0);
dur_fix = vbl + (waitframes - 0.5) * ifi-start_fix-start_trigger;