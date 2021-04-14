function generate_data()
rng(2021); % Set random seed
N = 1000; % Number of simulations
st = [15, 0.0];
uncP = 5;
uncV = 0.5;
unc_time = 3;
uncP = 2*(rand(N,1)-0.5)*uncP;
uncV = 2*(rand(N,1)-0.5)*uncV;
unc_time = 2*(rand(N,1)-0.5)*unc_time;
tvec = cell(1,N);
states = cell(1,N);
x0 = st(1); % First trajectory has no uncertainty
v0 = st(2);
assignin('base','x0',x0); % Next step initial states
assignin('base','v0',v0);
for i=1:N
    tStop = 7+unc_time(i);
    set_param('ball_bounce', 'StopTime', string(tStop))
    sim('ball_bounce.slx');
    ttemp = velocity.time;
    tvec{i} = ttemp;
    ptemp = position.signals.values;
    vtemp = velocity.signals.values;
    xtemp = [ptemp vtemp];
    states{i} = xtemp;
    assignin('base','x0',st(1)+uncP(i)); % Next step initial states
    assignin('base','v0',st(2)+uncV(i));
end

save('ball_data_gen.mat','tvec','states');
