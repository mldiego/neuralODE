%% Create demo video of neural ODE reachsets
% Load the reach sets (Will use the 30 second time horizon only)
linear = load('reach_linear_30.mat');
nonlinear = load('reach_nonlinear_30_1.mat');
nonlinear_ps = load('reach_nonlinear_30_pointSet.mat');

% compute the output layer of timepointSets

% Initialize array to store frames
total_frames = 600;
VideoFrames(total_frames+1) = struct('cdata',[],'colormap',[]);

% Initialize figure
f = figure;
hold on;
p1 = plot([-1.5096;-1.4896],[-0.470;-0.470],'b');
p2 = plot([-1.5096;-1.4896],[-0.470;-0.470],'r');
% hold on;
Star.plotBoxes_2D_noFill(linear.Rb(1),1,2,'r');
legend([p1 p2],{'Linear','Nonlinear'});
title('Damped Oscillator - ILNODE');
xlabel('x_1');
ylabel('x_2');
VideoFrames(1) = getframe(f);
for n = 2:total_frames+1
    legend('off');
    Star.plotBoxes_2D_noFill(nonlinear.Rb(n-1),1,2,'r');
    Star.plotBoxes_2D_noFill(linear.Rb(n),1,2,'b');
    legend([p1 p2],{'Linear','Nonlinear'});
    VideoFrames(n) = getframe(f);
end

% fig2 = figure;
% movie(fig2,VideoFrames,10);

% Create video one (Interval intermediate reach sets)
% create the video writer with 1 fps
writerObj = VideoWriter('demo1.avi');
writerObj.FrameRate = 5;
% open the video writer
open(writerObj);
% write the frames to the video
for u=1:length(VideoFrames)
    writeVideo(writerObj, VideoFrames(u));
end
% close the writer object
close(writerObj);
 
 
 %% Video 2 (Interval with set axis)

% Initialize array to store frames
total_frames = 600;
VideoFrames(total_frames+1) = struct('cdata',[],'colormap',[]);

% Initialize figure
f = figure;
hold on;
p1 = plot([-1.5096;-1.4896],[-0.470;-0.470],'b');
p2 = plot([-1.5096;-1.4896],[-0.470;-0.470],'r');
xlim([-2 1.3])
ylim([-1.5 1.5])
% hold on;
Star.plotBoxes_2D_noFill(linear.Rb(1),1,2,'r');
legend([p1 p2],{'Linear','Nonlinear'});
title('Damped Oscillator - ILNODE');
xlabel('x_1');
ylabel('x_2');
VideoFrames(1) = getframe(f);
for n = 2:total_frames+1
    legend('off');
    Star.plotBoxes_2D_noFill(nonlinear.Rb(n-1),1,2,'r');
    Star.plotBoxes_2D_noFill(linear.Rb(n),1,2,'b');
    legend([p1 p2],{'Linear','Nonlinear'});
    VideoFrames(n) = getframe(f);
end

% % fig2 = figure;
% % movie(fig2,VideoFrames,10);
% 
% Create video one (Interval intermediate reach sets)
% create the video writer with 1 fps
writerObj = VideoWriter('demo1_fix.avi');
writerObj.FrameRate = 5;
% open the video writer
open(writerObj);
% write the frames to the video
for u=1:length(VideoFrames)
    writeVideo(writerObj, VideoFrames(u));
end
% close the writer object
close(writerObj);

%% Video 3 (Point Set with set axis)

% Initialize array to store frames
total_frames = 600;
VideoFrames(total_frames+1) = struct('cdata',[],'colormap',[]);

% Initialize figure
f = figure;
hold on;
p1 = plot([-1.5096;-1.4896],[-0.470;-0.470],'b');
p2 = plot([-1.5096;-1.4896],[-0.470;-0.470],'r');
xlim([-2 1.3])
ylim([-1.5 1.5])
% hold on;
Star.plotBoxes_2D_noFill(linear.Rb(1),1,2,'r');
legend([p1 p2],{'Linear','Nonlinear'});
title('Damped Oscillator - ILNODE');
xlabel('x_1');
ylabel('x_2');
VideoFrames(1) = getframe(f);
for n = 2:total_frames+1
    legend('off');
    Star.plotBoxes_2D_noFill(nonlinear_ps.Rb(n-1),1,2,'r');
    Star.plotBoxes_2D_noFill(linear.Rb(n),1,2,'b');
    legend([p1 p2],{'Linear','Nonlinear'});
    VideoFrames(n) = getframe(f);
end

% fig2 = figure;
% movie(fig2,VideoFrames,10);

% Create video one (Interval intermediate reach sets)
% create the video writer with 1 fps
writerObj = VideoWriter('demo2_fix.avi');
writerObj.FrameRate = 5;
% open the video writer
open(writerObj);
% write the frames to the video
for u=1:length(VideoFrames)
    writeVideo(writerObj, VideoFrames(u));
end
% close the writer object
close(writerObj);


%% Video 4 (Point Set)

% Initialize array to store frames
total_frames = 600;
VideoFrames(total_frames+1) = struct('cdata',[],'colormap',[]);

% Initialize figure
f = figure;
hold on;
p1 = plot([-1.5096;-1.4896],[-0.470;-0.470],'b');
p2 = plot([-1.5096;-1.4896],[-0.470;-0.470],'r');
% xlim([-2 1.3])
% ylim([-1.5 1.5])
% hold on;
Star.plotBoxes_2D_noFill(linear.Rb(1),1,2,'r');
legend([p1 p2],{'Linear','Nonlinear'});
title('Damped Oscillator - ILNODE');
xlabel('x_1');
ylabel('x_2');
VideoFrames(1) = getframe(f);
for n = 2:total_frames+1
    legend('off');
    Star.plotBoxes_2D_noFill(nonlinear_ps.Rb(n-1),1,2,'r');
    Star.plotBoxes_2D_noFill(linear.Rb(n),1,2,'b');
    legend([p1 p2],{'Linear','Nonlinear'});
    VideoFrames(n) = getframe(f);
end

% fig2 = figure;
% movie(fig2,VideoFrames,10);

% Create video one (Interval intermediate reach sets)
% create the video writer with 1 fps
writerObj = VideoWriter('demo2.avi');
writerObj.FrameRate = 5;
% open the video writer
open(writerObj);
% write the frames to the video
for u=1:length(VideoFrames)
    writeVideo(writerObj, VideoFrames(u));
end
% close the writer object
close(writerObj);