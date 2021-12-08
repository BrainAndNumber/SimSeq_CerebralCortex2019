function RunExp()

%author: Seda Cavdaroglu, 17/07/13
AssertOpenGL;


%get subject number before starting the task
prompt = {'Subject Number:','Block No'};
dlg_title = 'Input';
num_lines = 1;
def = {'',''};
answer = inputdlg(prompt,dlg_title,num_lines,def);
subNo =str2num(char(answer(1)));
block_no = str2num(char(answer(2)));



%define colors
black = [0 0 0];
white = [255 255 255];

screens=Screen('Screens');
screenNumber=1;%max(screens);
[w, rect] = Screen('OpenWindow', screenNumber, black);

%use the 5 key to start the task
kc_s = KbName('5%');
kc_esc = KbName('esc');


% Do initial flip...
Screen('Flip',w);
[center(1), center(2)] = RectCenter(rect);

% 
% Screen('Flip',w);
% [center(1), center(2)] = RectCenter(rect);
% keyFile = strcat('log_files\',num2str(subNo),'_keys.txt');
% if block_no == 1
%     [keyIsDown secs keycodes] = KbCheck();
%     while isempty(keycodes) || ~keycodes(kc_esc)    
%         Screen('DrawText', w, 'Press the left key', center(1)-200, center(2),white);
%         Screen('Flip', w);
%         str_left = KbName();
%         while ~keycodes(kc_esc)
%             Screen('DrawText', w, str_left, center(1)-100, center(2),white);
%             Screen('Flip', w);
%             [keyIsDown secs keycodes] = KbCheck();
%         end;
%     end;
% 
%     vbl = Screen('Flip', w);
% 
%     keycodes(kc_esc) = 0;
%     [keyIsDown secs keycodes] = KbCheck();
%     keycodes(kc_esc) = 0;
% 
%     while ~keycodes(kc_esc)
% 
%         Screen('DrawText', w, 'Press the right key', center(1)-200, center(2),white);
%         Screen('Flip', w);
%         str_right = KbName();
%         while ~keycodes(kc_s)
%             Screen('DrawText', w, str_right, center(1)-100, center(2),white);
%             Screen('Flip', w);
%             [keyIsDown secs keycodes] = KbCheck();
%         end;
%     end;
%     %clean the screen
%     Screen('Flip', w);..............................................
%     
% 
%     fid = fopen(keyFile,'wt');
%     fprintf(fid,'%s\t',str_left);
%     fprintf(fid,'%s\t',str_right);
% end;
% 
% 
% keycodes(kc_s) = 0;
[keyIsDown secs keycodes] = KbCheck();
keycodes(kc_s) = 0;
while ~keycodes(kc_s)
    Screen('DrawText', w, 'Waiting for the trigger...', center(1)-200, center(2),white);
    vbl = Screen('Flip', w);
    [keyIsDown secs keycodes] = KbCheck();
end;

vbl = Screen('Flip', w);

PlayNums(w,rect,subNo,vbl,block_no);
[keyIsDown secs keycodes] = KbCheck();
keyIsDown = 0;
while ~keyIsDown
    [keyIsDown secs keycodes] = KbCheck();
    Screen('DrawText', w, 'End of the block... You can relax...', center(1)-300, center(2));
    Screen('Flip', w);
end;
%clean the screen
Screen('Flip', w);

Screen('CloseAll');