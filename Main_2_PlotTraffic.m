
%%
load('EN_ALLDATA_train_1.5_10.mat');
%load('EN_ALLDATA_10_2.mat');
%load('test_AV_2veh.mat');
%%
figure;
%subplot(2,1,1);
i_1=0;
i_2=0;
sum_1=0;
sum_2=0;
block=0;
for cell_i=1:1:numOfCell
    column_1=ALL_LINK_1(9000:10000,cell_i); %change
    column_1_av=ALL_AV_LINK_1(9000:10000,cell_i);%change
    for t=1:1:1000
        if ~isnan(column_1(t))
            i_1=i_1+1; %1000s内i_1表示所有车辆数N（车道1的）
            sum_1=sum_1+column_1(t);
        end
        if ~isnan(column_1_av(t))
            i_2=i_2+1;
            sum_2=sum_2+column_1_av(t);
        end
    end
    column_1(~isnan(column_1))=cell_i; %用~isnan()函数将column中不为nan的元素赋值为cell_i，
    column_1(isnan(column_1))=-1;  %,为nan的元素赋值为-1
    column_1_av(~isnan(column_1_av))=cell_i;
    column_1_av(isnan(column_1_av))=-1;  
    
    plot(9000:1:10000, column_1(:,1),'k.','MarkerSize',1); hold on;  %k:黑色，markersize：画笔大小为1  %change
    plot(9000:1:10000, column_1_av(:,1),'r.','MarkerSize',0.5); hold on;  %change
end

xlabel('Time lane1','FontSize',12)
ylabel('Space','FontSize',12)  
legend('HV','AV');
set (gcf,'Position',[0,0,1200,1000])  %gcf:返回当前Figure对象的句柄值,设置图像大小和位置
                     %gcf,position后四个数：[pos(1) pos(2)]为绘图区域左下点的坐标 pos(3):长 pos(4):宽 
ylim([0 numOfCell]); %将y轴上下限设定0到numOfcell

AvgSpeed_all = round(sum_1/i_1*3.6*cellL);
AvgSpeed_av = round(sum_2/i_2*3.6*cellL);
fprintf('AverageSpeed of AV on lane 1 = %d\n',AvgSpeed_av);%计算av平均速度
fprintf('AverageSpeed on lane 1 = %d\n',AvgSpeed_all);%计算ALL平均速度

%%
% figure;
% i_1=0;
% i_2=0;
% sum_1=0;
% sum_2=0;
% block=0;
% for cell_i=1:1:numOfCell
%     column_1=ALL_LINK_1(1:1000,cell_i); %change
%     column_1_av=ALL_AV_LINK_1(1:1000,cell_i);%change
%     for t=1:1:1000
%         if ~isnan(column_1(t))
%             i_1=i_1+1; %1000s内i_1表示所有车辆数N（车道1的）
%             sum_1=sum_1+column_1(t);
%         end
%         if ~isnan(column_1_av(t))
%             i_2=i_2+1;
%             sum_2=sum_2+column_1_av(t);
%         end
%     end
%     column_1(~isnan(column_1))=cell_i; %用~isnan()函数将column中不为nan的元素赋值为cell_i，
%     column_1(isnan(column_1))=-1;  %,为nan的元素赋值为-1
%     column_1_av(~isnan(column_1_av))=cell_i;
%     column_1_av(isnan(column_1_av))=-1;  
%     
%     plot(1:1:1000, column_1(:,1),'k.','MarkerSize',1); hold on;  %k:黑色，markersize：画笔大小为1  %change
%     plot(1:1:1000, column_1_av(:,1),'r.','MarkerSize',1); hold on;  %change
% end
% 
% xlabel('Time lane1','FontSize',12)
% ylabel('Space','FontSize',12)  
% 
% set (gcf,'Position',[0,0,1200,1000])  %gcf:返回当前Figure对象的句柄值,设置图像大小和位置
%                      %gcf,position后四个数：[pos(1) pos(2)]为绘图区域左下点的坐标 pos(3):长 pos(4):宽 
% ylim([0 numOfCell]); %将y轴上下限设定0到numOfcell
% 
% AvgSpeed_all = round(sum_1/i_1*3.6*cellL);
% AvgSpeed_av = round(sum_2/i_2*3.6*cellL);
% fprintf('AverageSpeed of AV on lane 1 = %d\n',AvgSpeed_av);%计算av平均速度
% fprintf('AverageSpeed on lane 1 = %d\n',AvgSpeed_all);%计算ALL平均速度
%%
%subplot(2,1,2)
figure;
i_1=0;
i_2=0;
sum_1=0;
sum_2=0;
for cell_i=1:1:numOfCell
    column_2=ALL_LINK_2(9000:10000,cell_i);%change
    column_2_av=ALL_AV_LINK_2(9000:10000,cell_i);%change
    for t=1:1:1000
        if ~isnan(column_2(t))
            i_1=i_1+1;
            sum_1=sum_1+column_2(t);
        end
        if ~isnan(column_2_av(t))
            i_2=i_2+1;
            sum_2=sum_2+column_2_av(t);
        end
    end
    column_2(~isnan(column_2))=cell_i; %用~isnan()函数将column中不为nan的元素赋值为cell_i，
    column_2(isnan(column_2))=-1;  %,为nan的元素赋值为-1
    column_2_av(~isnan(column_2_av))=cell_i;
    column_2_av(isnan(column_2_av))=-1;  
    
    plot(9000:1:10000, column_2(:,1),'k.','MarkerSize',1); hold on;  %k:黑色，markersize：画笔大小为1 %change
    plot(9000:1:10000, column_2_av(:,1),'r.','MarkerSize',0.5); hold on;  %change
end

xlabel('Time lane2','FontSize',12)
ylabel('Space','FontSize',12)  
legend('HV','AV');
set (gcf,'Position',[0,0,1200,1000])  %gcf:返回当前Figure对象的句柄值,设置图像大小和位置
                     %gcf,position后四个数：[pos(1) pos(2)]为绘图区域左下点的坐标 pos(3):长 pos(4):宽 
ylim([0 numOfCell]); %将y轴上下限设定0到numOfcell


AvgSpeed_all = round(sum_1/i_1*3.6*cellL);
AvgSpeed_av = round(sum_2/i_2*3.6*cellL);
fprintf('AverageSpeed of AV on lane 2 = %d\n',AvgSpeed_av);%计算av平均速度
fprintf('AverageSpeed on lane 2 = %d\n',AvgSpeed_all);%计算ALL平均速度
%
% i_1=0;
% sum_1=0;
% subplot(4,1,3)
% for cell_i=1:1:numOfCell
%     column_2=ALL_LINK_2(9000:10000,cell_i);
%     for t=1:1:1000
%         if ~isnan(column_2(t))
%             i_1=i_1+1;
%             sum_1=sum_1+column_2(t);
%         end
%     end
%     column_2(~isnan(column_2))=cell_i; %用~isnan()函数将column中不为nan的元素赋值为cell_i，
%     column_2(isnan(column_2))=-1;  %,为nan的元素赋值为-1 
%     
%     plot(9000:1:10000, column_2(:,1),'k.','MarkerSize',1); hold on;  %k:黑色，markersize：画笔大小为1
%     
% end
% xlabel('Time lane2','FontSize',12)
% ylabel('Space','FontSize',12)  
% 
% set (gcf,'Position',[0,0,1200,1000])  %gcf:返回当前Figure对象的句柄值,设置图像大小和位置
%                      %gcf,position后四个数：[pos(1) pos(2)]为绘图区域左下点的坐标 pos(3):长 pos(4):宽 
% ylim([0 numOfCell]); %将y轴上下限设定0到numOfcell
% 
% AvgSpeed = sum_1/i_1;
% fprintf('AverageSpeed of lane 2 = %d\n',AvgSpeed);

% %%
% subplot(4,1,4)
% i_2=0;
% sum_2=0;
% for cell_i=1:1:numOfCell
%     column_2_av=ALL_AV_LINK_2(9000:10000,cell_i);
%     for t=1:1:1000
%         
%         if ~isnan(column_2_av(t))
%             i_2=i_2+1;
%             sum_2=sum_2+column_2_av(t);
%         end
%     end
%     column_2_av(~isnan(column_2_av))=cell_i;
%     column_2_av(isnan(column_2_av))=-1;  
%     
%     plot(9000:1:10000, column_2_av(:,1),'r.','MarkerSize',1); hold on; 
% end
% xlabel('Time lane2','FontSize',12)
% ylabel('Space','FontSize',12)  
% 
% set (gcf,'Position',[0,0,1200,1000])  %gcf:返回当前Figure对象的句柄值,设置图像大小和位置
%                      %gcf,position后四个数：[pos(1) pos(2)]为绘图区域左下点的坐标 pos(3):长 pos(4):宽 
% ylim([0 numOfCell]); %将y轴上下限设定0到numOfcell
% 
% AvgSpeed_av = sum_2/i_2;
% fprintf('AverageSpeed of AV on lane 2 = %d\n',AvgSpeed_av);%计算av平均速度
%%
% i_1=0;
% sum_1=0;
% i_2=0;
% sum_2=0;
% subplot(4,1,3)
% for i=1:1:index_1
%     column_3=Route_1(1:1000,i);
%     column_3(isnan(column_3))=-1;
%     column_3_speed=Speed_1(1:1000,i);
%     for t=1:1:1000
%         
%         if ~isnan(column_3_speed(t))
%              if Vehicle_1(i,5)==1 && Vehicle_1(i,1)~=0  %如果是AV,且在车道1上
%                  i_1=i_1+1;%加和AV的数量
%                  sum_1=sum_1+column_3_speed(t); %加和AV的速度
%              else
%                  i_2=i_2+1;
%                  sum_2=sum_2+column_3_speed(t);
%              end
%         end
%     end
%     if Vehicle_1(i,5)==1  %如果是AV
%         if Vehicle_1(i,1)==0 %如果有换道
%             plot(9000:1:maxTime, column_3(:,1),'b.','MarkerSize',1); hold on;  
%         else
%             plot(9000:1:maxTime, column_3(:,1),'b.','MarkerSize',1); hold on;  %r:红色，markersize：画笔大小为4
%         end
%     else
%         plot(9000:1:maxTime, column_3(:,1),'k.','MarkerSize',1); hold on;  %k:黑色，markersize：画笔大小为1
%     end
% end
% xlabel('Time lane1','FontSize',12)
% ylabel('Space','FontSize',12)  
% 
% set (gcf,'Position',[0,0,1200,1000])  %gcf:返回当前Figure对象的句柄值,设置图像大小和位置
%                      %gcf,position后四个数：[pos(1) pos(2)]为绘图区域左下点的坐标 pos(3):长 pos(4):宽 
% ylim([0 numOfCell]); %将y轴上下限设定0到numOfcell
% 
% AvgSpeed_av = sum_1/i_1;
% AvgSpeed = sum_2/i_2;
% fprintf('AverageSpeed of AV on lane 1 = %d\n',AvgSpeed_av);
% fprintf('AverageSpeed of HV on lane 1 = %d\n',AvgSpeed);

%%
% i_1=0;
% sum_1=0;
% i_2=0;
% sum_2=0;
% subplot(2,1,1)
% for i=1:1:index_1
%     column_3=Route_1(9000:10000,i);
%     column_3(isnan(column_3))=-1;
%     column_3_speed=Speed_1(9000:10000,i);
%     for t=1:1:1000
%         if ~isnan(column_3_speed(t))
%              if Vehicle_1(i,5)==1 && Vehicle_1(i,1)~=0  %如果是AV,且在车道1上
%                  i_1=i_1+1;%加和AV的数量
%                  sum_1=sum_1+column_3_speed(t); %加和AV的速度
%              else
%                  i_2=i_2+1;
%                  sum_2=sum_2+column_3_speed(t);
%              end
%         end
%     end
%     if Vehicle_1(i,5)==1  %如果是AV
%         if Vehicle_1(i,1)==0 %如果有换道
%             plot(9000:1:maxTime, column_3(:,1),'b.','MarkerSize',1); hold on;  
%         else
%             plot(9000:1:maxTime, column_3(:,1),'b.','MarkerSize',1); hold on;  %r:红色，markersize：画笔大小为4
%         end
%     else
%         plot(9000:1:maxTime, column_3(:,1),'k.','MarkerSize',1); hold on;  %k:黑色，markersize：画笔大小为1
%     end
% end
% xlabel('Time lane1','FontSize',12)
% ylabel('Space','FontSize',12)  
% 
% set (gcf,'Position',[0,0,1200,1000])  %gcf:返回当前Figure对象的句柄值,设置图像大小和位置
%                      %gcf,position后四个数：[pos(1) pos(2)]为绘图区域左下点的坐标 pos(3):长 pos(4):宽 
% ylim([0 numOfCell]); %将y轴上下限设定0到numOfcell
% 
% AvgSpeed_av = sum_1/i_1;
% AvgSpeed = sum_2/i_2;
% fprintf('AverageSpeed of AV on lane 1 = %d\n',AvgSpeed_av);
% fprintf('AverageSpeed of HV on lane 1 = %d\n',AvgSpeed);
% % 
% %%
% i_1=0;
% sum_1=0;
% i_2=0;
% sum_2=0;
% subplot(2,1,2)
% for i=1:1:index_2
%     column_4=Route_2(9000:10000,i);
%     column_4(isnan(column_4))=-1;
%     column_4_speed=Speed_2(9000:10000,i);
%     for t=1:1:1000
%         if ~isnan(column_4_speed(t))
%              if Vehicle_2(i,5)==1 
%                  i_1=i_1+1;
%                  sum_1=sum_1+column_4_speed(t); %加和AV的速度
%              else
%                  i_2=i_2+1;
%                  sum_2=sum_2+column_4_speed(t); %加和HV的速度
%              end
%         end
%     end
%     if Vehicle_2(i,5)==1
%         if Vehicle_2(i,1)==0
%             plot(9000:1:maxTime, column_4(:,1),'b.','MarkerSize',1); hold on;  
%         else
%             plot(9000:1:maxTime, column_4(:,1),'b.','MarkerSize',1); hold on;  %r:红色，markersize：画笔大小为1
%         end
%     else
%         plot(9000:1:maxTime, column_4(:,1),'k.','MarkerSize',1); hold on;  %k:黑色，markersize：画笔大小为1
%     end
% end
% xlabel('Time lane2','FontSize',12)
% ylabel('Space','FontSize',12)  
% 
% set (gcf,'Position',[0,0,1200,1000])  %gcf:返回当前Figure对象的句柄值,设置图像大小和位置
%                      %gcf,position后四个数：[pos(1) pos(2)]为绘图区域左下点的坐标 pos(3):长 pos(4):宽 
% ylim([0 numOfCell]); %将y轴上下限设定0到numOfcell
% 
% AvgSpeed_av = sum_1/i_1;
% AvgSpeed = sum_2/i_2;
% 
% fprintf('AverageSpeed of AV on lane 2 = %d\n',AvgSpeed_av);
% fprintf('AverageSpeed of HV on lane 2 = %d\n',AvgSpeed); %不考虑第1s的速度
% 
% %% calculate density
% Sum_density_1=0;
% Sum_density_2=0;
% for t=9000:1:maxTime
%     Car_1=0;
%     for l=1:1:numOfCell
%         if ~isnan(ALL_LINK_1(t,l))
%             Car_1=Car_1+1;
%         end
%     end
%     Sum_density_1 = Sum_density_1+Car_1/(numOfCell*cellL*1e-03);
% end
% 
% for t=9000:1:maxTime
%     Car_2=0;
%     for l=1:1:numOfCell
%         if ~isnan(ALL_LINK_2(t,l))
%             Car_2=Car_2+1;
%         end
%     end
%     Sum_density_2 = Sum_density_2+Car_2/(numOfCell*cellL*1e-03);
% end
% density_1 = round(Sum_density_1/1000);
% density_2 = round(Sum_density_2/1000);
% fprintf('\nAverageDensity on lane 1 = %d\n',density_1);
% fprintf('\nAverageDensity on lane 2 = %d\n',density_2);


%% test 1000s
% %%
% i_1=0;
% sum_1=0;
% i_2=0;
% sum_2=0;
% subplot(2,1,1)
% for i=1:1:index_1
%     column_3=Route_1(1:1000,i);
%     column_3(isnan(column_3))=-1;
%     column_3_speed=Speed_1(1:1000,i);
%     for t=1:1:1000
%         if ~isnan(column_3_speed(t))
%              if Vehicle_1(i,5)==1 %如果是AV
%                  i_1=i_1+1;%加和AV的数量
%                  sum_1=sum_1+column_3_speed(t); %加和AV的速度
%              else
%                  i_2=i_2+1;
%                  sum_2=sum_2+column_3_speed(t);
%              end
%         end
%     end
%     if Vehicle_1(i,5)==1  
%         if Vehicle_1(i,1)==0 %如果有换道
%             plot(1:1:1000, column_3(:,1),'b.','MarkerSize',1); hold on;  
%         else
%             plot(1:1:1000, column_3(:,1),'r.','MarkerSize',1); hold on;  %r:红色，markersize：画笔大小为4
%         end
%     else
%         plot(1:1:1000, column_3(:,1),'k.','MarkerSize',1); hold on;  %k:黑色，markersize：画笔大小为1
%     end
% end
% xlabel('Time lane1','FontSize',12)
% ylabel('Space','FontSize',12)  
% 
% set (gcf,'Position',[0,0,1200,1000])  %gcf:返回当前Figure对象的句柄值,设置图像大小和位置
%                      %gcf,position后四个数：[pos(1) pos(2)]为绘图区域左下点的坐标 pos(3):长 pos(4):宽 
% ylim([0 numOfCell]); %将y轴上下限设定0到numOfcell
% 
% AvgSpeed_av = sum_1/i_1;
% AvgSpeed = sum_2/i_2;
% fprintf('AverageSpeed of AV on lane 1 = %d\n',AvgSpeed_av);
% fprintf('AverageSpeed of HV on lane 1 = %d\n',AvgSpeed);
% 
% %%
% i_1=0;
% sum_1=0;
% i_2=0;
% sum_2=0;
% subplot(2,1,2)
% for i=1:1:index_2
%     column_4=Route_2(1:1000,i);
%     column_4(isnan(column_4))=-1;
%     column_4_speed=Speed_2(1:1000,i);
%     for t=1:1:1000
%         if ~isnan(column_4_speed(t))
%              if Vehicle_2(i,5)==1 
%                  i_1=i_1+1;
%                  sum_1=sum_1+column_4_speed(t); %加和AV的速度
%              else
%                  i_2=i_2+1;
%                  sum_2=sum_2+column_4_speed(t); %加和HV的速度
%              end
%         end
%     end
%     if Vehicle_2(i,5)==1
%         if Vehicle_2(i,1)==0
%             plot(1:1:1000, column_4(:,1),'b.','MarkerSize',1); hold on;  
%         else
%             plot(1:1:1000, column_4(:,1),'r.','MarkerSize',1); hold on;  %r:红色，markersize：画笔大小为1
%         end
%     else
%         plot(1:1:1000, column_4(:,1),'k.','MarkerSize',1); hold on;  %k:黑色，markersize：画笔大小为1
%     end
% end
% xlabel('Time lane2','FontSize',12)
% ylabel('Space','FontSize',12)  
% 
% set (gcf,'Position',[0,0,1200,1000])  %gcf:返回当前Figure对象的句柄值,设置图像大小和位置
%                      %gcf,position后四个数：[pos(1) pos(2)]为绘图区域左下点的坐标 pos(3):长 pos(4):宽 
% ylim([0 numOfCell]); %将y轴上下限设定0到numOfcell
% 
% AvgSpeed_av = sum_1/i_1;
% AvgSpeed = sum_2/i_2;
% 
% fprintf('AverageSpeed of AV on lane 2 = %d\n',AvgSpeed_av);
% fprintf('AverageSpeed of HV on lane 2 = %d\n',AvgSpeed); %不考虑第1s的速度
% 
% %% calculate density
% Sum_density_1=0;
% Sum_density_2=0;
% for t=1:1:1000
%     Car_1=0;
%     for l=1:1:numOfCell
%         if ~isnan(ALL_LINK_1(t,l))
%             Car_1=Car_1+1;
%         end
%     end
%     Sum_density_1 = Sum_density_1+Car_1/(numOfCell*cellL*1e-03);
% end
% 
% for t=1:1:1000
%     Car_2=0;
%     for l=1:1:numOfCell
%         if ~isnan(ALL_LINK_2(t,l))
%             Car_2=Car_2+1;
%         end
%     end
%     Sum_density_2 = Sum_density_2+Car_2/(numOfCell*cellL*1e-03);
% end
% density_1 = round(Sum_density_1/1000);
% density_2 = round(Sum_density_2/1000);
% fprintf('\nAverageDensity on lane 1 = %d\n',density_1);
% fprintf('\nAverageDensity on lane 2 = %d\n',density_2);

