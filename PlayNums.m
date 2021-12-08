function PlayNums(w,rect,subNo,start_trigger,block)

%author: Seda Cavdaroglu, 05/11/14
AssertOpenGL;

%define colors
black = [0 0 0];
red = [255 0 0];
blue = [0 0 255];
white = [255 255 255];
green = [0 255 0];


% Do initial flip...
vbl = Screen('Flip', w);
% Measure the vertical refresh rate of the monitor
ifi = Screen('GetFlipInterval', w);
% Numer of frames to wait when specifying good timing
waitframes = 1;


%screen parameters
kc_esc = KbName('esc');
mon_width   = 50;   % horizontal dimension of viewable screen (cm)
v_dist      = 68;   % viewing distance (cm)
fix_r       = 0.3; % radius of fixation point (deg)
[center(1), center(2)] = RectCenter(rect);

ppd = pi * (rect(3)-rect(1)) / atan(mon_width/v_dist/2) / 360;    % pixels per degree
fix_cord = [center-fix_r*ppd center+fix_r*ppd];
[X,Y] = RectCenter(rect);
FixCross = [X-2,Y-12,X+2,Y+12;X-12,Y-2,X+12,Y+2];
winWidth = rect(3);
winHeight = rect(4);
[center(1), center(2)] = RectCenter(rect);
fix_r       = 0.3; % radius of fixation point (deg)
kc_esc = KbName('esc');
kc_lctrl = KbName('1!');
kc_rctrl = KbName('4$');
% kc_lctrl = KbName('left_control');
% kc_rctrl = KbName('right_control');
% [str_left str_right] = textread(keyFile, '%s %s');
% kc_lctrl = KbName(str_left);
% kc_rctrl = KbName(str_right);

HideCursor;	% Hide the mouse cursor
Priority(MaxPriority(w));
%%

%durations to be used for the fixation point
fixDurs = [4594,4649,4564,4845,4144,5444,4545,5227,4297,4228,4843,4977,5135,4071,5340,4512,6818,4173,5224,4613,4641,5058,4493,4566,5606,4556,5134,5938,...
5016,4167,4892,4569,5085,4386,5079,8542,4848,5541,4704,5579,4422,6616,4452,4104,4301,4665,5242,5331,4237,4681,5603,8872,5568,4501,4899,4688];


fixDurs = fixDurs./1000;
trialOrder = [1,2,2,4,4,5,5,1,3,1,1,3,5,5,1,3,3,2,3,4,4,5,1,1,3,3,3,2,1,3,3,5,3,4,3,4,3,1,2,2,1,1,1,3,2,1,1,3,2,1,5,5,3,1,4,4];
% 1 = sequential no comparison, 2 = sequential comparison, 3 = simultaneous no comparison, 4 = simultaneous comparison
% 5 = fixation


blueDur = 1; %duration of the blue fixation point in response trials
dotArrayDur = 0.2; %duration of the dot arrays

numList = [5,7,11,16];
numsSimNoComp = [5,1;5,0;7,1;7,0;11,1;11,0;16,1;16,0;5,1;5,0;7,1;7,0;11,1;11,0;16,1;16,0];
numsSimComp = [5,4;5,6;7,5;7,9;11,8;11,14;16,12;16,20];
numsSeqNoComp = [5,1;5,2;5,3;5,4;7,1;7,2;7,3;7,4;11,1;11,2;11,3;11,4;16,1;16,2;16,3;16,4];
numsSeqComp = [5,4;5,6;7,5;7,9;11,8;11,14;16,12;16,20];



numsSimNoComp = shuffle(numsSimNoComp); %shuffle shuffles the combinations; i.e. (5,4) and (16,12) still remain same instead of having (5,12) and (16,4) for example. Shuffle does the second (shuffle vs Shuffle)
numsSimComp = shuffle(numsSimComp);
numsSeqNoComp = shuffle(numsSeqNoComp);
numsSeqComp = shuffle(numsSeqComp);
% numsSeqDiffNoComp = shuffle(numsSeqDiffNoComp);
% numsSeqDiffComp = shuffle(numsSeqDiffComp);

setsSeqComp = [1,2;1,3;1,4;2,1;2,3;2,4;3,1;3,2;3,4;4,1;4,2;4,3];
setsSeqComp = shuffle(setsSeqComp);
% setsSeqNoComp = [1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4];
% setsSeqNoComp = Shuffle(setsSeqNoComp);
countSeqComp = 1;
countSeqNoComp = 1;
listSimComp = [0,1;0,1;0,1;0,1];
listSimComp = shuffle(listSimComp); 
countSimNoCompToa = [1,1,1,1];
countSimNoCompItemSize = [1,1,1,1];
countSimComp = 1;
countSimCompList = [1,1,1,1];
countSimNoComp = 1;

trialNo = (block-1)*length(trialOrder)+1;
logFile = strcat('log_files\',num2str(subNo),'.txt');

%open the text file to write the output
if subNo ~= 999
    fid = fopen(logFile,'at');
else
    fid = fopen('tmp.txt','at');
end;


%read the properties of the simultaneous data into a matrix
dotArray = dlmread('dot_images\sensoryFeatures.txt');


if block == 1
        
    output_list = {'subject','block','trial_no','type','number','set','test_num','test_set','start_trigger',...
        'start_fix','dur_fix','start_num','dur_num','test_red_fix_start','test_red_fix_dur','test_blue_fix_start',...
        'test_blue_fix_dur','start_test_num','dur_test_num','start_green_fix_ans_test','dur_green_fix_ans_test','resp_time','test_corr_ans',...
        'test_sub_ans','test_sub_ans_corr_or_not','surface1','surface2','filename1','filename2',...
        'avg_dot_dur_sample','avg_isi_sample','dot_dur_sample','isi_sample','surface_sample','totalSurface_sample','circumf_sample','diameter_sample','convHull_sample','density_sample',...
        'avg_dot_dur_test','avg_isi_test','dot_dur_test','isi_test','surface_test','totalSurface_test','circumf_test','diameter_test','convHull_test','density_test',...
        'onset1','end1','onset2','end2','onset3','end3','onset4','end4','onset5','end5','onset6','end6','onset7','end7','onset8','end8',...
        'onset9','end9','onset10','end10','onset11','end11','onset12','end12','onset13','end13','onset14','end14','onset15','end15','onset16','end16',...
        'test_onset1','test_end1','test_onset2','test_end2','test_onset3','test_end3','test_onset4','test_end4','test_onset5','test_end5',...
        'test_onset6','test_end6','test_onset7','test_end7','test_onset8','test_end8','test_onset9','test_end9','test_onset10','test_end10',...
        'test_onset11','test_end11','test_onset12','test_end12','test_onset13','test_end13','test_onset14','test_end14','test_onset15','test_end15','test_onset16',...
        'test_end16','test_onset17','test_end17','test_onset18','test_end18','test_onset19','test_end19','test_onset20','test_end20','red_press','blue_press'};
    
    for z = 1:length(output_list)
        fprintf(fid,'%s\t',output_list{z});
    end;
    %jump to the next line in the output file
    fprintf(fid,'%s\n','');
end;

filename = 'C:\Users\bcanguest\Documents\PsychToolbox Experiments\AG_KNOPS\SedaProject2\dot_images\sensoryFeatures.txt';
filename = 'D:\Zahlensinn HU\Seda\fMRI2\experiment\dot_images\sensoryFeatures.txt';
[numerosity rep surface totalSurface circumf totalCircumf diameter convHull density toa] = textread(filename, '%d %f %f %f %f %f %f %f %f %f', 528);
totalSurf = shuffle(totalSurface);



%Display an initial red fixation cross for 8s
[x,y,pressed] = Fixation(w,rect,mon_width,v_dist,8,red,start_trigger);
% Do initial flip...
vbl = Screen('Flip', w);
for i = 1:length(fixDurs)
    onsets = zeros(16,1); %holds the starting time of each visual flash
    ends = zeros(16,1); %holds the end time of each visual flash
    test_onsets = zeros(20,1); %holds the starting time of each visual flash for test nums
    test_ends = zeros(20,1); %holds the end time of each visual flash for test nums
    
    
    pressed = -1;
    resp_time = -1;
    test_sub_ans = -1;
    test_sub_ans_corr_or_not = -1;
    pressed_red1 = 0;
    pressed_red2 = 0;
    pressed_blue = 0;
    
    Priority(MaxPriority(w));
    % Length of time and number of frames we will use for each drawing test
    numSecs = 0.1;
    numFrames = round(numSecs / ifi);


    for frame = 1:numFrames
        % Flip to the screen
        vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);
    end
    Priority(0);
    
    
    if trialOrder(i) == 1 %Dot arrays without comparison
        list = numsSimNoComp(countSimNoComp,2);
        number = numsSimNoComp(countSimNoComp,1);
        if list == 1 %toa
            tmp = (block-1)*3+countSimNoCompToa(find(numList == number));
            fileName = strcat('C:\Users\bcanguest\Documents\PsychToolbox Experiments\AG_KNOPS\SedaProject2\dot_images\toah_',int2str(number),'_',int2str(tmp),'.bmp');
            countSimNoCompToa(find(numList == number))= countSimNoCompToa(find(numList == number))+1;
        else
            tmp = (block-1)*3+countSimNoCompItemSize(find(numList == number));
            fileName = strcat('C:\Users\bcanguest\Documents\PsychToolbox Experiments\AG_KNOPS\SedaProject2\dot_images\itemsizeh_',int2str(number),'_',int2str(tmp),'.bmp');
            countSimNoCompItemSize(find(numList == number))= countSimNoCompItemSize(find(numList == number))+1;
        end;
        row_sample = find(dotArray(:,1)==numsSimNoComp(countSimNoComp,1) & dotArray(:,2) ==tmp & dotArray(:,10)==list);


        
        Priority(MaxPriority(w));
        % Length of time and number of frames we will use for each drawing test
        numSecs = dotArrayDur;
        numFrames = round(numSecs / ifi);
        
        
        for frame = 1:numFrames            
            [img] = imread(fileName,'bmp');
            Screen(w,'PutImage',img,[winWidth/2-205.5 winHeight/2-205.5 winWidth/2+205.5 winHeight/2+205.5]);
            % Tell PTB no more drawing commands will be issued until the next flip
            Screen('DrawingFinished', w);
            % Flip to the screen
            if frame == 1
                start_num = vbl + (waitframes - 0.5) * ifi-start_trigger;
            end;
            vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);  

        end
        Priority(0);                       
        dur_num = vbl + (waitframes - 0.5) * ifi-start_num-start_trigger;
        
        
        [start_fix,dur_fix,pressed_red1] = Fixation(w,rect,mon_width,v_dist,fixDurs(i),red,start_trigger);
        output_list = {int2str(subNo),int2str(block),int2str(trialNo),int2str(trialOrder(i)),int2str(numsSimNoComp(countSimNoComp)),'-1','-1','-1',...
            num2str(start_trigger),num2str(start_fix,'%.4f'),num2str(dur_fix,'%.4f'),num2str(start_num,'%.4f'),num2str(dur_num,'%.4f'),'-1','-1','-1',...
            '-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1',fileName,'-1','-1','-1',...
            '-1','-1',num2str(dotArray(row_sample,3),'%.4f'),...
            num2str(dotArray(row_sample,4),'%.4f'),num2str(dotArray(row_sample,5),'%.4f'), num2str(dotArray(row_sample,7),'%.4f'),...
            num2str(dotArray(row_sample,8),'%.4f'),num2str(dotArray(row_sample,9),'%.4f'),'-1','-1','-1','-1','-1','-1','-1','-1','-1','-1'};    
        
        countSimNoComp = countSimNoComp + 1;
    elseif trialOrder(i) == 2 %dot arrays with comparison
        number1 = numsSimComp(countSimComp,1);
        number2 = numsSimComp(countSimComp,2);
        list = listSimComp(find(number1 == numList),countSimCompList(find(number1 == numList)));
        disp(list);
        countSimCompList(find(number1 == numList)) = countSimCompList(find(number1 == numList)) + 1;
        if list == 1 %toa
            tmp = (block-1)*3+3;
            fileName = strcat('C:\Users\bcanguest\Documents\PsychToolbox Experiments\AG_KNOPS\SedaProject2\dot_images\toah_',int2str(number1),'_',int2str(tmp),'.bmp');
            fileName2 = strcat('C:\Users\bcanguest\Documents\PsychToolbox Experiments\AG_KNOPS\SedaProject2\dot_images\itemsizeh_',int2str(number2),'_',int2str(tmp),'.bmp');
        else
            tmp = (block-1)*3+3;
            fileName = strcat('C:\Users\bcanguest\Documents\PsychToolbox Experiments\AG_KNOPS\SedaProject2\dot_images\itemsizeh_',int2str(number1),'_',int2str(tmp),'.bmp');
            fileName2 = strcat('C:\Users\bcanguest\Documents\PsychToolbox Experiments\AG_KNOPS\SedaProject2\dot_images\toah_',int2str(number2),'_',int2str(tmp),'.bmp');
        end;        
        row_sample = find(dotArray(:,1)==number1 & dotArray(:,2) ==tmp & dotArray(:,10)==list);
        row_test = find(dotArray(:,1)==number2 & dotArray(:,2) ==tmp & dotArray(:,10)~=list);

        
        Priority(MaxPriority(w));

        % Length of time and number of frames we will use for each drawing test
        numSecs = dotArrayDur;
        numFrames = round(numSecs / ifi);
        
        
        for frame = 1:numFrames            
            [img] = imread(fileName,'bmp');
            Screen(w,'PutImage',img,[winWidth/2-205.5 winHeight/2-205.5 winWidth/2+205.5 winHeight/2+205.5]);
            % Tell PTB no more drawing commands will be issued until the next flip
            Screen('DrawingFinished', w);
            % Flip to the screen
            if frame == 1
                start_num = vbl + (waitframes - 0.5) * ifi-start_trigger;
            end;
            vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);  

        end
        Priority(0);
        dur_num = vbl + (waitframes - 0.5) * ifi-start_num-start_trigger;

       
        
        %display the second numerosity       
        if numsSimComp(countSimComp,1) < numsSimComp(countSimComp,2)
            test_corr_ans = 1;
        else
            test_corr_ans = 0;
        end;
        %test_corr_ans = numsSim(countSim,1) < numsSim(countSim,2); %0 = left, 1  = right
        [test_red_fix_start,test_red_fix_dur,pressed_red1] = Fixation(w,rect,mon_width,v_dist,fixDurs(i),red,start_trigger);
        [test_blue_fix_start,test_blue_fix_dur,pressed_blue] = Fixation(w,rect,mon_width,v_dist,blueDur,blue,start_trigger);
        
        %initial space for 0.1 secs
        Priority(MaxPriority(w));
        % Length of time and number of frames we will use for each drawing test
        numSecs = 0.1;
        numFrames = round(numSecs / ifi);


        for frame = 1:numFrames
            % Flip to the screen
            vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);
        end


        % Length of time and number of frames we will use for each drawing test
        numSecs = dotArrayDur;
        numFrames = round(numSecs / ifi);
        

        for frame = 1:numFrames            
            [img] = imread(fileName2,'bmp');
            Screen(w,'PutImage',img,[winWidth/2-205.5 winHeight/2-205.5 winWidth/2+205.5 winHeight/2+205.5]);
            % Tell PTB no more drawing commands will be issued until the next flip
            Screen('DrawingFinished', w);
            % Flip to the screen
            if frame == 1
                start_test_num = vbl + (waitframes - 0.5) * ifi-start_trigger;
            end;
            vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);  
        end
        Priority(0);
        dur_test_num = vbl + (waitframes - 0.5) * ifi-start_test_num-start_trigger;


        %space after the dot array for 0.1 secs
        Priority(MaxPriority(w));
        % Length of time and number of frames we will use for each drawing test
        numSecs = 0.1;
        numFrames = round(numSecs / ifi);        
        
        for frame = 1:numFrames
            % Flip to the screen
            vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);
        end
        Priority(0);
        
        
        
        Priority(MaxPriority(w));
        % Length of time and number of frames we will use for each drawing test
        numSecs = 2;
        numFrames = round(numSecs / ifi);
        
        start_green_ans = tic;
        for frame = 1:numFrames            
            Screen('FillRect', w, green, FixCross');
            % Tell PTB no more drawing commands will be issued until the next flip
            Screen('DrawingFinished', w);
            % Flip to the screen
            if frame == 1
                start_green_fix_ans_test = vbl + (waitframes - 0.5) * ifi-start_trigger;
            end;
            vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);  

            % now define a string for each type of key press.
            [keyIsDown secs keycodes] = KbCheck();
            if ~isempty(keycodes)                
                if keycodes(kc_esc)
                    fclose(fid);
                    Priority(0);
                    ShowCursor;
                    Screen('CloseAll');
                elseif keycodes(kc_lctrl)
                    resp_time = toc(start_green_ans);
                    %subject pressed a button
                    pressed = 1;
                    test_sub_ans = 0; % 0 = left, 1 = right     
                    test_sub_ans_corr_or_not = (test_sub_ans == test_corr_ans);
                elseif keycodes(kc_rctrl)
                    resp_time = toc(start_green_ans);
                    %subject pressed a button
                    pressed = 1;
                    test_sub_ans = 1; % 0 = left, 1 = right
                    test_sub_ans_corr_or_not = (test_sub_ans == test_corr_ans);
                end;
            end;
        end
        Priority(0);


        %if the subject did not give any answer, then save it as -1
        %disp(pressed);
        if ~pressed
            test_sub_ans = -1;
            test_sub_ans_corr_or_not = -1;
        end;
        dur_green_fix_ans_test = vbl + (waitframes - 0.5) * ifi-start_green_fix_ans_test-start_trigger;
%         dur_green_fix_ans_test = toc(start_green_ans);

        [start_fix,dur_fix,pressed_red2] = Fixation(w,rect,mon_width,v_dist,fixDurs(i),red,start_trigger);
        output_list = {int2str(subNo),int2str(block),int2str(trialNo),int2str(trialOrder(i)),int2str(numsSimComp(countSimComp,1)),'-1',int2str(numsSimComp(countSimComp,2)),...
            '-1',num2str(start_trigger),num2str(start_fix,'%.4f'),num2str(dur_fix,'%.4f'),num2str(start_num,'%.4f'),num2str(dur_num,'%.4f'),num2str(test_red_fix_start,'%.4f'),...
            num2str(test_red_fix_dur,'%.4f'),num2str(test_blue_fix_start,'%.4f'),num2str(test_blue_fix_dur,'%.4f'),num2str(start_test_num,'%.4f'),num2str(dur_test_num,'%.4f'),...
            num2str(start_green_fix_ans_test,'%.4f'),num2str(dur_green_fix_ans_test,'%.4f'),num2str(resp_time,'%.4f'),int2str(test_corr_ans),int2str(test_sub_ans),...
            int2str(test_sub_ans_corr_or_not),'-1','-1',fileName,fileName2,'-1','-1','-1','-1',...
            num2str(dotArray(row_sample,3),'%.4f'),num2str(dotArray(row_sample,4),'%.4f'),num2str(dotArray(row_sample,5),'%.4f'), num2str(dotArray(row_sample,7),'%.4f'),...
            num2str(dotArray(row_sample,8),'%.4f'),num2str(dotArray(row_sample,9),'%.4f'),'-1','-1','-1','-1',num2str(dotArray(row_test,3),'%.4f'),num2str(dotArray(row_test,4),'%.4f'),...
            num2str(dotArray(row_test,5),'%.4f'),num2str(dotArray(row_test,7),'%.4f'),num2str(dotArray(row_test,8),'%.4f'),num2str(dotArray(row_test,9),'%.4f')};
        countSimComp = countSimComp + 1;
        
                
    elseif trialOrder(i) == 3 %sequential without comparison
        surface1 = totalSurf(trialNo-(block-1)*length(trialOrder));
        [start_num,dur_num,onsets,ends,avg_dur,avg_isi,dur,isi] = DrawSample(w,rect,numsSeqNoComp(countSeqNoComp,1),numsSeqNoComp(countSeqNoComp,2),surface1,start_trigger);%Draws the stimuli in non-response trials
        
        
        [start_fix,dur_fix,pressed_red1] = Fixation(w,rect,mon_width,v_dist,fixDurs(i),red,start_trigger);
        output_list = {int2str(subNo),int2str(block),int2str(trialNo),int2str(trialOrder(i)),int2str(numsSeqNoComp(countSeqNoComp,1)),int2str(numsSeqNoComp(countSeqNoComp,2)),'-1',...
            '-1',num2str(start_trigger),num2str(start_fix,'%.4f'),num2str(dur_fix,'%.4f'),num2str(start_num,'%.4f'),num2str(dur_num,'%.4f'),'-1','-1',...
            '-1','-1','-1','-1','-1','-1','-1','-1','-1','-1',num2str(surface1/(2*pi)),'-1','-1','-1',num2str(avg_dur,'%.4f'),num2str(avg_isi,'%.4f'),num2str(dur,'%.4f'),num2str(isi,'%.4f'),...
            '-1','-1','-1', '-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1'};
            

        countSeqNoComp = countSeqNoComp + 1;
        
    elseif trialOrder(i) == 4 %sequential with comparison
        tmp = trialNo-(block-1)*length(trialOrder);
        surface1 = totalSurf(trialNo-(block-1)*length(trialOrder));
        disp('surface');
        disp(surface1);
        [start_num,dur_num,onsets,ends,avg_dur_sample,avg_isi_sample,dur_sample,isi_sample] = DrawSample(w,rect,numsSeqComp(countSeqComp,1),setsSeqComp(countSeqComp,1),surface1,start_trigger);%Draws the 2nd stimuli in response trials
        
        resp_time = -1;
        
        
        testNumber = numsSeqComp(countSeqComp,2);
        test_corr_ans = numsSeqComp(countSeqComp,1) < numsSeqComp(countSeqComp,2); %0 = left, 1  = right
        [test_red_fix_start,test_red_fix_dur,pressed_red1] = Fixation(w,rect,mon_width,v_dist,fixDurs(i),red,start_trigger);
        [test_blue_fix_start,test_blue_fix_dur,pressed_blue] = Fixation(w,rect,mon_width,v_dist,blueDur,blue,start_trigger);
        surface2 = totalSurf(trialNo-(block-1)*length(trialOrder));
        [start_test_num,dur_test_num,test_onsets,test_ends,avg_dur_test,avg_isi_test,dur_test,isi_test] = DrawTest(w,rect,testNumber,setsSeqComp(countSeqComp,2),surface1,start_trigger);%Draws the 2nd stimuli in response trials
        


        Priority(MaxPriority(w));
        % Length of time and number of frames we will use for each drawing test
        numSecs = 2;
        numFrames = round(numSecs / ifi);
        
        start_green_ans = tic;
        for frame = 1:numFrames            
            Screen('FillRect', w, green, FixCross');
            % Tell PTB no more drawing commands will be issued until the next flip
            Screen('DrawingFinished', w);
            % Flip to the screen
            if frame == 1
                start_green_fix_ans_test = vbl + (waitframes - 0.5) * ifi-start_trigger;
            end;
            vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);  

            % now define a string for each type of key press.
            [keyIsDown secs keycodes] = KbCheck();
            if ~isempty(keycodes)                
                if keycodes(kc_esc)
                    fclose(fid);
                    Priority(0);
                    ShowCursor;
                    Screen('CloseAll');
                elseif keycodes(kc_lctrl)
                    resp_time = toc(start_green_ans);
                    %subject pressed a button
                    pressed = 1;
                    test_sub_ans = 0; % 0 = left, 1 = right     
                    test_sub_ans_corr_or_not = (test_sub_ans == test_corr_ans);
                elseif keycodes(kc_rctrl)
                    resp_time = toc(start_green_ans);
                    %subject pressed a button
                    pressed = 1;
                    test_sub_ans = 1; % 0 = left, 1 = right
                    test_sub_ans_corr_or_not = (test_sub_ans == test_corr_ans);
                end;
            end;
        end
        Priority(0);
        %if the subject did not give any answer, then save it as -1
        %disp(pressed);
        if ~pressed
            test_sub_ans = -1;
            test_sub_ans_corr_or_not = -1;
        end;
        dur_green_fix_ans_test = vbl + (waitframes - 0.5) * ifi-start_green_fix_ans_test-start_trigger;

        [start_fix,dur_fix,pressed_red2] = Fixation(w,rect,mon_width,v_dist,fixDurs(i),red,start_trigger);
        output_list = {int2str(subNo),int2str(block),int2str(trialNo),int2str(trialOrder(i)),int2str(numsSeqComp(countSeqComp,1)),int2str(setsSeqComp(countSeqComp,1)),int2str(numsSeqComp(countSeqComp,2)),...
            int2str(setsSeqComp(countSeqComp,2)),num2str(start_trigger),num2str(start_fix,'%.4f'),num2str(dur_fix,'%.4f'),num2str(start_num,'%.4f'),num2str(dur_num,'%.4f'),num2str(test_red_fix_start,'%.4f'),...
            num2str(test_red_fix_dur,'%.4f'),num2str(test_blue_fix_start,'%.4f'),num2str(test_blue_fix_dur,'%.4f'),num2str(start_test_num,'%.4f'),num2str(dur_test_num,'%.4f'),...
            num2str(start_green_fix_ans_test,'%.4f'),num2str(dur_green_fix_ans_test,'%.4f'),num2str(resp_time,'%.4f'),int2str(test_corr_ans),int2str(test_sub_ans),int2str(test_sub_ans_corr_or_not),...
            num2str(surface1/(2*pi)),num2str(surface1/(2*pi)),'-1','-1',num2str(avg_dur_sample,'%.4f'),num2str(avg_isi_sample,'%.4f'),num2str(dur_sample,'%.4f'),num2str(isi_sample,'%.4f'),...
            '-1','-1','-1', '-1','-1','-1',num2str(avg_dur_test,'%.4f'),num2str(avg_isi_test,'%.4f'),num2str(dur_test,'%.4f'),num2str(isi_test,'%.4f'),'-1','-1','-1','-1','-1','-1'};
            
        countSeqComp = countSeqComp + 1;
        
 %     elseif trialOrder(i) == 5 %sequential in different locations without comparison
%         [start_num,dur_num,onsets,ends] = DrawSampleDiff(w,rect,numsSeqDiffNoComp(countSeqDiffNoComp),setsSeqDiffNoComp(countSeqDiffNoComp),expTimer);%Draws the stimuli in non-response trials
%         
%         
%         [start_fix,dur_fix] = Fixation(w,rect,mon_width,v_dist,fixDurs(i),red,expTimer);
%         output_list = {int2str(subNo),int2str(block),int2str(trialNo),int2str(trialOrder(i)),int2str(numsSeqNoComp(countSeqDiffNoComp)),int2str(setsSeqDiffNoComp(countSeqDiffNoComp)),'-1','-1',num2str(start_trigger),num2str(start_fix,'%.4f'),num2str(dur_fix,'%.4f'),num2str(start_num,'%.4f'),num2str(dur_num,'%.4f'),'-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1'};
%         countSeqDiffNoComp = countSeqDiffNoComp + 1;
%         
%         
%     elseif trialOrder(i) == 6 %sequential in different locations with comparison
%         [start_num,dur_num,onsets,ends] = DrawSampleDiff(w,rect,numsSeqDiffComp(countSeqDiffComp,1),setsSeqDiffComp(countSeqDiffNoComp,1),expTimer);%Draws the 2nd stimuli in response trials
%         
%         resp_time = NaN;
%         
%         
%         Screen('Flip',w);
%         testNumber = numsSeqDiffComp(countSeqDiffComp,2);
%         test_corr_ans = numsSeqDiffComp(countSeqDiffComp,1) < numsSeqDiffComp(countSeqDiffComp,2); %0 = left, 1  = right
%         [test_red_fix_start,test_red_fix_dur] = Fixation(w,rect,mon_width,v_dist,fixDurs(i),red,expTimer);
%         [test_blue_fix_start,test_blue_fix_dur] = Fixation(w,rect,mon_width,v_dist,blueDur,blue,expTimer);
%         
%         [start_test_num,dur_test_num,test_onsets,test_ends] = DrawTestDiff(w,rect,testNumber,setsSeqDiffComp(countSeqDiffComp,2),expTimer);%Draws the 2nd stimuli in response trials
%         
%         
%         t1 = timer('TimerFcn', 'stat=false','StartDelay',2);
%         start(t1);
%         %pressed = 0; %parameter to chech if the subject has pressed any buttons or missed the answer
%         Screen('FillRect', w, green, FixCross');
%         Screen('Flip',w);
%         start_green_fix_ans_test = toc(expTimer);
%         start_green_ans = tic;
%         while(strcmp(get(t1,'Running'),'on'))
%             % now define a string for each type of key press.
%             [keyIsDown secs keycodes] = KbCheck();
%             if ~isempty(keycodes)
%                 
%                 if keycodes(kc_esc)
%                     fclose(fid);
%                     Priority(0);
%                     ShowCursor;
%                     Screen('CloseAll');
%                 elseif keycodes(kc_lctrl)
%                     resp_time = toc(start_green_ans);
%                     %subject pressed a button
%                     pressed = 1;
%                     test_sub_ans = 0; % 0 = left, 1 = right
%                     if test_corr_ans == 1
%                         test_sub_ans_corr_or_not = 0;
%                     else
%                         test_sub_ans_corr_or_not = 1;
%                     end;
%                     
%                 elseif keycodes(kc_rctrl)
%                     resp_time = toc(start_green_ans);
%                     %subject pressed a button
%                     pressed = 1;
%                     test_sub_ans = 1; % 0 = left, 1 = right
%                     if test_corr_ans == 1
%                         test_sub_ans_corr_or_not = 1;
%                     else
%                         test_sub_ans_corr_or_not = 0;
%                     end;
%                 end;
%             end;
%         end;
%          %if the subject did not give any answer, then save it as -1
%         %disp(pressed);
%         if ~pressed
%             test_sub_ans = -1;
%             test_sub_ans_corr_or_not = -1;
%         end;
%         Screen('Flip',w);
%         dur_green_fix_ans_test = toc(start_green_ans);
%         [start_fix,dur_fix] = Fixation(w,rect,mon_width,v_dist,fixDurs(i),red,expTimer);
%         output_list = {int2str(subNo),int2str(block),int2str(trialNo),int2str(trialOrder(i)),int2str(numsSeqDiffComp(countSeqDiffComp,1)),int2str(setsSeqDiffComp(countSeqDiffComp,1)),int2str(numsSeqDiffComp(countSeqDiffComp,2)),int2str(setsSeqDiffComp(countSeqDiffComp,2)),num2str(start_trigger),num2str(start_fix,'%.4f'),num2str(dur_fix,'%.4f'),num2str(start_num,'%.4f'),num2str(dur_num,'%.4f'),num2str(test_red_fix_start,'%.4f'),num2str(test_red_fix_dur,'%.4f'),num2str(test_blue_fix_start,'%.4f'),num2str(test_blue_fix_dur,'%.4f'),num2str(start_test_num,'%.4f'),num2str(dur_test_num,'%.4f'),num2str(start_green_fix_ans_test,'%.4f'),num2str(dur_green_fix_ans_test,'%.4f'),num2str(resp_time,'%.4f'),int2str(test_corr_ans),int2str(test_sub_ans),int2str(test_sub_ans_corr_or_not)};
%         countSeqDiffComp = countSeqDiffComp + 1;
        
    elseif trialOrder(i) == 5 %fixation as a separate condition
        Priority(MaxPriority(w));

        % Length of time and number of frames we will use for each drawing test
        numSecs = 0.1;
        numFrames = round(numSecs / ifi);
        
        for frame = 1:numFrames
            % Flip to the screen
            vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);
        end
        
%         [start_num,dur_num,pressed_red1] = Fixation(w,rect,mon_width,v_dist,1.4,red,start_trigger); %average duration of a null event!
%         
%         Priority(MaxPriority(w));
%         % Length of time and number of frames we will use for each drawing test
%         numSecs = 0.1;
%         numFrames = round(numSecs / ifi);
%         
%         for frame = 1:numFrames
%             % Flip to the screen
%             vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);
%         end
%         
%         [start_fix,dur_fix,pressed_red2] = Fixation(w,rect,mon_width,v_dist,fixDurs(i),red,start_trigger);
%         
%         Priority(MaxPriority(w));
%         % Length of time and number of frames we will use for each drawing test
%         numSecs = 0.1;
%         numFrames = round(numSecs / ifi);
%         
%         for frame = 1:numFrames
%             % Flip to the screen
%             vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);
%         end


        [start_num,dur_num,pressed_red1] = Fixation(w,rect,mon_width,v_dist,1.4+fixDurs(i),red,start_trigger); %average duration of a null event!
        dur_fix = dur_num - 1.4;
        dur_num = dur_num - fixDurs(i);
        start_fix = start_num+1.4;

        
        Priority(MaxPriority(w));
        % Length of time and number of frames we will use for each drawing test
        numSecs = 0.1;
        numFrames = round(numSecs / ifi);
        
        for frame = 1:numFrames
            % Flip to the screen
            vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);
        end
        output_list = {int2str(subNo),int2str(block),int2str(trialNo),int2str(trialOrder(i)),'-1','-1','-1','-1',num2str(start_trigger),num2str(start_fix,'%.4f'),num2str(dur_fix,'%.4f'),num2str(start_num,'%.4f'),...
            num2str(dur_num,'%.4f'),'-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1'};
       
    end;
    
    
    %write the output info to the log file
    for z = 1:length(output_list)
        fprintf(fid,'%s\t',output_list{z});
    end;
    %write the onsets and end times of each dot into the log file
    for k = 1:length(onsets)
        fprintf(fid,'%s\t',num2str(onsets(k,1),'%.4f'));
        fprintf(fid,'%s\t',num2str(ends(k,1),'%.4f'));
    end;
    
    
    %write the onsets and end times of each test dot into the log file
    for k = 1:length(test_onsets)
        fprintf(fid,'%s\t',num2str(test_onsets(k,1),'%.4f'));
        fprintf(fid,'%s\t',num2str(test_ends(k,1),'%.4f'));
    end;
    
    tmp = pressed_red1+pressed_red2;
    fprintf(fid,'%s\t',int2str(tmp));
    fprintf(fid,'%s\t',int2str(pressed_blue));
    %jump to the next line in the output file
    fprintf(fid,'%s\n','');
    %string = GetEchoString(w,'Answer: ',center(1)-50,center(2),black,white);
    
    %space at the end of each trial for 0.1 secs
    Priority(MaxPriority(w));
    % Length of time and number of frames we will use for each drawing test
    numSecs = 0.1;
    numFrames = round(numSecs / ifi);
    
    for frame = 1:numFrames
        % Flip to the screen
        vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);
    end
    trialNo = trialNo + 1;
end;
Fixation(w,rect,mon_width,v_dist,8,red,start_trigger);

%close the output file
fclose(fid);