clear;
clc;
load('EN_ALLDATA_train_1.5_10.mat');
%%
MAX_STATES_NUM = 3^6 * 2;
ACTION_NUM = 6;
%Q_0 = zeros(MAX_STATES_NUM, ACTION_NUM);
gamma         = 0.9;     % discount factor，越大、小？表示越重视之前的经验
alpha         = 0.2;     % learning rate，越小表示保留之前训练的效果越少
epsilon       = 0.1;     % eps-greedy
%% setting
nL=2; %双车道
cellL=7.5; %一个元胞长度
cL=ceil(7.5/cellL); %cell number of a car
% nt=0.5; %仿真步长时间
numOfCell=1334; %车道元胞数量
roadL=800*cellL; %车道长度
maxTime=10000; %仿真时间!!!
maxSpeed=floor(108/3.6/cellL); %最大速度=4
nominalSpeed = 2;
% dMax=26.25/cellL; %紧急减速度3.5
% dC=18.75/cellL; %常规减速度2.5
% aMax=22.5/cellL; %最大加速度3
% Tav=0.1; %自动驾驶反应时间
% Trv=1.5;%手动驾驶反应时间
probOfSlowdown=0.25; %随机慢化概率
% probOfBlock=0.1;     
% A1=0.1; %自动驾驶车辆所占比例
p=0;  %车辆的换道水平
probChange=0.5; %车辆的换道概率
%%
episode_limit=4;
fprintf('episode_limit=4');
%% run
for epi=1:1:episode_limit
    %%
    ALL_LINK_1=[];%车道1
    ALL_LINK_2=[];%车道2
    ALL_AV_LINK_1=[];%车道1上所有的AV
    ALL_AV_LINK_2=[];%车道2上所有的AV
    LINK_1=NaN(1,numOfCell); %车道1
    LINK_2=NaN(1,numOfCell); %车道2
    LINK_AV_1=NaN(1,numOfCell); %车道1上的AV
    LINK_AV_2=NaN(1,numOfCell); %车道2上的AV
    Vehicle_1=NaN(20000,11);
    Vehicle_2=NaN(20000,11);
    Route_1=NaN(10000,20000); %假设车道1在10000s内，最多出现8000辆车
    Route_2=NaN(10000,20000);
    ALL_VEHICLE_1=[];%车道1所有车辆
    ALL_VEHICLE_2=[];%车道2所有车辆
    All_Speed_1=zeros(20000,2);%存储所有车的每次更新的速度
    All_Speed_2=zeros(20000,2);%存储所有车的每次更新的速度
    Speed_1=NaN(10000,20000); %创建速度矩阵，横轴为时间，纵轴为车辆标号，值为速度
    Speed_2=NaN(10000,20000);
    index_1=0;
    index_2=0;
    flag_1=0;
    flag_2=0;
    %%
    for time_i=1:1:maxTime

        fprintf('time: %d, episode: %d\n ', time_i,epi);

        %% load vehicle
         
        %% load link_1 vehicle
        [LINK_1,Vehicle_1,index_1,flag_1] = LoadVehicle(time_i, LINK_1, maxSpeed,1,Vehicle_1,index_1,flag_1);

        %% load link_2 vehicle
        [LINK_2,Vehicle_2,index_2,flag_2] = LoadVehicle(time_i, LINK_2, maxSpeed,2,Vehicle_2,index_2,flag_2);

        %%        
        ALL_LINK_1=[ALL_LINK_1; LINK_1];%每次增加最后一行
        ALL_LINK_2=[ALL_LINK_2; LINK_2];
        ALL_AV_LINK_1=[ALL_AV_LINK_1;LINK_AV_1];
        ALL_AV_LINK_2=[ALL_AV_LINK_2;LINK_AV_2];

    %% lane change
        r_0=unifrnd(0,1);
        if(r_0>0.5)
            for c=1:1:2
                if c==1
                    for i=1:1:index_1
                        if Vehicle_1(i,1)==0
                            continue;
                        else
                            for cell_i=1:1:numOfCell
                            % get current speed       
                                speedOld_1= LINK_1(cell_i);
                                if ~isnan(speedOld_1) && Vehicle_1(i,2)==cell_i %当SpeedOld不是nan时,
                                    % 判断车辆类型
                                    if Vehicle_1(i,5)==2 %如果是RV，则CA模型
                                    emptyFront_1=GetEmptyFront(LINK_1, numOfCell, maxSpeed, cell_i);
                                    emptyFront_2=GetEmptyFront(LINK_2, numOfCell, maxSpeed, cell_i);
                                    [emptyBackD_2,vBack_2]=GetEmptyBack(LINK_2, maxSpeed, cell_i,numOfCell);
                                        if isnan(LINK_2(cell_i)) && emptyFront_1<min(speedOld_1+1,maxSpeed) && emptyFront_1<emptyFront_2 && emptyBackD_2>vBack_2+p %如果满足换道条件
                                             r_1=unifrnd(0,1);
                                             if r_1<=probChange && time_i>0 %&& Vehicle_1(i,4)==0 %如果小于换道率概率且大于0s
                                                 LINK_1(cell_i)=nan; %则换道（从1道-2道）
                                                 LINK_2(cell_i)=speedOld_1;
                                                 Vehicle_1(i,4)=Vehicle_1(i,4)+1;
                                                 Vehicle_1(i,3)=speedOld_1;
                                                 type_new_1=Vehicle_1(i,5); %将该车的属性赋值给type_new
                                                 flag_new_1=Vehicle_1(i,7);
                                                 Vehicle_1(i,6)=2; %将Linkname赋值为2
                                                 Vehicle_1(i,1)=0;%将id赋值为0表示下次在该车道不考虑该车
                                                 index_2=index_2+1;
                                                 Vehicle_2(index_2,1:7)=[index_2,cell_i,speedOld_1,Vehicle_1(i,4),type_new_1,2,flag_new_1];
                                                 break; %换道成功就break该层循环
                                             end
                                        end
                                    else %如果是AV
                                        [state_1,action_1,r_1,flag_break_1,speedNew_1] = Q_Learning_step1(Q_0,LINK_1,LINK_2,cell_i,numOfCell,maxSpeed,p,epsilon,nominalSpeed,1);
%                                         Vehicle_1(i,8:10)=[state_1,action_1,r_1];
%                                         Vehicle_1(i,3)=speedNew_1;
                                        if flag_break_1 == true
                                            % lane change 
                                            LINK_1(cell_i)=nan;   
                                            LINK_2(cell_i)=speedNew_1;
                                            Vehicle_1(i,4)=Vehicle_1(i,4)+1;
                                            Vehicle_1(i,3)=speedNew_1;
                                            type_new_1=Vehicle_1(i,5); %将该车的属性赋值给type_new
                                            flag_new_1=Vehicle_1(i,7);
                                            Vehicle_1(i,6)=2; %将Linkname赋值为2
                                            Vehicle_1(i,1)=0;%将id赋值为0表示下次在该车道不考虑该车
                                            index_2=index_2+1;
                                            Vehicle_2(index_2,1:10)=[index_2,cell_i,speedNew_1,Vehicle_1(i,4),type_new_1,2,flag_new_1,state_1,action_1,r_1];% 换道标记也给Vehicle_2
                                            All_Speed_2(index_2,2)=speedNew_1;%更新速度
                                            break; %换道成功就break该层循环
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    for i=1:1:index_2
                        if Vehicle_2(i,1)==0
                            continue;
                        else
                            for cell_i=1:1:numOfCell
                            % get current speed       
                                speedOld_2= LINK_2(cell_i);
                                if ~isnan(speedOld_2) && Vehicle_2(i,2)==cell_i %当SpeedOld不是nan时,
                                    % 判断车辆类型
                                    if Vehicle_2(i,5)==2 %如果是RV，则CA模型
                                    emptyFront_2=GetEmptyFront(LINK_2, numOfCell, maxSpeed, cell_i);
                                    emptyFront_1=GetEmptyFront(LINK_1, numOfCell, maxSpeed, cell_i);
                                    [emptyBackD_1,vBack_1]=GetEmptyBack(LINK_1, maxSpeed, cell_i,numOfCell);
                                        if isnan(LINK_1(cell_i)) && emptyFront_2<min(speedOld_2+1,maxSpeed) && emptyFront_2<emptyFront_1 && emptyBackD_1>vBack_1+p %如果满足换道条件
                                             r_2=unifrnd(0,1);
                                             if r_2<=probChange && time_i>0 %&& Vehicle_2(i,4)==0 %如果小于换道率概率且大于0s，且未曾换过道
                                                 LINK_2(cell_i)=nan; %则换道（从2道-1道）
                                                 LINK_1(cell_i)=speedOld_2;
                                                 Vehicle_2(i,4)=Vehicle_2(i,4)+1;
                                                 Vehicle_2(i,3)=speedOld_2;
                                                 type_new_2=Vehicle_2(i,5); %将该车的属性赋值给type_new
                                                 flag_new_2=Vehicle_2(i,7);
                                                 Vehicle_2(i,6)=1; %将Linkname赋值为1
                                                 Vehicle_2(i,1)=0;%将id赋值为0表示下次在该车道不考虑该车
                                                 index_1=index_1+1;
                                                 Vehicle_1(index_1,1:7)=[index_1,cell_i,speedOld_2,Vehicle_2(i,4),type_new_2,1,flag_new_2];
                                                 break; %换道成功就break该层循环
                                             end
                                        end
                                    else
                                        [state_2,action_2,r_2,flag_break_2,speedNew_2] = Q_Learning_step1(Q_0,LINK_2,LINK_1,cell_i,numOfCell,maxSpeed,p,epsilon,nominalSpeed,2);
%                                         Vehicle_2(i,8:10)=[state_2,action_2,r_2];
%                                         Vehicle_2(i,3)=speedNew_2;
                                        if flag_break_2 == true
                                            % lane change 
                                            LINK_2(cell_i)=nan; %则换道
                                            LINK_1(cell_i)=speedNew_2; 
                                            Vehicle_2(i,4)=Vehicle_2(i,4)+1;
    %                                         Vehicle_2(i,4)=changeL;
                                            Vehicle_2(i,3)=speedNew_2;
                                            type_new_2=Vehicle_2(i,5); %将该车的属性赋值给type_new
                                            flag_new_2=Vehicle_2(i,7);
                                            Vehicle_2(i,6)=1; %将Linkname赋值为1
                                            Vehicle_2(i,1)=0;%将id赋值为0表示下次在该车道不考虑该车
                                            index_1=index_1+1;
                                            Vehicle_1(index_1,1:10)=[index_1,cell_i,speedNew_2,Vehicle_2(i,4),type_new_2,1,flag_new_2,state_2,action_2,r_2];
                                            All_Speed_1(index_1,2)=speedNew_2;%更新速度
                                            break; 
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            for c=2:-1:1
                if c==1
                    for i=1:1:index_1
                        if Vehicle_1(i,1)==0
                            continue;
                        else
                            for cell_i=1:1:numOfCell
                            % get current speed       
                                speedOld_1= LINK_1(cell_i);
                                if ~isnan(speedOld_1) && Vehicle_1(i,2)==cell_i %当SpeedOld不是nan时,
                                    % 判断车辆类型
                                    if Vehicle_1(i,5)==2 %如果是RV，则CA模型
                                    emptyFront_1=GetEmptyFront(LINK_1, numOfCell, maxSpeed, cell_i);
                                    emptyFront_2=GetEmptyFront(LINK_2, numOfCell, maxSpeed, cell_i);
                                    [emptyBackD_2,vBack_2]=GetEmptyBack(LINK_2, maxSpeed, cell_i,numOfCell);
                                        if isnan(LINK_2(cell_i)) && emptyFront_1<min(speedOld_1+1,maxSpeed) && emptyFront_1<emptyFront_2 && emptyBackD_2>vBack_2+p %如果满足换道条件
                                             r_1=unifrnd(0,1);
                                             if r_1<=probChange && time_i>0 %&& Vehicle_1(i,4)==0 %如果小于换道率概率且大于500s，且未曾换过道
                                                 LINK_1(cell_i)=nan; %则换道（从1道-2道）
                                                 LINK_2(cell_i)=speedOld_1;
                                                 Vehicle_1(i,4)=Vehicle_1(i,4)+1;
                                                 Vehicle_1(i,3)=speedOld_1;
                                                 type_new_1=Vehicle_1(i,5); %将该车的属性赋值给type_new
                                                 flag_new_1=Vehicle_1(i,7);
                                                 Vehicle_1(i,6)=2; %将Linkname赋值为2
                                                 Vehicle_1(i,1)=0;%将id赋值为0表示下次在该车道不考虑该车
                                                 index_2=index_2+1;
                                                 Vehicle_2(index_2,1:7)=[index_2,cell_i,speedOld_1,Vehicle_1(i,4),type_new_1,2,flag_new_1];
                                                 break; %换道成功就break该层循环
                                             end
                                        end
                                    else
                                        [state_1,action_1,r_1,flag_break_1,speedNew_1] = Q_Learning_step1(Q_0,LINK_1,LINK_2,cell_i,numOfCell,maxSpeed,p,epsilon,nominalSpeed,1);
%                                         Vehicle_1(i,8:10)=[state_1,action_1,r_1];
%                                         Vehicle_1(i,3)=speedNew_1;
                                        if flag_break_1 == true
                                            % lane change 
                                            LINK_1(cell_i)=nan;   
                                            LINK_2(cell_i)=speedNew_1;
                                            Vehicle_1(i,4)=Vehicle_1(i,4)+1;
                                            Vehicle_1(i,3)=speedNew_1;
                                            type_new_1=Vehicle_1(i,5); %将该车的属性赋值给type_new
                                            flag_new_1=Vehicle_1(i,7);
                                            Vehicle_1(i,6)=2; %将Linkname赋值为2
                                            Vehicle_1(i,1)=0;%将id赋值为0表示下次在该车道不考虑该车
                                            index_2=index_2+1;
                                            Vehicle_2(index_2,1:10)=[index_2,cell_i,speedNew_1,Vehicle_1(i,4),type_new_1,2,flag_new_1,state_1,action_1,r_1];% 换道标记也给Vehicle_2
                                            All_Speed_2(index_2,2)=speedNew_1;%更新速度
                                            break; %换道成功就break该层循环
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    for i=1:1:index_2
                        if Vehicle_2(i,1)==0
                            continue;
                        else
                            for cell_i=1:1:numOfCell
                            % get current speed       
                                speedOld_2= LINK_2(cell_i);
                                if ~isnan(speedOld_2) && Vehicle_2(i,2)==cell_i %当SpeedOld不是nan时,
                                    % 判断车辆类型
                                    if Vehicle_2(i,5)==2 %如果是RV，则CA模型
                                    emptyFront_2=GetEmptyFront(LINK_2, numOfCell, maxSpeed, cell_i);
                                    emptyFront_1=GetEmptyFront(LINK_1, numOfCell, maxSpeed, cell_i);
                                    [emptyBackD_1,vBack_1]=GetEmptyBack(LINK_1, maxSpeed, cell_i,numOfCell);
                                        if isnan(LINK_1(cell_i)) && emptyFront_2<min(speedOld_2+1,maxSpeed) && emptyFront_2<emptyFront_1 && emptyBackD_1>vBack_1+p %如果满足换道条件
                                             r_2=unifrnd(0,1);
                                             if r_2<=probChange && time_i>0 %&& Vehicle_2(i,4)==0 %如果小于换道率概率且大于500s，且未曾换过道
                                                 LINK_2(cell_i)=nan; %则换道（从2道-1道）
                                                 LINK_1(cell_i)=speedOld_2;
                                                 Vehicle_2(i,4)=Vehicle_2(i,4)+1;
                                                 Vehicle_2(i,3)=speedOld_2;
                                                 type_new_2=Vehicle_2(i,5); %将该车的属性赋值给type_new
                                                 flag_new_2=Vehicle_2(i,7);
                                                 Vehicle_2(i,6)=1; %将Linkname赋值为1
                                                 Vehicle_2(i,1)=0;%将id赋值为0表示下次在该车道不考虑该车
                                                 index_1=index_1+1;
                                                 Vehicle_1(index_1,1:7)=[index_1,cell_i,speedOld_2,Vehicle_2(i,4),type_new_2,1,flag_new_2];
                                                 break; %换道成功就break该层循环
                                             end
                                        end
                                    else
                                        [state_2,action_2,r_2,flag_break_2,speedNew_2] = Q_Learning_step1(Q_0,LINK_2,LINK_1,cell_i,numOfCell,maxSpeed,p,epsilon,nominalSpeed,2);
%                                         Vehicle_2(i,8:10)=[state_2,action_2,r_2];
%                                         Vehicle_2(i,3)=speedNew_2;
                                        if flag_break_2 == true
                                            % lane change 
                                            LINK_2(cell_i)=nan; %则换道
                                            LINK_1(cell_i)=speedNew_2; 
                                            Vehicle_2(i,4)=Vehicle_2(i,4)+1;
    %                                         Vehicle_2(i,4)=changeL;
                                            Vehicle_2(i,3)=speedNew_2;
                                            type_new_2=Vehicle_2(i,5); %将该车的属性赋值给type_new
                                            flag_new_2=Vehicle_2(i,7);
                                            Vehicle_2(i,6)=1; %将Linkname赋值为1
                                            Vehicle_2(i,1)=0;%将id赋值为0表示下次在该车道不考虑该车
                                            index_1=index_1+1;
                                            Vehicle_1(index_1,1:10)=[index_1,cell_i,speedNew_2,Vehicle_2(i,4),type_new_2,1,flag_new_2,state_2,action_2,r_2];
                                            All_Speed_1(index_1,2)=speedNew_2;%更新速度
                                            break; 
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
%% update speed
        %车道1和2的速度更新
        r_i=unifrnd(0,1);
        if(r_i>0.5)
            for c=1:1:2
               if c==1
                    for i=1:1:index_1
                        if Vehicle_1(i,1)==0
                            continue;
                        else
                            for cell_i=1:1:numOfCell
                            % get current speed       
                                speedOld_1= LINK_1(cell_i);
                                if ~isnan(speedOld_1) && Vehicle_1(i,2)==cell_i %当SpeedOld不是nan时,
                                    % 判断车辆类型
                                    if Vehicle_1(i,5)==2 %如果是RV，则CA模型
                                        % step1: acceleration
                                        speedNew_1=speedOld_1+1;
                                        speedNew_1= min(speedNew_1,maxSpeed);

                                        % step2: safety distance
                                        emptyFront_1=GetEmptyFront(LINK_1, numOfCell, maxSpeed, cell_i);  %本车道前距
                                        speedNew_1= min(speedNew_1,emptyFront_1);

                                        % step3: randomization
                                        r=unifrnd(0,1);
                                        if r<=probOfSlowdown
                                           speedNew_1=speedNew_1-1; 
                                        end  
                                        speedNew_1= max(0,speedNew_1);%保证不倒车

                                        % save new speed
                                        LINK_1(cell_i)=speedNew_1;  %将该车的最终速度存储进Link
                                        Vehicle_1(i,3)=speedNew_1;
                                        Vehicle_1(i,2)=cell_i;
                                        All_Speed_1(i,2)=speedNew_1;%更新速度
                                        break;

                                    else %如果是AV
                                        [state_1,action_1,r_1,flag_break_1,speedNew_1] = Q_Learning_step1(Q_0,LINK_1,LINK_2,cell_i,numOfCell,maxSpeed,p,epsilon,nominalSpeed,1);
                                        if flag_break_1 == true
                                            % lane change 
                                            LINK_1(cell_i)=nan;   
                                            LINK_2(cell_i)=speedNew_1;
                                            Vehicle_1(i,4)=Vehicle_1(i,4)+1; %换道次数+1
                                            Vehicle_1(i,3)=speedNew_1;
                                            type_new_1=Vehicle_1(i,5); %将该车的属性赋值给type_new
                                            flag_new_1=Vehicle_1(i,7);
                                            Vehicle_1(i,6)=2; %将Linkname赋值为2
                                            Vehicle_1(i,1)=0;%将id赋值为0表示下次在该车道不考虑该车
                                            index_2=index_2+1;
                                            Vehicle_2(index_2,1:10)=[index_2,cell_i,speedNew_1,Vehicle_1(i,4),type_new_1,2,flag_new_1,state_1,action_1,r_1];% 换道标记也给Vehicle_2
                                            All_Speed_2(index_2,2)=speedNew_1;%更新速度
                                            break;
                                         else
                                           % save new speed
                                           LINK_1(cell_i)=speedNew_1;  %将该车的最终速度存储进Link
                                           Vehicle_1(i,3)=speedNew_1;
                                           Vehicle_1(i,2)=cell_i;
                                           All_Speed_1(i,2)=speedNew_1;%更新速度
                                           Vehicle_1(i,8:10)=[state_1,action_1,r_1];
                                           break;
                                        end
                                       % save new speed
    %                                    [s_1,a_1,r_1,flag_break,speedNew] = Q_Learning_step1(Q_0,LINK_1,LINK_2,cell_i,numOfCell,maxSpeed,p,epsilon,nominalSpeed,1);
                                            %Vehicle_i(i,8:10)=[s,a,r];
                                       %LINK_1(cell_i)=Vehicle_1(i,3); % 将该车的最终速度存储进Link
    %                                    Vehicle_1(i,2)=cell_i;
    %                                    All_Speed_1(i,2)=Vehicle_1(i,3);%更新速度
                                    end
                                end
                            end
                        end
                    end
               else
                    for i=1:1:index_2
                        if Vehicle_2(i,1)==0
                            continue;
                        else
                            for cell_i=1:1:numOfCell
                            % get current speed       
                                speedOld_2= LINK_2(cell_i);
                                if ~isnan(speedOld_2) && Vehicle_2(i,2)==cell_i %当SpeedOld不是nan时,
                                    % 判断车辆类型
                                    if Vehicle_2(i,5)==2 %如果是RV，则CA模型
                                        % step1: acceleration
                                        speedNew_2=speedOld_2+1;
                                        speedNew_2= min(speedNew_2,maxSpeed);

                                        % step2: safety distance
                                        emptyFront_2=GetEmptyFront(LINK_2, numOfCell, maxSpeed, cell_i);  %本车道前距
                                        speedNew_2= min(speedNew_2,emptyFront_2);

                                        % step3: randomization
                                        r=unifrnd(0,1);
                                        if r<=probOfSlowdown
                                           speedNew_2=speedNew_2-1; 
                                        end  
                                        speedNew_2= max(0,speedNew_2);%保证不倒车

                                        % save new speed
                                        LINK_2(cell_i)=speedNew_2;  %将该车的最终速度存储进Link
                                        Vehicle_2(i,3)=speedNew_2;
                                        Vehicle_2(i,2)=cell_i;
                                        All_Speed_2(i,2)=speedNew_2;%更新速度
                                        break;

                                    else %如果是AV
                                        [state_2,action_2,r_2,flag_break_2,speedNew_2] = Q_Learning_step1(Q_0,LINK_2,LINK_1,cell_i,numOfCell,maxSpeed,p,epsilon,nominalSpeed,2);
                                        if flag_break_2 == true
                                            % lane change 
                                            LINK_2(cell_i)=nan; %则换道
                                            LINK_1(cell_i)=speedNew_2; 
                                            Vehicle_2(i,4)=Vehicle_2(i,4)+1; %换道次数+1
                                            Vehicle_2(i,3)=speedNew_2;
                                            type_new_2=Vehicle_2(i,5); %将该车的属性赋值给type_new
                                            flag_new_2=Vehicle_2(i,7);
                                            Vehicle_2(i,6)=1; %将Linkname赋值为1
                                            Vehicle_2(i,1)=0;%将id赋值为0表示下次在该车道不考虑该车
                                            index_1=index_1+1;
                                            Vehicle_1(index_1,1:10)=[index_1,cell_i,speedNew_2,Vehicle_2(i,4),type_new_2,1,flag_new_2,state_2,action_2,r_2];
                                            All_Speed_1(index_1,2)=speedNew_2;%更新速度
                                            break; 
                                        else % 不换道
                                           % save new speed
                                           LINK_2(cell_i)=speedNew_2;  %将该车的最终速度存储进Link
                                           Vehicle_2(i,3)=speedNew_2;
                                           Vehicle_2(i,2)=cell_i;
                                           All_Speed_2(i,2)=speedNew_2;%更新速度
                                           Vehicle_2(i,8:10)=[state_2,action_2,r_2];
                                           break;
                                        end
                                       % save new speed
                                            %[s,a,r,flag_break,speedNew] = Q_Learning_step1(Q_0,LINK_i,LINK_n,cell_i,numOfCell,maxSpeed,p,epsilon,nominalSpeed,c);
                                            %Vehicle_i(i,8:10)=[s,a,r];
    %                                    LINK_2(cell_i)=Vehicle_2(i,3); % 将该车的最终速度存储进Link
    %                                    Vehicle_2(i,2)=cell_i;
    %                                    All_Speed_2(i,2)=Vehicle_2(i,3);%更新速度
    %                                    break;
                                    end
                                end
                            end
                        end
                    end
               end
            end
        else 
            for c=2:-1:1
               if c==1
                    for i=1:1:index_1
                        if Vehicle_1(i,1)==0
                            continue;
                        else
                            for cell_i=1:1:numOfCell
                            % get current speed       
                                speedOld_1= LINK_1(cell_i);
                                if ~isnan(speedOld_1) && Vehicle_1(i,2)==cell_i %当SpeedOld不是nan时,
                                    % 判断车辆类型
                                    if Vehicle_1(i,5)==2 %如果是RV，则CA模型
                                        % step1: acceleration
                                        speedNew_1=speedOld_1+1;
                                        speedNew_1= min(speedNew_1,maxSpeed);

                                        % step2: safety distance
                                        emptyFront_1=GetEmptyFront(LINK_1, numOfCell, maxSpeed, cell_i);  %本车道前距
                                        speedNew_1= min(speedNew_1,emptyFront_1);

                                        % step3: randomization
                                        r=unifrnd(0,1);
                                        if r<=probOfSlowdown
                                           speedNew_1=speedNew_1-1; 
                                        end  
                                        speedNew_1= max(0,speedNew_1);%保证不倒车

                                        % save new speed
                                        LINK_1(cell_i)=speedNew_1;  %将该车的最终速度存储进Link
                                        Vehicle_1(i,3)=speedNew_1;
                                        Vehicle_1(i,2)=cell_i;
                                        All_Speed_1(i,2)=speedNew_1;%更新速度
                                        break;

                                    else %如果是AV
                                        [state_1,action_1,r_1,flag_break_1,speedNew_1] = Q_Learning_step1(Q_0,LINK_1,LINK_2,cell_i,numOfCell,maxSpeed,p,epsilon,nominalSpeed,1);
                                        if flag_break_1 == true
                                            % lane change 
                                            LINK_1(cell_i)=nan;   
                                            LINK_2(cell_i)=speedNew_1;
                                            Vehicle_1(i,4)=Vehicle_1(i,4)+1; %换道次数+1
                                            Vehicle_1(i,3)=speedNew_1;
                                            type_new_1=Vehicle_1(i,5); %将该车的属性赋值给type_new
                                            flag_new_1=Vehicle_1(i,7);
                                            Vehicle_1(i,6)=2; %将Linkname赋值为2
                                            Vehicle_1(i,1)=0;%将id赋值为0表示下次在该车道不考虑该车
                                            index_2=index_2+1;
                                            Vehicle_2(index_2,1:10)=[index_2,cell_i,speedNew_1,Vehicle_1(i,4),type_new_1,2,flag_new_1,state_1,action_1,r_1];% 换道标记也给Vehicle_2
                                            All_Speed_2(index_2,2)=speedNew_1;%更新速度
                                            break;
                                         else
                                           % save new speed
                                           LINK_1(cell_i)=speedNew_1;  %将该车的最终速度存储进Link
                                           Vehicle_1(i,3)=speedNew_1;
                                           Vehicle_1(i,2)=cell_i;
                                           All_Speed_1(i,2)=speedNew_1;%更新速度
                                           Vehicle_1(i,8:10)=[state_1,action_1,r_1];
                                           break;
                                        end
                                       % save new speed
    %                                    [s_1,a_1,r_1,flag_break,speedNew] = Q_Learning_step1(Q_0,LINK_1,LINK_2,cell_i,numOfCell,maxSpeed,p,epsilon,nominalSpeed,1);
                                            %Vehicle_i(i,8:10)=[s,a,r];
                                       %LINK_1(cell_i)=Vehicle_1(i,3); % 将该车的最终速度存储进Link
    %                                    Vehicle_1(i,2)=cell_i;
    %                                    All_Speed_1(i,2)=Vehicle_1(i,3);%更新速度
                                    end
                                end
                            end
                        end
                    end
               else
                    for i=1:1:index_2
                        if Vehicle_2(i,1)==0
                            continue;
                        else
                            for cell_i=1:1:numOfCell
                            % get current speed       
                                speedOld_2= LINK_2(cell_i);
                                if ~isnan(speedOld_2) && Vehicle_2(i,2)==cell_i %当SpeedOld不是nan时,
                                    % 判断车辆类型
                                    if Vehicle_2(i,5)==2 %如果是RV，则CA模型
                                        % step1: acceleration
                                        speedNew_2=speedOld_2+1;
                                        speedNew_2= min(speedNew_2,maxSpeed);

                                        % step2: safety distance
                                        emptyFront_2=GetEmptyFront(LINK_2, numOfCell, maxSpeed, cell_i);  %本车道前距
                                        speedNew_2= min(speedNew_2,emptyFront_2);

                                        % step3: randomization
                                        r=unifrnd(0,1);
                                        if r<=probOfSlowdown
                                           speedNew_2=speedNew_2-1; 
                                        end  
                                        speedNew_2= max(0,speedNew_2);%保证不倒车

                                        % save new speed
                                        LINK_2(cell_i)=speedNew_2;  %将该车的最终速度存储进Link
                                        Vehicle_2(i,3)=speedNew_2;
                                        Vehicle_2(i,2)=cell_i;
                                        All_Speed_2(i,2)=speedNew_2;%更新速度
                                        break;

                                    else %如果是AV
                                        [state_2,action_2,r_2,flag_break_2,speedNew_2] = Q_Learning_step1(Q_0,LINK_2,LINK_1,cell_i,numOfCell,maxSpeed,p,epsilon,nominalSpeed,2);
                                        if flag_break_2 == true
                                            % lane change 
                                            LINK_2(cell_i)=nan; %则换道
                                            LINK_1(cell_i)=speedNew_2; 
                                            Vehicle_2(i,4)=Vehicle_2(i,4)+1; %换道次数+1
                                            Vehicle_2(i,3)=speedNew_2;
                                            type_new_2=Vehicle_2(i,5); %将该车的属性赋值给type_new
                                            flag_new_2=Vehicle_2(i,7);
                                            Vehicle_2(i,6)=1; %将Linkname赋值为1
                                            Vehicle_2(i,1)=0;%将id赋值为0表示下次在该车道不考虑该车
                                            index_1=index_1+1;
                                            Vehicle_1(index_1,1:10)=[index_1,cell_i,speedNew_2,Vehicle_2(i,4),type_new_2,1,flag_new_2,state_2,action_2,r_2];
                                            All_Speed_1(index_1,2)=speedNew_2;%更新速度
                                            break; 
                                        else % 不换道
                                           % save new speed
                                           LINK_2(cell_i)=speedNew_2;  %将该车的最终速度存储进Link
                                           Vehicle_2(i,3)=speedNew_2;
                                           Vehicle_2(i,2)=cell_i;
                                           All_Speed_2(i,2)=speedNew_2;%更新速度
                                           Vehicle_2(i,8:10)=[state_2,action_2,r_2];
                                           break;
                                        end
                                       % save new speed
                                            %[s,a,r,flag_break,speedNew] = Q_Learning_step1(Q_0,LINK_i,LINK_n,cell_i,numOfCell,maxSpeed,p,epsilon,nominalSpeed,c);
                                            %Vehicle_i(i,8:10)=[s,a,r];
    %                                    LINK_2(cell_i)=Vehicle_2(i,3); % 将该车的最终速度存储进Link
    %                                    Vehicle_2(i,2)=cell_i;
    %                                    All_Speed_2(i,2)=Vehicle_2(i,3);%更新速度
    %                                    break;
                                    end
                                end
                            end
                        end
                    end
               end
            end
        end
        %% driving
        NEWLINK_1=NaN(1,numOfCell);  %新建一个Newlink_1
        NEWLINK_2=NaN(1,numOfCell);  %新建一个Newlink_2
        NEWLINK_AV_1=NaN(1,numOfCell);  %新建一个Newlink_AV_1
        NEWLINK_AV_2=NaN(1,numOfCell);  %新建一个Newlink_AV_2
        for i=1:1:index_1
            if Vehicle_1(i,1)==0
                continue;
            else
                for cell_i=1:1:numOfCell
                    if Vehicle_1(i,2)==cell_i
                        newSpeed_1= LINK_1(cell_i);
                        if ~isnan(newSpeed_1)
                            newCell_1=cell_i+newSpeed_1;
                            if newCell_1<=numOfCell % in link
                                NEWLINK_1(cell_i+newSpeed_1)=newSpeed_1; 
                                Route_1(time_i,i)=newCell_1;
                                Speed_1(time_i,i)=newSpeed_1;
                                j=[2;11];
                                Vehicle_1(i,j) = [newCell_1,time_i+1];
                                if Vehicle_1(i,5)==1  %如果是AV，则更新Q表
                                    Q_0 = Q_Learning_step2(Vehicle_1(i,8),Vehicle_1(i,9),Vehicle_1(i,10),Q_0,LINK_1,LINK_2,newCell_1,numOfCell,maxSpeed,p,alpha,gamma,1);
                                    NEWLINK_AV_1(newCell_1)=newSpeed_1;
                                end
                                break;
                            else  % out of link, start from the beginning
                                newCell_1 = cell_i + newSpeed_1 - numOfCell;
                                NEWLINK_1(newCell_1) = newSpeed_1; 
                                Route_1(time_i,i) = newCell_1;
                                Speed_1(time_i,i) = newSpeed_1;
                                j=[2;11];
                                Vehicle_1(i,j) = [newCell_1,time_i+1];
    %                             Vehicle_1(i,11)=time_i+1;
                                if Vehicle_1(i,5)==1  %如果是AV，则更新Q表
                                    Q_0 = Q_Learning_step2(Vehicle_1(i,8),Vehicle_1(i,9),Vehicle_1(i,10),Q_0,LINK_1,LINK_2,newCell_1,numOfCell,maxSpeed,p,alpha,gamma,1);
                                    NEWLINK_AV_1(newCell_1)=newSpeed_1;
                                end
                                break;
                            end
                        end
                    end        
                end
                %Vehicle_1(i,2)=Vehicle_1(i,2)+All_Speed_1(i,2);
            end
        end
        LINK_1=NEWLINK_1;%将newlink赋给link
        LINK_AV_1=NEWLINK_AV_1;

        for i=1:1:index_2
            if Vehicle_2(i,1)==0
                continue;
            else
                for cell_i=1:1:numOfCell
                    if Vehicle_2(i,2)==cell_i
                        newSpeed_2= LINK_2(cell_i);
                        if ~isnan(newSpeed_2)
                            newCell_2=cell_i+newSpeed_2;
                            if newCell_2<=numOfCell % in link
                                NEWLINK_2(cell_i+newSpeed_2)=newSpeed_2;
                                Route_2(time_i,i)=newCell_2;
                                Speed_2(time_i,i)=newSpeed_2;
                                j=[2;11];
                                Vehicle_2(i,j) = [newCell_2,time_i+1];
                                if Vehicle_2(i,5)==1  %如果是AV，则更新Q表
                                    NEWLINK_AV_2(newCell_2)=newSpeed_2;
                                    Q_0 = Q_Learning_step2(Vehicle_2(i,8),Vehicle_2(i,9),Vehicle_2(i,10),Q_0,LINK_2,LINK_1,newCell_2,numOfCell,maxSpeed,p,alpha,gamma,2);
                                end
                                break;
                            else
                                newCell_2 = cell_i + newSpeed_2 - numOfCell;
                                NEWLINK_2(newCell_2) = newSpeed_2; 
                                Route_2(time_i,i) = newCell_2;
                                Speed_2(time_i,i) = newSpeed_2;
                                j=[2;11];
                                Vehicle_2(i,j) = [newCell_2,time_i+1];
                                if Vehicle_2(i,5)==1  %如果是AV，则更新Q表
                                    NEWLINK_AV_2(newCell_2)=newSpeed_2;
                                    Q_0 = Q_Learning_step2(Vehicle_2(i,8),Vehicle_2(i,9),Vehicle_2(i,10),Q_0,LINK_2,LINK_1,newCell_2,numOfCell,maxSpeed,p,alpha,gamma,2);
                                end
                                break;
                            end
                        end
                    end
                end
                %Vehicle_2(i,2)=Vehicle_2(i,2)+All_Speed_2(i,2);
            end
        end
        LINK_2=NEWLINK_2;%将newlink赋给link
        LINK_AV_2=NEWLINK_AV_2;
    end
    
    %%
%save('60to80,EN_ALLDATA_8_6.1.mat');
%save('EN_ALLDATA_train_6_1.mat');
%save('test_AV_2veh.mat');

end
save('EN_ALLDATA_train_1.5_10_2.mat');