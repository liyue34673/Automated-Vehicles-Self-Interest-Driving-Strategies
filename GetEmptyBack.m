function [emptyBackD,vBack] = GetEmptyBack(LINK, maxSpeed, indexOfCell,numOfCell)

        emptyBackD=0;                   %后方没有通行空间
        vBack=0;                        %后方车速为0
        startIndex=indexOfCell-1;      %将开始标记赋为当前元胞的标记-1 
        endIndex=indexOfCell-maxSpeed;  %%将结束标记赋为当前元胞的标记-最大速度

        for cell_i=startIndex:-1:endIndex
            if cell_i<1 % out of link %如果超出元胞起点，则退至道路末端
                if ~isnan(LINK(cell_i+numOfCell)) % occupied
                    vBack=LINK(cell_i+numOfCell);
                    break;
                else
                    emptyBackD=emptyBackD+1;
                end
            else % still on a link            %如果未超出元胞起点
                if ~isnan(LINK(cell_i)) % occupied  %如果不是nan,则跳出当前循环
                    vBack=LINK(cell_i);
                    break;
                else       %如果是nan，则将前方空间+1
                    emptyBackD=emptyBackD+1;
                end
            end
        end        
        
end
