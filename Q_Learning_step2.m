function Q = Q_Learning_step2(state,action,reward,Q,LINK,TLINK,IndexOfCell,numOfCell,maxSpeed,p,alpha,gamma,lane_id)
% get state_n
[state_n,~] = GetStateAction(LINK,TLINK,IndexOfCell,numOfCell,maxSpeed,p,lane_id);

% Bellman update on Q
Q(state,action) = Q(state,action) + alpha * (reward + gamma * max(Q(state_n,:)) - Q(state,action)); %Bellman·½³Ì

end

