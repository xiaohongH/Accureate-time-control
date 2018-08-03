%  Loads session parameters
%  Loads images
%  Initializes run and trials
%*********************************************
% Experimental session parameters:
filename=[];
while isempty(filename)
    filename=input('Enter name of data file: ', 's');
    if filename == ' '
        filename = [];
    end
end
run = [];
temprun = input('Enter run number:\n');
while isempty(run)
    sid = strcat(filename, '_mainexp', num2str(temprun));
    sd = exist(sprintf('data\\%s.mat', sid));
    if(sd > 0)
        temprun = input('You have already done this run, please pick a new run:\n');
    else
        run = temprun;
    end
end
DEBUG = input('Are we debugging? 0 or 1:\n');
    cd('mainexp_cond')
    eval(['load subcondition_' filename ';']);
    eval(['conditions = conditionrun' num2str(temprun) ';']);
    cd ..
%%%%%%%%%%timing %%%%%%% very important
maskTime1 =0.5;
imageTime1 = 0.033;
imageTime2 = 0.033;
maskTime2 =0.5;
fixationTime1 = 2; %%% fixation at the beginning
fixationTime = 3; 
TR = 2;
nimages=1;
totalNum=24;
%*************************************
load sti

[stimheight, stimwidth] = size(face1); 
fixationtext = '+';
waitingtext = 'READY';
pulse = [];