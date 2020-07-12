function state = msg2state(message)

% consider environment cars (6 params)
num_str = '';
fields = fieldnames(message); %返回message成员的名称列表,str类型

for i = 1:length(fields)-1     %不包括lane_id
   str_temp = num2str(message.(fields{i}) - 1); %返回0或1或2
   num_str = strcat(num_str,str_temp);
end
id_temp = base2dec(num_str,3); %starting from 0 to NUM_STATES/2    = 728  %三进制化为十进制,状态标号

% consider lane info
if message.lane_id == 1
    state = id_temp;
else
    state = 729 + id_temp;
end

state = state + 1;  %starting from 1 to NUM_STATES = 1458

% 车道1：1——>729
% 车道2：730——>1458
