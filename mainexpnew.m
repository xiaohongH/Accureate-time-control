%Presents images in fMRI experiment
%Record responses of face/tool task.
try
    clear all;
    close all;
    clc;
    AssertOpenGL;
    oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 1);
    oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
    Screen('Preference','SkipSyncTests', 1);
    setupmainexp;
    
    %% Prepare Screen for Experiment
    HideCursor;
    %%Prep Screen
    screenNumber=max(Screen('Screens'));
    gray=GrayIndex(screenNumber);
    black=BlackIndex(screenNumber);
    %[window,screenRect]=Screen('OpenWindow',screenNumber,gray,[],8,2); % full SCREEN mode, in mid-level gray
    [window,screenRect]=Screen('OpenWindow',screenNumber,gray,[]);
    Screen('TextSize', window,30);
    %SETUP RECTS FOR IMAGE
    facerect1 = [0 0 stimwidth stimheight];
    facerect1 = CenterRect(facerect1, screenRect);
    facerect2 = [0 0 stimwidth stimheight];
    facerect2 = CenterRect(facerect2, screenRect);
    %% Prep Port
    if ~DEBUG
        [P4, openerror] = IOPort('OpenSerialPort', 'COM1','BaudRate=19200'); %opens port for receiving scanner pulse
        IOPort('Flush', P4); %flush event buffer
    end
    
    % SHOW READY TEXT
    DrawFormattedText(window, waitingtext, 'center', 'center', black);
    Screen('Flip', window); % Shows 'READY'
    % Prep for First Fixation
    DrawFormattedText(window, fixationtext, 'center', 'center', black);
    %% START TRIALS
    trial = 1;
    presentations = zeros(totalNum,6);
    botpress = zeros(totalNum,1);
    timepress = zeros(totalNum,1);
    checkTime = zeros(totalNum,9);
    % Prep Port
    while 1
        if ~DEBUG
            [pulse,temptime,readerror] = IOPort('read',P4,1,1);
            scanstart = GetSecs;
        else
            [keyIsDown,secs,keyCode] = KbCheck;
            if keyCode(83) % If s is pressed on the keyboard
                pulse = 83;
            end
            scanstart = GetSecs;
        end
        if ~isempty(pulse) && (pulse == 83)
            break;
        end
    end
    Screen('Flip', window); % Shows fixation
    begintime = GetSecs;
    while GetSecs - begintime < fixationtime1
    end
    fix=0;
    mar1=0;
    mar2=0;
    marbegin = 0;
    %totalNum == 24
    while trial <= totalNum
        starttime1 = GetSecs;
        %conditios == conditionrun*,totalNum=24
        %5:fixation start time;6:starttime1 --fixation end time,mask begin time
        presentations (trial,:) = [conditions(trial,:), begintime, starttime1];
        Soatime=conditions(trial,2);
        checkTime(trial,1) = conditions(trial,1);
        if trial==1
            checkTime(trial,6) = fix-mar2;
        else
            checkTime(trial-1,6) = fix-mar2;
        end
        %%
        %mask
        if conditions(trial,3) <= 2   %%face(1,2)+tool(5,6)= nois1(mask1)
            conditions(trial,4) ==5 || conditions(trial,4) == 6
            Screen('PutImage', window, nois1, facerect1);
            Screen('DrawingFinished', window);
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
        elseif conditions(trial,4) ==1 || conditions(trial,4) == 2
            conditions(trial,3) ==5 || conditions(trial,3) == 6
            Screen('PutImage', window, nois1, facerect1);
            Screen('DrawingFinished', window);
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
            %face(1,2)+tool(7,8)= nois2(mask2)
        elseif  conditions(trial,3) <= 2
            conditions(trial,4) ==7 || conditions(trial,4) == 8
            Screen('PutImage', window, nois2, facerect1);
            Screen('DrawingFinished', window);
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
        elseif conditions(trial,4) ==1 || conditions(trial,4) == 2
            conditions(trial,3) ==7 || conditions(trial,3) == 8
            Screen('PutImage', window, nois2, facerect1);
            Screen('DrawingFinished', window);
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
            %%%%%%%%%%%%%%%%%%%           %%face(3,4)+tool(5,6)= nois3(mask3)
        elseif  conditions(trial,3) == 3 || conditions(trial,3) == 4
            conditions(trial,4) ==5 || conditions(trial,4) == 6
            Screen('PutImage', window, nois3, facerect1);
            Screen('DrawingFinished', window);
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
        elseif  conditions(trial,4) == 3 || conditions(trial,4) == 4
            conditions(trial,3) ==5 || conditions(trial,3) == 6
            Screen('PutImage', window, nois3, facerect1);
            Screen('DrawingFinished', window);
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
            %%face(3,4)+tool(7,8)= nois4(mask4)
        elseif  conditions(trial,3) == 3 || conditions(trial,3) == 4
            conditions(trial,4) ==7 || conditions(trial,4) == 8
            Screen('PutImage', window, nois4, facerect1);
            Screen('DrawingFinished', window);
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
        elseif  conditions(trial,4) == 3 || conditions(trial,4) == 4
            conditions(trial,3) ==7 || conditions(trial,3) == 8
            Screen('PutImage', window, nois4, facerect1);
            Screen('DrawingFinished', window);
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
            %%
        elseif  conditions(trial,3) ==9 || conditions(trial,3) == 10     %overlap
            Screen('PutImage', window, nois1, facerect1);
            Screen('DrawingFinished', window);
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
        elseif  conditions(trial,3) ==11 || conditions(trial,3) == 12     %overlap
            Screen('PutImage', window, nois2, facerect1);
            Screen('DrawingFinished', window);
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
        elseif  conditions(trial,3) ==13 || conditions(trial,3) == 14     %overlap
            Screen('PutImage', window, nois3, facerect1);
            Screen('DrawingFinished', window);
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
        elseif  conditions(trial,3) ==15 || conditions(trial,3) == 16     %overlap
            Screen('PutImage', window, nois4, facerect1);
            Screen('DrawingFinished', window);
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
        end
        Screen('Flip', window);%show nois
        mar1 = GetSecs;
       
     
        
        %%
        %when masking time ,prepare the image;masktime1=0.5
        %starttime1 --fixation end time,mask begin time
        while GetSecs - starttime1 <= masktime1
            if conditions(trial,3) == 1
                Screen('PutImage', window, face1, facerect1);
                Screen('DrawingFinished', window);
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            elseif conditions(trial,3) == 2
                Screen('PutImage', window, face2, facerect1);
                Screen('DrawingFinished', window);
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            elseif conditions(trial,3) == 3
                Screen('PutImage', window, face3, facerect1);
                Screen('DrawingFinished', window);
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            elseif conditions(trial,3) == 4
                Screen('PutImage', window, face4, facerect1);
                Screen('DrawingFinished', window);
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            elseif conditions(trial,3) == 5
                Screen('PutImage', window, tool1, facerect1);
                Screen('DrawingFinished', window);
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            elseif conditions(trial,3) == 6
                Screen('PutImage', window, tool2, facerect1);
                Screen('DrawingFinished', window);
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            elseif conditions(trial,3) == 7
                Screen('PutImage', window, tool3, facerect1);
                Screen('DrawingFinished', window);
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            elseif conditions(trial,3) == 8
                Screen('PutImage', window, tool4, facerect1);
                Screen('DrawingFinished', window);
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            elseif conditions(trial,3) == 9
                Screen('PutImage', window, over1, facerect1);
                Screen('DrawingFinished', window);
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            elseif conditions(trial,3) == 10
                Screen('PutImage', window, over2, facerect1);
                Screen('DrawingFinished', window);
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            elseif conditions(trial,3) == 11
                Screen('PutImage', window, over3, facerect1);
                Screen('DrawingFinished', window);
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            elseif conditions(trial,3) == 12
                Screen('PutImage', window, over4, facerect1);
                Screen('DrawingFinished', window);
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            elseif conditions(trial,3) == 13
                Screen('PutImage', window, over5, facerect1);
                Screen('DrawingFinished', window);
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            elseif conditions(trial,3) == 14
                Screen('PutImage', window, over6, facerect1);
                Screen('DrawingFinished', window);
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            elseif conditions(trial,3) == 15
                Screen('PutImage', window, over7, facerect1);
                Screen('DrawingFinished', window);
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            elseif conditions(trial,3) == 16
                Screen('PutImage', window, over8, facerect1);
                Screen('DrawingFinished', window);
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            end
        end
        %show image1
        Screen('Flip', window);
        im1 = GetSecs;
        checkTime(trial,2) = im1-mar1;
        
        %%
        if Soatime>0
            %starttime1 -- fixation end time,mask begin time
            %image show time = cuetime;
            %cuetime =0.033;masktime1=0.5
            while GetSecs - starttime1 <= cuetime+masktime1
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            end
            %show fixation,only in SOA time
            Screen('Flip', window);
            %starttime1 -- fixation end time,mask begin time
            %image show time = cuetime;
            while GetSecs - starttime1 <= Soatime+cuetime+masktime1
                if conditions(trial,4) == 1
                    Screen('PutImage', window, face1, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif conditions(trial,4) == 2
                    Screen('PutImage', window, face2, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif conditions(trial,4) == 3
                    Screen('PutImage', window, face3, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif conditions(trial,4) == 4
                    Screen('PutImage', window, face4, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif conditions(trial,4) == 5
                    Screen('PutImage', window, tool1, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif conditions(trial,4) == 6
                    Screen('PutImage', window, tool2, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif conditions(trial,4) == 7
                    Screen('PutImage', window, tool3, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif conditions(trial,4) == 8
                    Screen('PutImage', window, tool4, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                end
            end
            Screen('Flip', window);%show N.2 image
            
            im2 = GetSecs;
            checkTime(trial,3) = im2-im1;
            %%
            %N.2 image show targettime; targettime = 0.033
            while GetSecs - starttime1 <= Soatime+cuetime+targettime+masktime1
                if  conditions(trial,3) <= 2    %%face(1,2)+tool(5,6)= nois1(mask1)
                    conditions(trial,4) ==5 || conditions(trial,4) == 6
                    Screen('PutImage', window, nois1, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif  conditions(trial,4) ==1 || conditions(trial,4) == 2
                    conditions(trial,3) ==5 || conditions(trial,3) == 6
                    Screen('PutImage', window, nois1, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                    %%%%%%%%%%%%%%%%%%%            %%face(1,2)+tool(7,8)= nois2(mask2)
                elseif  conditions(trial,3) <= 2
                    conditions(trial,4) ==7 | conditions(trial,4) == 8
                    Screen('PutImage', window, nois2, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif  conditions(trial,4) ==1 || conditions(trial,4) == 2
                    conditions(trial,3) ==7 | conditions(trial,3) == 8
                    Screen('PutImage', window, nois2, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                    %%%%%%%%%%%%%%%%%%%           %%face(3,4)+tool(5,6)= nois3(mask3)
                elseif  conditions(trial,3) == 3 || conditions(trial,3) == 4
                    conditions(trial,4) ==5 | conditions(trial,4) == 6
                    Screen('PutImage', window, nois3, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif  conditions(trial,4) == 3 || conditions(trial,4) == 4
                    conditions(trial,3) ==5 | conditions(trial,3) == 6
                    Screen('PutImage', window, nois3, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                    %%%%%%%%%%%%%%%%%%%          %%face(3,4)+tool(7,8)= nois4(mask4)
                elseif  conditions(trial,3) == 3 || conditions(trial,3) == 4
                    conditions(trial,4) ==7 | conditions(trial,4) == 8
                    Screen('PutImage', window, nois4, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif  conditions(trial,4) == 3 || conditions(trial,4) == 4
                    conditions(trial,3) ==7 | conditions(trial,3) == 8
                    Screen('PutImage', window, nois4, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                end
            end
            Screen('Flip', window); %show mask
            mar2 = GetSecs;
            checkTime(trial,4) = mar2-im2;
            %%
            %starttime1 -- fixation end time,mask begin time
            %image show time = cuetime;
            %tetect target targettime = 0.033;
            %starttime2--the time show N.2 mask;N.2 mask last masktime2
            starttime2 = GetSecs;
            %masktime1+cuetime+targettime+Soatime+masktime2 --the total time for one trials
            while GetSecs - starttime1 <= masktime1+cuetime+targettime+Soatime+masktime2
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
            end
            
        elseif Soatime == 0
            %%
            while GetSecs - starttime1 <= cuetime+masktime1
                if conditions(trial,4) == 1
                    Screen('PutImage', window, face1, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif conditions(trial,4) == 2
                    Screen('PutImage', window, face2, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif conditions(trial,4) == 3
                    Screen('PutImage', window, face3, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif conditions(trial,4) == 4
                    Screen('PutImage', window, face4, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif conditions(trial,4) == 5
                    Screen('PutImage', window, tool1, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif conditions(trial,4) == 6
                    Screen('PutImage', window, tool2, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif conditions(trial,4) == 7
                    Screen('PutImage', window, tool3, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif conditions(trial,4) == 8
                    Screen('PutImage', window, tool4, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif conditions(trial,4) == 0      %overlap, the second pic is 0.033s 'kong ping'
                    % Screen('PutImage', window, nois1, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                end
            end
            Screen('Flip', window);%SOA==0,show SOA=0,show N.2 image
            im2 = GetSecs;
            checkTime(trial,3) = im2-im1;
            %%
            while GetSecs - starttime1 <= cuetime+targettime+masktime1
                if  conditions(trial,3) <= 2   %%face(1,2)+tool(5,6)= nois1(mask1)
                    conditions(trial,4) ==5 | conditions(trial,4) == 6
                    Screen('PutImage', window, nois1, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif  conditions(trial,4) ==1 || conditions(trial,4) == 2
                    conditions(trial,3) ==5 | conditions(trial,3) == 6
                    Screen('PutImage', window, nois1, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                    %%%%%%%%%%%%%%%%%%%            %%face(1,2)+tool(7,8)= nois2(mask2)
                elseif  conditions(trial,3) <= 2
                    conditions(trial,4) ==7 | conditions(trial,4) == 8
                    Screen('PutImage', window, nois2, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif  conditions(trial,4) ==1 || conditions(trial,4) == 2
                    conditions(trial,3) ==7 | conditions(trial,3) == 8
                    Screen('PutImage', window, nois2, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                    %%%%%%%%%%%%%%%%%%%           %%face(3,4)+tool(5,6)= nois3(mask3)
                    
                elseif  conditions(trial,3) == 3 || conditions(trial,3) == 4
                    conditions(trial,4) ==5 | conditions(trial,4) == 6
                    Screen('PutImage', window, nois3, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif  conditions(trial,4) == 3 | conditions(trial,4) == 4
                    conditions(trial,3) ==5 | conditions(trial,3) == 6
                    Screen('PutImage', window, nois3, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                    %%%%%%%%%%%%%%%%%%%          %%face(3,4)+tool(7,8)= nois4(mask4)
                elseif  conditions(trial,3) == 3 | conditions(trial,3) == 4
                    conditions(trial,4) ==7 | conditions(trial,4) == 8
                    Screen('PutImage', window, nois4, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif  conditions(trial,4) == 3 || conditions(trial,4) == 4
                    conditions(trial,3) ==7 || conditions(trial,3) == 8
                    Screen('PutImage', window, nois4, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif  conditions(trial,3) ==9 || conditions(trial,3) == 10     %overlap
                    Screen('PutImage', window, nois1, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif  conditions(trial,3) ==11 || conditions(trial,3) == 12     %overlap
                    Screen('PutImage', window, nois2, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif  conditions(trial,3) ==13 || conditions(trial,3) == 14     %overlap
                    Screen('PutImage', window, nois3, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                elseif  conditions(trial,3) ==15 || conditions(trial,3) == 16     %overlap
                    Screen('PutImage', window, nois4, facerect1);
                    Screen('DrawingFinished', window);
                    DrawFormattedText(window, fixationtext, 'center', 'center', black);
                end
            end
            Screen('Flip', window); %show N.2 mask
            mr2 = GetSecs;
            checkTime(trial,4) = mr2-im2;
            %%
            %starttime2--begin to show N.2 mask
            starttime2 = GetSecs;
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
            %
            if ~DEBUG
                while 1
                    while 1
                        pulse=IOPort('read',P4,0,1);
                        if ~isempty(pulse) && (pulse ~= 83)
                            botpress(trial,1)=pulse;
                            timepress(trial,1)=GetSecs-starttime2;
                            break
                        end
                        if GetSecs-starttime1>=masktime1+cuetime+targettime+masktime2
                            break
                        end
                    end
                    if GetSecs-starttime1>=masktime1+cuetime+targettime+masktime2
                        break
                    end
                end
            else
                while 1
                    while 1
                        [keyIsDown,secs,keyCode] = KbCheck;
                        pulse = find(keyCode);
                        if ~isempty(pulse) && (pulse ~= 83)
                            botpress(trial,1)=pulse;
                            timepress(trial,1)=GetSecs-starttime2;
                            break
                        end
                        if GetSecs-starttime1>=masktime1+cuetime+targettime+masktime2
                            break
                        end
                    end
                    if GetSecs-starttime1>=masktime1+cuetime+targettime+masktime2
                        break
                    end
                end
            end
            %%%%%%%
            % while GetSecs - starttime1 <= masktime1+cuetime+targettime+masktime2
            %    DrawFormattedText(window, fixationtext, 'center', 'center', black);
            % end
        end
        Screen('Flip', window); %show fixation
        fix = GetSecs;
        checkTime(trial,5) = fix-mar2;
        marbegin = mar1;
        %%
        if ~DEBUG
            while 1
                while 1
                    pulse=IOPort('read',P4,0,1);
                    if ~isempty(pulse) && (pulse ~= 83)
                        botpress(trial,1)=pulse;
                        timepress(trial,1)=GetSecs-starttime2;
                        break
                    end
                    if GetSecs-starttime1>=fixationtime
                        break
                    end
                end
                if GetSecs-starttime1>=fixationtime
                    break
                end
            end
        else
            while 1
                while 1
                    [keyIsDown,secs,keyCode] = KbCheck;
                    pulse = find(keyCode);
                    if ~isempty(pulse) && (pulse ~= 83)
                        botpress(trial,1)=pulse;
                        timepress(trial,1)=GetSecs-starttime2;
                        break
                    end
                    if GetSecs-starttime1>=fixationtime
                        break
                    end
                end
                if GetSecs-starttime1>=fixationtime
                    break
                end
            end
        end
        fixend = GetSecs;
        checkTime(trial,7) = fixend-mar1;
        % End of current dynamic scan prep for next trial
        trial = trial+1;
    end
    endtime = GetSecs;
    totalexptime = endtime - begintime;
    save(sprintf('data\\data_%s.mat', sid), 'presentations', 'botpress','timepress');
catch ME
    display(sprintf('Error in Experiment. Please get experimenter.'));
    Priority(0);
    ShowCursor
    Screen('CloseAll');
end
ShowCursor
Screen('CloseAll');