function r = GetReward(nominalSpeed,newSpeed,a)
%nominal_speed = 2;
%max_speed =4;
%mini_speed=0;
w1=10;
w2=1;
r = w1*0.5*(newSpeed-nominalSpeed)+w2*a;
end

