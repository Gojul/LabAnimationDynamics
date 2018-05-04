clear all
clc
syms a b c d

%Open the video to get framerate and duration

VID = VideoReader('Clockwise_isometric.mp4');

%Set the croping values for the video
xmin = VID.width*0.25;
ymin = VID.height*0.15;
width = VID.width*0.4;
height = VID.height*0.7;

TIMESTART = 0; %sec
TIMEEND = VID.Duration; %sec
FPS = VID.Framerate;

%generate model
[T, Y] = ode45(@eom, [TIMESTART TIMEEND], [1; 1; 1; 1; 2; 3; 4; 5]);

%fps
t = linspace(TIMESTART,TIMEEND,TIMEEND*FPS);

%Define rotation matricies used to impose conditions

R01 = [cos(a) -sin(a) 0 ; sin(a) cos(a) 0; 0 0 1];
R12 = [1 0 0; 0 cos(b) -sin(b); 0 sin(b) cos(b)];
R23 = [cos(c) -sin(c) 0 ; sin(c) cos(c) 0; 0 0 1];
R34 = [cos(d) -sin(d) 0 ; sin(d) cos(d) 0; 0 0 1];

%Create the video file

video_file = VideoWriter('Animation.avi');
video_file.FrameRate = FPS;
open(video_file);

fig = figure('position',[0 0 1920 1080]);


FRAME = [0; 0; 10]; %Mock frame for testing just became random line
ROTOR = [0; 4; 0]; %Mock rotor for testing just became random line

%for every frame
for i = 1:numel(t)
    %intrapolate values of a b c and d
    for j = 1:(numel(T)-1)
            if T(j+1)>t(i)
                break
            end
    end
    a = Y(j,5)+t(i)*(Y(j+1,5)-Y(j,5))/(T(j+1)-T(j)); %alpha at time step
    b = Y(j,6)+t(i)*(Y(j+1,6)-Y(j,6))/(T(j+1)-T(j)); %beta at time step
    c = Y(j,7)+t(i)*(Y(j+1,7)-Y(j,7))/(T(j+1)-T(j)); %gamma at time step
    d = Y(j,8)+t(i)*(Y(j+1,8)-Y(j,8))/(T(j+1)-T(j)); %delta at time step
    %impose these rotations on 3D model
    
    STEP_FRAME = subs(R01*R12*R23*FRAME);
    STEP_ROTOR = subs(R01*R12*R23*R34*ROTOR);
    
    %plot model
    subplot(2,2,1) %Simulation top view
    title('Top view')
    %set axis to constants so it doesn't spaz out
    FRA = plot(STEP_FRAME);
    hold on
    ROT = plot(STEP_ROTOR);
    
    subplot(2,2,2) %Simulation side view
    title('Side view')
    
    subplot(2,2,3) %Simulation isometric view
    title('Isometric view')
    
    subplot(2,2,4) %Video
    VID_frame = imcrop(readFrame(VID),[xmin ymin width height]);
    imshow(VID_frame)
    title('Reference video')
    
    frame = getframe(fig);
    writeVideo(video_file,frame);
    
    %reset for next iteration
    if i < numel(t)
        delete(FRA)
        delete(ROT)
    end
end

close(video_file);
