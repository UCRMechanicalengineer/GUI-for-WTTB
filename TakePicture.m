%This function starts the thorlabs camera and takes a picture. It outputs
%the picture as only the Green Channel of the RGB Matrix
function [Data] = TakePicture(ExposureTime,Left,Right,Top,Bottom)

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
% Set trigger mode to software (single image acquisition)
cam.Trigger.Set(uc480.Defines.TriggerMode.Software);
%Use the user input framerate from the GUI
cam.Timing.Exposure.Set(ExposureTime)
% Allocate image memory
[~, MemId] = cam.Memory.Allocate(true);
% Obtain image information
[~, Width, Height, Bits,~] = cam.Memory.Inquire(MemId);
% Acquire image
cam.Acquisition.Freeze(uc480.Defines.DeviceParameter.Wait);
% Copy image from memory
[~, tmp] = cam.Memory.CopyToArray(MemId);
% Reshape image
Data = reshape(uint8(tmp), [Bits/8, Width, Height]);
Data = Data(1:3, 1:Width, 1:Height);
Data = permute(Data, [3,2,1]);
Data = Data(Left:Right,Top:Bottom,:);
Data = Data(:,:,2);
cam.Exit;

