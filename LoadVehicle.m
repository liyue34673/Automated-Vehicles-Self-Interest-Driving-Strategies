function [LINK,Vehicle,index,flag] = LoadVehicle(curTime, LINK, maxSpeed,linkname,Vehicle,index,flag)
    if mod(curTime,2)==0 && isnan(LINK(1,1)) && (flag<150) %如果curTime是偶数且Link矩阵第一行一列的数为NAN,且生成车辆每车道不超过300辆
        LINK(1,1)=maxSpeed; %那么将Link矩阵第一行一列的/数赋值为最大速度
        index=index+1;
        flag=flag+1;
        %r=unifrnd(0,1);
%         if mod(flag,5)==0 %生成AV  20%  
        if mod(flag,14)==0 %生成10辆AV*2  
            [id,position,curSpeed,changeLine,Vtype,LINKname,curflag,state,action,reward,curTime]=SetVehicle(index,1,linkname,1,1,LINK,0,0,0,0,curTime);
            Vehicle(index,:)=[id,position,curSpeed,changeLine,Vtype,LINKname,curflag,state,action,reward,curTime];
        else %    生成HV
            [id,position,curSpeed,changeLine,Vtype,LINKname,curflag,state,action,reward,curTime]=SetVehicle(index,1,linkname,2,1,LINK,0,nan,nan,nan,curTime);
            Vehicle(index,:)=[id,position,curSpeed,changeLine,Vtype,LINKname,curflag,state,action,reward,curTime];
            
        end
    end  %如果不满足上述条件，则输出原Link的值
        
%     if isnan(LINK(1,1))
%         r=unifrnd(0,1);
%         if r<=0.5
%             LINK(1,1)=maxSpeed;            
%         end
%     end index,IndexOfCell,LinkName,type,flag,LINK,change,state,action,reward,curtime
    
end

