%% face 1 是竖男脸1; face 2 是横男脸2;
%% face 3 是竖女脸3; face 4 是横女脸4;
%% tool 1 是竖5; tool 2 是横6;
%% tool 3 是竖7; tool 4 是横8;
%% 0verlap 1-8======overlap 9-16
%% 0verlap 1-8======overlap 9-16
close all;
clc;
%%%%输入被试ID
filename = [];
while isempty(filename)
    filename = input('Enter name of data file: ', 's');
    if filename == ' '
        filename = [];
    end
end
%%%%%%刺激顺序随机
s = RandStream('mt19937ar','Seed', sum(100*clock));
RandStream.setGlobalStream(s);
%%%%%%刺激顺序设计
SOA_list=[0.0,(1/60)*2,(1/60)*4,(1/60)*8,(1/60)*16];%???5?SOA???SOA?16?trials???80
% SOA_list=[0.0,5,6,7,8];
% 1 trialNum; 2 SOA; 3 first; 4 second; %%%设计orig_design
    %totalNum = length(SOA_list)*16;
    totalNum = length(SOA_list)*16+16;
    orig_design = zeros(totalNum,4);
    %%%1 trialNum=96
    orig_design(:,1) = (1:totalNum);
    %%%3 first,2*8*5=80--+--2*8=16
    % orig_design(:,3) = repmat([1 1 1 2 2 2 3 3 3 4 4 4 5 5 5 6 6 6 7 7 7 8 8 8],1,4);
    orig_design(1:80,3) = repmat([1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8],1,1*length(SOA_list));
    orig_design(81:96,3) = repmat([9,10,11,12,13,14,15,16],1,2);
    %%%4 second 2*8*5=80--5?11?22..+1??0
    %orig_design(:,4) = repmat([6 8 9 5 7 10 6 8 11 5 7 12 2 4 13 1 3 14 2 4 15 1 3 16],1,4);
    orig_design(1:80,4) = repmat([6 8 5 7 6 8 5 7 2 4 1 3 2 4 1 3],1,1*length(SOA_list));
    %orig_design(81:88,4) = repmat([0,0,0,0,0,0,0,0],1,2));
    %%%2 SOA
    orig_design(:,2) = 0.0000;   
    for i=1:4
    orig_design(16*i+ 1:16*(i+1),2)=(1/60)*2^i;
    end
 
     %trial_order11=zeros(80,4);
     trial_order11=zeros(96,4);
     trial_order11(:,1) = orig_design(:,1);
     trial_order1 = randperm(96);
     for ii=1:96
         j=find(trial_order1==ii);
         trial_order11(j,2:4)=orig_design(ii,2:4);
     end
     
     %trial_order22=zeros(80,4);
     trial_order22=zeros(96,4);
     trial_order22(:,1) = orig_design(:,1);
     trial_order2 = randperm(96);   
     for jj=1:96
         J=find(trial_order2==jj);
         trial_order22(J,2:4)=orig_design(jj,2:4);
     end  
     
     conditionrun1=trial_order11(1:24,:);
     conditionrun2=trial_order11(25:48,:);
     conditionrun3=trial_order11(49:72,:);
     conditionrun4=trial_order11(73:96,:);
     conditionrun5=trial_order22(1:24,:);
     conditionrun6=trial_order22(25:48,:);
     conditionrun7=trial_order22(49:72,:);
     conditionrun8=trial_order22(73:96,:);
     save(sprintf('mainexp_cond\\subcondition_%s.mat', filename), 'conditionrun*');
