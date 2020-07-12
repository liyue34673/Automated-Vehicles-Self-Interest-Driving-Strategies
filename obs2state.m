function state = obs2state(obs,maxSpeed)

msg = obs2msg(obs,maxSpeed);
state = msg2state(msg);

end

