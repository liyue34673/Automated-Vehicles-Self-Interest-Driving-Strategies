function [id,position,curSpeed,changeLine,Vtype,LINKname,curflag,State,Action,Reward,time]=SetVehicle(index,IndexOfCell,LinkName,type,flag,LINK,change,state,action,reward,curtime)
    
    position=IndexOfCell;
    curSpeed=LINK(IndexOfCell);
    changeLine=change;
    Vtype=type;
    LINKname=LinkName;
    curflag=flag;
    id=index;
    State=state;
    Action=action;
    Reward=reward;
    time=curtime;

end

