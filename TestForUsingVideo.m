%a test for using the video function
% Add NET assembly
% May need to change specific location of library
NET.addAssembly('C:\Program Files\Thorlabs\Scientific Imaging\DCx Camera Support\Develop\DotNet\uc480DotNet.dll');
% Create camera object handle
cam = uc480.Camera;
% Open the 1st available camera
cam.Init(0);
% Set display mode to bitmap (DiB)
cam.Display.Mode.Set(uc480.Defines.DisplayMode.DiB);
% Set color mode to 8-bit RGB
cam.PixelFormat.Set(uc480.Defines.ColorMode.RGBA8Packed);
%Use the user input framerate from the GUI
cam.Timing.Exposure.Set(ExposureTime)
% Allocate image memory
[~, MemId] = cam.Memory.Allocate(true);
% Obtain image information
[~, Width, Height, Bits,~] = cam.Memory.Inquire(MemId);
% Acquire image
camVid = cam.Acquisition.Capture();