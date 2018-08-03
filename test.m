function test
%Presents images in fMRI experiment
%Record responses of face/tool task.
try
    sca;
    close all;
    clearvars;
    AssertOpenGL;
    oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 1);
    oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
    Screen('Preference','SkipSyncTests', 1);
    setupmainexp;
    Screen('Preference','Verbosity',1);
    %% Prepare Screen for Experiment
    %%Prep Screen
    screenNumber=max(Screen('Screens'));
    gray=GrayIndex(screenNumber);
    black=BlackIndex(screenNumber);
    %[window,screenRect]=Screen('OpenWindow',screenNumber,gray,[],8,2); % full SCREEN mode, in mid-level gray
    [window,screenRect]=Screen('OpenWindow',screenNumber,gray,[80,60,800,550]);
    Screen('TextSize', window,30);
    ifi = Screen('GetFlipInterval',window);
    topPriorityLevel = MaxPriority(window);
    %%
    %SETUP RECTS FOR IMAGE
    facerect = [0 0 stimwidth stimheight];
    facerect = CenterRect(facerect, screenRect);
    
    % Shows 'READY'
    DrawFormattedText(window, waitingtext, 'center', 'center', black);
    Screen('DrawingFinished',window);
    Screen('Flip', window); 
    
    %% START TRIALS
    waitFrames = 1;
    trial = 1;
    presentations = zeros(totalNum,6);
    botpress = zeros(totalNum,1);
    timepress = zeros(totalNum,1);
    checkTime = zeros(totalNum,12);
    
    while 1
        [keyIsDown,secs,keyCode] = KbCheck;
        if keyCode(83)
            pulse = 83;
        end
        if ~isempty(pulse) && (pulse == 83)
            break;
        end
    end
    %Shows fixation
    [vbl,begintime] = Screen('Flip', window); 
    numFrames = round(fixationTime1/ifi);
    for frame = 1:numFrames
        DrawFormattedText(window, fixationtext, 'center', 'center', black);
        Screen('DrawingFinished',window);
        vbl = Screen('Flip', window,vbl+(waitFrames-0.5)*ifi);
    end
    %%
    while trial <= totalNum
        presentations (trial,:) = [conditions(trial,:), begintime, vbl];
        Soatime=conditions(trial,2);
        checkTime(trial,1) = conditions(trial,1);
        mark1begin=GetSecs;
        %show mask
        numFrames = round(maskTime1/ifi);
        for frame = 1:numFrames
            maskNam1 = choseMask(conditions, trial);
            maskname = eval(strcat(maskNam1));
            Screen('PutImage', window, maskname, facerect);
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
            Screen('DrawingFinished', window);
            vbl = Screen('Flip', window,vbl+(waitFrames-0.5)*ifi);
        end
        mark1end = GetSecs;
        checkTime(trial,2) = mark1end-mark1begin;
        % Shows image1
        numFrames = round(imageTime1/ifi);
        for frame = 1:numFrames
            imaNam = choseImage_one(conditions, trial);
            image1 = eval(strcat(imaNam));
            Screen('PutImage', window, image1, facerect);
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
            Screen('DrawingFinished', window);
            vbl = Screen('Flip', window,vbl+(waitFrames-0.5)*ifi);
        end
        image1end = GetSecs;
        checkTime(trial,3) = image1end-mark1end;
        if Soatime>0
            %show fixation for soa time
            numFrames = round(Soatime/ifi);
            for frame = 1:numFrames
                DrawFormattedText(window, fixationtext, 'center', 'center', black);
                Screen('DrawingFinished', window);
                vbl = Screen('Flip', window,vbl+(waitFrames-0.5)*ifi);
            end
            soaend = GetSecs;
            checkTime(trial,4) = soaend-image1end;
        else
            soaend = GetSecs;
        end
        
        %show image2
        numFrames = round(imageTime2/ifi);
        for frame = 1:numFrames
            imgeName2 = choseImage_two(conditions, trial);
            if ~isempty(imgeName2)
                image2 = eval(strcat(imgeName2));
                Screen('PutImage', window, image2, facerect);
            end
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
            Screen('DrawingFinished', window);
            vbl = Screen('Flip', window,vbl+(waitFrames-0.5)*ifi);
        end
        image2end = GetSecs;
        checkTime(trial,5) = image2end-soaend;
        %show mask2
        numFrames = round(maskTime2/ifi);
        for frame = 1:numFrames
            maskName2 = choseMask_two(conditions, trial);
            if ~isempty(maskName2)
                mask2 = eval(strcat(maskName2));
            Screen('PutImage', window, mask2, facerect);
            end
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
            Screen('DrawingFinished', window);
            vbl = Screen('Flip', window,vbl+(waitFrames-0.5)*ifi);
            starttime= vbl;
            %press key for reaction
            [keyIsDown,secs,keyCode] = KbCheck;
            pulse = find(keyCode);
            if ~isempty(pulse) && (pulse ~= 83)
                botpress(trial,1)=pulse;
                timepress(trial,1)=GetSecs-starttime;
                break
            end
        end
        mark2end = GetSecs;
        checkTime(trial,6) = mark2end-image2end;
        %show fixation for 12s+
        countTrialTime = sum(checkTime(trial,2:6),2);
        numFrames = round((fixationTime-countTrialTime)/ifi);
        for frame = 1:numFrames
            DrawFormattedText(window, fixationtext, 'center', 'center', black);
            Screen('DrawingFinished', window);
            vbl = Screen('Flip', window,vbl+(waitFrames-0.5)*ifi);
            starttime= vbl;
            %press key for reaction
            [keyIsDown,secs,keyCode] = KbCheck;
            pulse = find(keyCode);
            if ~isempty(pulse) && (pulse ~= 83)
                botpress(trial,1)=pulse;
                timepress(trial,1)=GetSecs-starttime;
                break
            end
        end
        fix2end = GetSecs;
        checkTime(trial,7) = fix2end-mark2end;
        checkTime(trial,8) = fix2end-mark1begin;
        trial = trial+1;
        while 1
            [keyIsDown,secs,keyCode] = KbCheck;
            if keyCode(83)
                pulse = 83;
            end
            if ~isempty(pulse) && (pulse == 83)
                break;
            end
        end
    end
    Priority(0);
    endtime = GetSecs;
    totalexptime = endtime - begintime;
    save('data\\data_hh.mat','checkTime','conditions');
    save(sprintf('data\\data_%s.mat', sid), 'presentations', 'botpress','timepress');
catch ME
    display(sprintf('Error in Experiment. Please get experimenter.'));
    Priority(0);
    ShowCursor
    Screen('CloseAll');
end
ShowCursor
Screen('CloseAll');
end


function [maskNam]=choseMask(conditions, trial)
if conditions(trial,3) <= 2   %%face(1,2)+tool(5,6)= nois1(mask1)
    conditions(trial,4) ==5 || conditions(trial,4) == 6
    maskNam='nois1';
elseif conditions(trial,4) ==1 || conditions(trial,4) == 2
    conditions(trial,3) ==5 || conditions(trial,3) == 6
    maskNam='nois1';
elseif  conditions(trial,3) <= 2
    conditions(trial,4) ==7 || conditions(trial,4) == 8
    maskNam='nois2';
elseif conditions(trial,4) ==1 || conditions(trial,4) == 2
    conditions(trial,3) ==7 || conditions(trial,3) == 8
    maskNam='nois2';
elseif  conditions(trial,3) == 3 || conditions(trial,3) == 4
    conditions(trial,4) ==5 || conditions(trial,4) == 6
    maskNam='nois3';
elseif  conditions(trial,4) == 3 || conditions(trial,4) == 4
    conditions(trial,3) ==5 || conditions(trial,3) == 6
    maskNam='nois3';
elseif  conditions(trial,3) == 3 || conditions(trial,3) == 4
    conditions(trial,4) ==7 || conditions(trial,4) == 8
    maskNam='nois4';
elseif  conditions(trial,4) == 3 || conditions(trial,4) == 4
    conditions(trial,3) ==7 || conditions(trial,3) == 8
    maskNam='nois4';
elseif  conditions(trial,3) ==9 || conditions(trial,3) == 10     %overlap
    maskNam='nois1';
elseif  conditions(trial,3) ==11 || conditions(trial,3) == 12     %overlap
    maskNam='nois2';
elseif  conditions(trial,3) ==13 || conditions(trial,3) == 14     %overlap
    maskNam='nois3';
elseif  conditions(trial,3) ==15 || conditions(trial,3) == 16     %overlap
    maskNam='nois4';
end
end

function [imaNam]=choseImage_one(conditions, trial)
if conditions(trial,3) == 1
    imaNam = 'face1';
elseif conditions(trial,3) == 2
    imaNam = 'face2';
elseif conditions(trial,3) == 3
    imaNam = 'face3';
elseif conditions(trial,3) == 4
    imaNam = 'face4';
elseif conditions(trial,3) == 5
    imaNam = 'tool1';
elseif conditions(trial,3) == 6
    imaNam = 'tool2';
elseif conditions(trial,3) == 7
    imaNam = 'tool3';
elseif conditions(trial,3) == 8
    imaNam = 'tool4';
elseif conditions(trial,3) == 9
    imaNam = 'over1';
elseif conditions(trial,3) == 10
    imaNam = 'over2';
elseif conditions(trial,3) == 11
    imaNam = 'over3';
elseif conditions(trial,3) == 12
    imaNam = 'over4';
elseif conditions(trial,3) == 13
    imaNam = 'over5';
elseif conditions(trial,3) == 14
    imaNam = 'over6';
elseif conditions(trial,3) == 15
    imaNam = 'over6';
elseif conditions(trial,3) == 16
    imaNam = 'over8';
end
end

function [imgeName]=choseImage_two(conditions,trial)
if conditions(trial,4) == 1
    imgeName = 'face1';
elseif conditions(trial,4) == 2
    imgeName = 'face2';
elseif conditions(trial,4) == 3
    imgeName = 'face3';
elseif conditions(trial,4) == 4
    imgeName = 'face4';
elseif conditions(trial,4) == 5
    imgeName = 'tool1';
elseif conditions(trial,4) == 6
    imgeName = 'tool2';
elseif conditions(trial,4) == 7
    imgeName = 'tool3';
elseif conditions(trial,4) == 8
    imgeName = 'tool4';
elseif conditions(trial,4) == 0
    imgeName = '';
end
end

function [maskName]=choseMask_two(conditions,trial)
if  conditions(trial,3) <= 2
    conditions(trial,4) ==5 || conditions(trial,4) == 6
    maskName = 'nois1';
elseif  conditions(trial,4) ==1 || conditions(trial,4) == 2
    conditions(trial,3) ==5 || conditions(trial,3) == 6
    maskName = 'nois1';
elseif  conditions(trial,3) <= 2
    conditions(trial,4) ==7 || conditions(trial,4) == 8
    maskName = 'nois2';
elseif  conditions(trial,4) ==1 || conditions(trial,4) == 2
    conditions(trial,3) ==7 || conditions(trial,3) == 8
    maskName = 'nois2';
elseif  conditions(trial,3) == 3 || conditions(trial,3) == 4
    conditions(trial,4) ==5 || conditions(trial,4) == 6
    maskName = 'nois3';
elseif  conditions(trial,4) == 3 || conditions(trial,4) == 4
    conditions(trial,3) ==5 || conditions(trial,3) == 6
    maskName = 'nois3';
elseif  conditions(trial,3) == 3 || conditions(trial,3) == 4
    conditions(trial,4) ==7 || conditions(trial,4) == 8
    maskName = 'nois4';
elseif  conditions(trial,4) == 3 || conditions(trial,4) == 4
    conditions(trial,3) ==7 || conditions(trial,3) == 8
    maskName = 'nois4';
elseif conditions(trial,4) == 0
    maskName = '';
end
end
