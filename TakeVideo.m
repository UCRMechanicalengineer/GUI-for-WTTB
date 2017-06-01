%This function starts the thorlabs camera and takes a video. 
function [Video] = TakeVideo(ExposureTime,Left,Right,Top,Bottom)

% Add NET assembly
% May need to change specific location of library
NET.addAssembly('C:\Program Files\Thorlabs\Scientific Imaging\DCx Camera Support\Develop\DotNet\uc480DotNet.dll');
% Create camera object handle
cam = uc480.Camera;
% Open the 1st available camera
cam.Init(0);
%Use the user input framerate from the GUI
cam.Timing.Exposure.Set(ExposureTime)

% Reshape image
Data = reshape(uint8(tmp), [Bits/8, Width, Height]);
Data = Data(1:3, 1:Width, 1:Height);
Data = permute(Data, [3,2,1]);
Data = Data(Top:Bottom,Left:Right,2);
Data = double(Data);
cam.Exit;