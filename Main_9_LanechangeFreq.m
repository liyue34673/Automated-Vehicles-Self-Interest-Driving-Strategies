clear;
clc;
load('EN_ALLDATA_2_0.mat');

%%
sum_1=0;
i_1=0;
i_3=0;
for i=1:1:index_1 %车道一的换道次数统计
    if Vehicle_1(i,5)==1 && Vehicle_1(i,1)~=0 %如果是AV且最后仍行驶在车道1
        if Vehicle_1(i,4)~=0 %换过道
            sum_1=sum_1+Vehicle_1(i,4);
            i_1=i_1+1; %换道AV计数
        end
        i_3=i_3+1; %AV计数 
    end
end

sum_2=0;
i_2=0;
i_4=0;
for i=1:1:index_2 %车道二的换道次数统计
    if Vehicle_2(i,5)==1 && Vehicle_2(i,1)~=0 %如果是AV且仍停留在该车道（防止重复计数）
        if Vehicle_2(i,4)~=0 %换过道
            sum_2=sum_2+Vehicle_2(i,4);
            i_2=i_2+1; %换道AV计数
        end
        i_4=i_4+1; %AV计数 
    end
end

times_1=round(sum_1/i_1);
times_2=round(sum_2/i_2);
Avg_2=round((times_1+times_2)/2);


percent_1=i_1/i_3;
percent_2=i_2/i_4;
Avg=(percent_1+percent_2)/2;

fprintf('Lane change frequency of AV on lane 1 = %d\n',percent_1);
fprintf('Lane change frequency of AV on lane 2 = %d\n',percent_2);

fprintf('Average Lane change frequency of AV = %d\n',Avg);

fprintf('Lane change times of AV on lane 1 = %d\n',times_1);
fprintf('Lane change times of AV on lane 2 = %d\n',times_2);

fprintf('Average Lane change times of AV = %d\n',Avg_2);