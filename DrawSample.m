function [start_sample,dur_sample,onsets,ends,avg_dur,avg_isi,dur,isi] = DrawSample(w,rect,num,set,surface,start_trigger)

%coloring
black = [0 0 0];
white = [255 255 255];

%screen parameters
mon_width   = 50;   % horizontal dimension of viewable screen (cm)
v_dist      = 60;   % viewing distance (cm)
fix_r       = 0.3; % radius of fixation point (deg)
[center(1), center(2)] = RectCenter(rect);
ppd = pi * (rect(3)-rect(1)) / atan(mon_width/v_dist/2) / 360;    % pixels per degree
fix_cord = [center-fix_r*ppd center+fix_r*ppd];
a = fix_r*ppd;
[X,Y] = RectCenter(rect);
FixCross = [X-2,Y-12,X+2,Y+12;X-12,Y-2,X+12,Y+2];
% Measure the vertical refresh rate of the monitor
ifi = Screen('GetFlipInterval', w);
% Numer of frames to wait when specifying good timing
waitframes = 1;

kc_esc = KbName('esc');


durations = zeros(num,1);
intervals = zeros(num-1,1);


durs = [0.07,0.85,0.1,0.2;0.2,0.1,0.085,0.07;0.07,0.07,0.07,0.07;0.07,0.07,0.07,0.07];
ints = [0.07,0.07,0.07,0.07;0.07,0.09,0.18,0.25;0.25,0.18,0.09,0.07;0.5,0.3,0.15,0.07];
durs = ceil(durs./(1/60)).*(1/60);
ints = ceil(ints./(1/60)).*(1/60);

onsets = zeros(16,1); %holds the starting time of each visual flash
ends = zeros(16,1); %holds the end time of each visual flash


% fix_cord = [center-circumference/(2*pi) center+circumference/(2*pi)];
fix_cord = [center-sqrt(surface/pi)*350 center+sqrt(surface/pi)*350];

if num == 5 || num == 7
    size = 2;
    jitArray = [1,-1];
    jitArray = Shuffle(jitArray);
else
    size = 4;
    jitArray = [1,1,-1,-1];
    jitArray = Shuffle(jitArray);
end;
jitCount = 1; %counts the number of jitters already put

%size = floor(nums(i)/4);
indx = 0;
if num == 5
    indx = 1;
elseif num == 7
    indx = 2;
elseif num == 11
    indx = 3;
elseif num == 16
    indx = 4;
end;

a = randperm(num);
b = zeros(size,1);
for k = 1:size
    b(k,1) = a(k);
end;





for z = 1:num
    if ~ismember(z,b) && z ~= num
        durations(z,1) = durs(set,indx);
        intervals(z,1) = ints(set,indx);
    elseif ~ismember(z,b) && z == num
        durations(z,1) = durs(set,indx);
        intervals(z-1,1) = ints(set,indx);
    elseif ismember(z,b) && z ~= num
        durJit = durs(set,indx)-0.050;
        isiJit = ints(set,indx) -0.050;
        durations(z,1)= durs(set,indx)+jitArray(jitCount)*durJit;
        intervals(z,1) = ints(set,indx)-jitArray(jitCount)*isiJit;
        jitCount = jitCount + 1;
    else
        durJit = durs(set,indx)-0.050;
        isiJit = ints(set,indx)-0.050;
        durations(z,1) = durs(set,indx)+jitArray(jitCount)*durJit;
        intervals(z-1,1) = ints(set,indx)-jitArray(jitCount)*isiJit;
        jitCount = jitCount + 1;
    end;
end;


%start drawing the nonsymbolic number
%initial space for 0.1 secs
Priority(MaxPriority(w));
vbl = Screen('Flip', w);
% Length of time and number of frames we will use for each drawing test
numSecs = 0.1;
numFrames = numSecs / ifi;

for frame = 1:numFrames
    % Flip to the screen
    vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);
end
Priority(0);


Priority(MaxPriority(w));
vbl = Screen('Flip', w);
for i = 1:num
    % Length of time and number of frames we will use for each drawing test
    numSecs = durations(i,1);
    numFrames = numSecs / ifi;   
    
    for frame = 1:numFrames
        Screen('FillOval', w, white, fix_cord);	% draw fixation dot (flip erases it)
        % Tell PTB no more drawing commands will be issued until the next flip
        Screen('DrawingFinished', w);
        % Flip to the screen
        if frame == 1
            onsets(i,1) = vbl + (waitframes - 0.5) * ifi-start_trigger;
        end;
        vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);

    end
    ends(i,1) = vbl + (waitframes - 0.5) * ifi-start_trigger;
    
    
    if i ~= num
        numSecs = intervals(i,1);
        numFrames = numSecs / ifi;
        for frame = 1:numFrames
            % Flip to the screen
            vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);
        end
    end;
end;
Priority(0);
start_sample = onsets(1,1);
dur_sample = vbl + (waitframes - 0.5) * ifi-start_sample-start_trigger;

Priority(MaxPriority(w));
vbl = Screen('Flip', w);
% Length of time and number of frames we will use for each drawing test
numSecs = 0.1;
numFrames = numSecs / ifi;

for frame = 1:numFrames
    % Flip to the screen
    vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);
end
Priority(0);

total_dur = 0;
total_isi = 0;
for i = 1:num
    total_dur = total_dur + ends(i,1)- onsets(i,1);
    if i ~= num
        total_isi = total_isi + onsets(i+1) - ends(i,1);
    end;
end;

avg_dur = total_dur/num;
avg_isi = total_isi/(num-1);
dur = mean(durations(:,1));
isi = mean(intervals(:,1));