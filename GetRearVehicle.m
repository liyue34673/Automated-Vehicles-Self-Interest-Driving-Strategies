function [speedRear, RearDistance] = GetRearVehicle( LINK,indexOfCell,numOfCell)
  
startIndex = indexOfCell-1;       %将开始标记赋为当前元胞的标记-1
endIndex = indexOfCell+1-numOfCell; 

RearDistance=numOfCell-1;        %先假设后面一直没有车
speedRear=0;

for cell_i=startIndex:-1:endIndex
    if cell_i<1 % out of link %如果超出元胞起点，则退至道路末端
        if ~isnan(LINK(cell_i+numOfCell))
            RearDistance=indexOfCell-cell_i;
            speedRear=LINK(cell_i+numOfCell);
            break;
        end
    else % in link
        if ~isnan(LINK(cell_i))
            RearDistance=indexOfCell-cell_i;
            speedRear=LINK(cell_i);
            break;
        end
    end        
        
end