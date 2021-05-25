%% Run all MNIST related experiments
cd cnn;
run run_all.m;

disp('Done with CNN experiments');

cd ..;
cd ffnn;
run run_all.m;

disp('Finish all experiments');

cd ..
run create_table.