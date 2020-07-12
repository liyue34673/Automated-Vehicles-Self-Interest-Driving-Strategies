%% 限制换道次数=1次
% 20% AV, density=20
i= [.4,.6,.8, 1];
q_o = [1936, 1989, 2012, 2160];
q_n = [1920, 1984, 1995, 2139];
s_o = [97.0, 99.72,100.60, 108.02];
s_n = [96.86, 99.30, 100.23, 108.02];
% density=30
q_o_3 = [1831,2065,1850,2460];
q_n_3 = [1765, 2000, 2265, 2421];
s_o_3 = [60.66, 69.13, 62.52, 83.49];
s_n_3 = [58.77, 65, 76.41, 82];
% density=40
q_o_4 = [1689,1510,1921,2310];
q_n_4 = [1705, 1888, 1872, 2116];
s_o_4 = [42.81,36.92,47.54,58.93];
s_n_4 = [43.65,49.16,45.68,54.94];

%% 不限制换道次数

%% q-k图
% lane1+lane2
% D=20
subplot(6,1,1)
plot(i, q_o, '-or','MarkerSize',4,'MarkerFaceColor','r','LineWidth',1.4); hold on;  
plot(i, q_n ,'-pk','MarkerSize',4,'MarkerFaceColor','k','LineWidth',1.4); hold on;  

xlabel('p_a_v','FontSize',12)
ylabel('Flow (veh/h)','FontSize',12)  

set (gcf,'Position',[0,0,200,400])  %gcf:返回当前Figure对象的句柄值,设置图像大小和位置
                     %gcf,position后四个数：[pos(1) pos(2)]为绘图区域左下点的坐标 pos(3):长 pos(4):宽 
ylim([1000 2500])
xlim([0.4,1])
set(gca,'XTick',0.4:0.2:1.0);
set(gca,'XTicklabel',{'0.4','0.6','0.8','1.0'})
legend('original','new')
%% D=30
% lane1+lane2
subplot(6,1,2)
plot(i, q_o_3, '-or','MarkerSize',4,'MarkerFaceColor','r','LineWidth',1.4); hold on;  
plot(i, q_n_3 ,'-pk','MarkerSize',4,'MarkerFaceColor','k','LineWidth',1.4); hold on;  

xlabel('p_a_v','FontSize',12)
ylabel('Flow (veh/h)','FontSize',12)  

set (gcf,'Position',[0,0,200,400])  %gcf:返回当前Figure对象的句柄值,设置图像大小和位置
                     %gcf,position后四个数：[pos(1) pos(2)]为绘图区域左下点的坐标 pos(3):长 pos(4):宽 
ylim([1000 2500])
xlim([0.4,1])
set(gca,'XTick',0.4:0.2:1.0);
set(gca,'XTicklabel',{'0.4','0.6','0.8','1.0'})
legend('original','new')
%% D=40
subplot(6,1,3)
plot(i, q_o_4, '-or','MarkerSize',4,'MarkerFaceColor','r','LineWidth',1.4); hold on;  
plot(i, q_n_4 ,'-pk','MarkerSize',4,'MarkerFaceColor','k','LineWidth',1.4); hold on;  

xlabel('p_a_v','FontSize',12)
ylabel('Flow (veh/h)','FontSize',12)  

set (gcf,'Position',[0,0,200,400])  %gcf:返回当前Figure对象的句柄值,设置图像大小和位置
                     %gcf,position后四个数：[pos(1) pos(2)]为绘图区域左下点的坐标 pos(3):长 pos(4):宽 
ylim([1000 2500])
xlim([0.4,1])
set(gca,'XTick',0.4:0.2:1.0);
set(gca,'XTicklabel',{'0.4','0.6','0.8','1.0'})
legend('original','new')
%% q-v图
subplot(6,1,4)
plot(i, s_o, '-or','MarkerSize',4,'MarkerFaceColor','r','LineWidth',1.4); hold on;  
plot(i, s_n ,'-pk','MarkerSize',4,'MarkerFaceColor','k','LineWidth',1.4); hold on;  

xlabel('p_a_v','FontSize',12)
ylabel('Speed (km/h)','FontSize',12)  

set (gcf,'Position',[0,0,800,1000])  %gcf:返回当前Figure对象的句柄值,设置图像大小和位置
                     %gcf,position后四个数：[pos(1) pos(2)]为绘图区域左下点的坐标 pos(3):长 pos(4):宽 

xlim([0.4,1])
set(gca,'XTick',0.4:0.2:1.0);
set(gca,'XTicklabel',{'0.4','0.6','0.8','1.0'})
legend('original','new');

%% q-v图
subplot(6,1,5)
plot(i, s_o_3, '-or','MarkerSize',4,'MarkerFaceColor','r','LineWidth',1.4); hold on;  
plot(i, s_n_3 ,'-pk','MarkerSize',4,'MarkerFaceColor','k','LineWidth',1.4); hold on;  

xlabel('p_a_v','FontSize',12)
ylabel('Speed (km/h)','FontSize',12)  

set (gcf,'Position',[0,0,800,1000])  %gcf:返回当前Figure对象的句柄值,设置图像大小和位置
                     %gcf,position后四个数：[pos(1) pos(2)]为绘图区域左下点的坐标 pos(3):长 pos(4):宽 

xlim([0.4,1])
set(gca,'XTick',0.4:0.2:1.0);
set(gca,'XTicklabel',{'0.4','0.6','0.8','1.0'})
legend('original','new');

%% q-v图
subplot(6,1,6)
plot(i, s_o_4, '-or','MarkerSize',4,'MarkerFaceColor','r','LineWidth',1.4); hold on;  
plot(i, s_n_4 ,'-pk','MarkerSize',4,'MarkerFaceColor','k','LineWidth',1.4); hold on;  

xlabel('p_a_v','FontSize',12)
ylabel('Speed (km/h)','FontSize',12)  

set (gcf,'Position',[0,0,800,1000])  %gcf:返回当前Figure对象的句柄值,设置图像大小和位置
                     %gcf,position后四个数：[pos(1) pos(2)]为绘图区域左下点的坐标 pos(3):长 pos(4):宽 

xlim([0.4,1])
set(gca,'XTick',0.4:0.2:1.0);
set(gca,'XTicklabel',{'0.4','0.6','0.8','1.0'})
legend('original','new');
