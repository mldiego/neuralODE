% Process reach times
addpath('../mnist');
pwl = load('reach_pwl.mat');
nl = load('reach_nl.mat');
cav1 = load('reach_cav1.mat');
cav2 = load('reach_cav2.mat');
cav3 = load('reach_cav3.mat');
cav4 = load('reach_cav4.mat');
cav5 = load('reach_cav5.mat');
cav6 = load('reach_cav6.mat');

col_1 = [cav1.tc; cav2.tc; cav3.tc; cav4.tc; cav5.tc; cav6.tc; pwl.tc; nl.tc]; % c) -> 0.02
col_2 = [cav1.tb; cav2.tb; cav3.tb; cav4.tb; cav5.tb; cav6.tb; pwl.tb; nl.tb]; % b) -> 0.1
col_3 = [cav1.ta; cav2.ta; cav3.ta; cav4.ta; cav5.ta; cav6.ta; pwl.ta; nl.ta]; % a) -> 0.2
col_4 = zeros(8,1);
for i = 1:length(col_1)
    col_4(i) = (col_1(i)+col_2(i)+col_3(i))/3; % average
end
% names = ['RM$_1$'; 'RM$_2$'; 'RM$_3$'; 'RM$_4$'; 'RM$_5$'; 'RM$_6$'; 'RM$_7$'; 'RM$_8$'];

colmns = {'$\delta_{\mu}$ = 0.02' , '$\delta_{\mu}$ = 0.1' , '$\delta_{\mu}$ = 0.2' , 'Avg. Time (s)'}; 
T = table(col_1, col_2, col_3, col_4);

% T.Properties.VariableNames = colmns;

table2latex(T,'randEx_res.tex')