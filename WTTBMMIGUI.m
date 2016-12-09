function varargout = WTTBMMIGUI(varargin)
% WTTBMMIGUI MATLAB code for WTTBMMIGUI.fig
%      WTTBMMIGUI, by itself, creates a new WTTBMMIGUI or raises the existing
%      singleton*.
%
%      H = WTTBMMIGUI returns the handle to a new WTTBMMIGUI or the handle to
%      the existing singleton*.
%
%      WTTBMMIGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WTTBMMIGUI.M with the given input arguments.
%
%      WTTBMMIGUI('Property','Value',...) creates a new WTTBMMIGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WTTBMMIGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WTTBMMIGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WTTBMMIGUI

% Last Modified by GUIDE v2.5 06-Dec-2016 07:31:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WTTBMMIGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @WTTBMMIGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before WTTBMMIGUI is made visible.
function WTTBMMIGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WTTBMMIGUI (see VARARGIN)

% Choose default command line output for WTTBMMIGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes WTTBMMIGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WTTBMMIGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbPreview.
function pbPreview_Callback(hObject, eventdata, handles)
% hObject    handle to pbPreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
% Allocate image memory
[~, MemId] = cam.Memory.Allocate(true);
% Obtain image information
[~, Width, Height, Bits, ~] = cam.Memory.Inquire(MemId);
% Acquire image
cam.Acquisition.Freeze(uc480.Defines.DeviceParameter.Wait);
% Copy image from memory
[~, tmp] = cam.Memory.CopyToArray(MemId);
% Reshape image
Data = reshape(uint8(tmp), [Bits/8, Width, Height]);
Data = Data(1:3, 1:Width, 1:Height);
Data = permute(Data, [3,2,1]);
% Display Image
himg = imshow(Data);
% Close camera
cam.Exit;

% --- Executes on button press in pbSaturation.
function pbSaturation_Callback(hObject, eventdata, handles)
% hObject    handle to pbSaturation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

TakePicture
% Display Image
himg = imshow(Data);
% Close camera
cam.Exit;
histogram(Data(:,:,:));
Datamaxcol = max(Data);
Datamaxrow = max(Datamaxcol);
Datamaxrowgrn = Datamaxrow(1,2);
xlabel('Pixel Values');
title(['          Max Value is ', num2str(Datamaxrowgrn) ,'']);
 
% --- Executes on button press in pbOrangeLinear.
function pbOrangeLinear_Callback(hObject, eventdata, handles)
% hObject    handle to pbOrangeLinear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Add NET assembly
% May need to change specific location of library
NET.addAssembly('C:\Program Files\Thorlabs\Scientific Imaging\DCx Camera Support\Develop\DotNet\uc480DotNet.dll');
% Create camera object handle
%Change for Git
cam = uc480.Camera;
% Open the 1st available camera
cam.Init(0);
% Set display mode to bitmap (DiB)
cam.Display.Mode.Set(uc480.Defines.DisplayMode.DiB);
% Set color mode to 8-bit RGB
cam.PixelFormat.Set(uc480.Defines.ColorMode.RGBA8Packed);
% Set trigger mode to software (single image acquisition)
cam.Trigger.Set(uc480.Defines.TriggerMode.Software);
%Get 5 Frames to average for the particular setting
cam.Trigger.Set(uc480.TriggerCounter.Reset(5));
% Allocate image memory
[~, MemId] = cam.Memory.Allocate(true);
% Obtain image information
[~, Width, Height, Bits, Frame] = cam.Memory.Inquire(MemId);
% Acquire image
cam.Acquisition.Freeze(uc480.Defines.DeviceParameter.Wait);
% Copy image from memory
[~, tmp] = cam.Memory.CopyToArray(MemId);
% Reshape image
Data = reshape(uint8(tmp), [Bits/8, Width, Height]);
Data = Data(1:3, 1:Width, 1:Height,1:Frame);
Data = permute(Data, [3,2,1]);
% Display Image
himg = imshow(Data);
% Close camera
cam.Exit;

% --- Executes on button press in pbGreenLinear.
function pbGreenLinear_Callback(hObject, eventdata, handles)
% hObject    handle to pbGreenLinear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pbBlueLinear.
function pbBlueLinear_Callback(hObject, eventdata, handles)
% hObject    handle to pbBlueLinear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pbBlueCircular.
function pbBlueCircular_Callback(hObject, eventdata, handles)
% hObject    handle to pbBlueCircular (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pbStokesVector.
function pbStokesVector_Callback(hObject, eventdata, handles)
% hObject    handle to pbStokesVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
