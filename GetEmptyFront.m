function emptyFront = GetEmptyFront(LINK, numOfCell, maxSpeed, indexOfCell)
    
    emptyFront=0;                   %则先假设前面没有通行空间
    startIndex=indexOfCell+1;       %将开始标记赋为当前元胞的标记+1
    endIndex=indexOfCell+maxSpeed;  %将结束标记赋为当前元胞的标记+最大速度

    for cell_i=startIndex:1:endIndex
        if cell_i>numOfCell % out of link %如果超出元胞长度，则从初始位置开始运行
            if ~isnan(LINK(cell_i-numOfCell)) % occupied
                break;
            else
                emptyFront=emptyFront+1;
            end
        else % still on a link            %如果未超出元胞长度,则继续运行
            if ~isnan(LINK(cell_i)) % occupied  %如果不是nan,则跳出当前循环,且前方车速为元胞值
                break;
            else       %如果是nan且不满足上述情况，则将前方空间+1
                emptyFront=emptyFront+1;
            end
        end
    end        
        
    end


