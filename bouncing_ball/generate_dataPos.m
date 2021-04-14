function generate_dataPos()
rng(2021); % Set random seed
N = 1000; % Number of simulations
st = [17.0, 0.0];
unc = 5;
unc = 2*(rand(N,2)-0.5)*unc;
tvec = cell(1,N);
states = cell(1,N);
x0 = st(1); % First trajectory has no uncertainty
v0 = st(2);
assignin('base','x0',x0); % Next step initial states
assignin('base','v0',v0);
for i=1:N
    sim('ball_bounce.slx');
    ttemp = velocity.time;
    tvec{i} = ttemp;
    ptemp = position.signals.values;
    states{i} = ptemp;
    assignin('base','x0',st(1)+unc(i,1)); % Next step initial states
    assignin('base','v0',st(2));
end

save('ball_pos_gen.mat','tvec','states');
